package org.zerock.sample;

import org.springframework.stereotype.Component;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;

// Spring 4.3 묵시적 생성자 주입
@Component
@ToString
@Getter
// 인스턴스 변수로 선언된 모든 것을 파라미터로 받는 생성자
@AllArgsConstructor
public class SampleHotel {

	private Chef chef;
	
}