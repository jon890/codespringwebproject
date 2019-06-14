<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
	<meta charset="utf-8">
	<title>Home</title>
	<style>
		.uploadResult {
			width:100%;
			background-color:gray;
		}
		
		.uploadResult ul {
			display:flex;
			flex-flow:row;
			justify-content:center;
			align-items:center;
		}
		
		.uploadResult ul li {
			list-style:none;
			padding:10px;
			align-content: center;
			text-align: center;
		}
		
		.uploadResult ul li img{
			width:100px;
		}
		
		.uploadResult ul li span {
			color:white;
		}
		
		.bigPictureWrapper {
			position:absolute;
			display:none;
			justify-content:center;
			align-items:center;
			top:0%;
			width:100%;
			height:100%;
			background-color:gray;
			z-index:100;
			background:rgba(0,0,0,0.5);
		}
		
		.bigPicture {
			position:relative;
			display:flex;
			justify-content:center;
			align-items:center;
		}
		
		.bigPicture img {
			width:600px;
		}
	</style>
</head>

<body>
	
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>
	
	<h1>Upload with Ajax</h1>

	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	
	<div class="uploadResult">
		<ul>
		</ul>
	</div>
	
	<button id="uploadBtn">Upload</button>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
	
	<script>
	$(document).ready(function() {
		
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; // 5MB
		
		function checkExtension(fileName, fileSize) {
			
			if (fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}
			
			if (regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
		}
		
		var cloneObj = $(".uploadDiv").clone();
		
		$("#uploadBtn").on("click", function(e) {
			
			var formData = new FormData();
			
			var inputFile = $("input[name='uploadFile']");
			
			var files = inputFile[0].files;
			
			console.log(files);
			
			// add filedata to formdata
			for (var i=0; i<files.length; i++) {
				
				if (!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false,
				contentType: false,
				data: formData,
				type: 'POST',
				dataType: 'json',
				success: function(result) {
					
					console.log(result);
					
					showUploadedFile(result);
					
					$(".uploadDiv").html(cloneObj.html());
				}
			}); //$.ajax
		});
		
		// 파일 이름 출력 처리
		var uploadResult = $(".uploadResult ul");
		
		function showUploadedFile(uploadResultArr) {
			
			var str = "";
			
			$(uploadResultArr).each(function(i, obj) {
				
				if (!obj.image) {
					
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
					
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					
					str += "<li><div><a href='/download?fileName="+fileCallPath;
					str += "'<img src='/resources/img/attach.png'>";
					str += obj.fileName + "</a>";
					str += "<span data-file=\'"+fileCallPath+"\' data-type='file'> x </span></div></li>";
					
				} else {
					//str += "<li>" + obj.fileName + "</li>";
					
					// 썸네일 처리
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					
					var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
					
					originPath = originPath.replace(new RegExp(/\\/g), "/");
					
					str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\">" +
					 		"<img src='/display?fileName="+fileCallPath+"'>" +
					 		"<span data-file=\'"+fileCallPath+"\' data-type='image'> x </span></li>";
				}
			});
			
			uploadResult.append(str);
		}
		
		$(".bigPictureWrapper").on("click", function(e) {
			$(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
			/* setTimeout(() => {
				$(this).hide();
			}, 1000); */
			setTimeout(function() {
				$('.bigPictureWrapper').hide();
			}, 1000);
		});
	});
	
	// 원본 이미지 보여주기
	function showImage(fileCallPath) {
		
		//alert(fileCallPath);
		
		$(".bigPictureWrapper").css("display", "flex").show();
		
		$(".bigPicture")
			.html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>")
			.animate({width:'100%', height: '100%'}, 1000);
	}
	
	// x 표시에 대한 이벤트 처리
	$(".uploadResult").on("click", "span", function(e) {
		
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		console.log(targetFile);
		
		$.ajax({
			url: '/deleteFile',
			data: {fileName: targetFile, type:type},
			dataType: 'text',
			type: 'POST',
			success: function(result) {
				alert(result);
			}
		}); // $.ajax
	});
	</script>
	
</body>
</html>
