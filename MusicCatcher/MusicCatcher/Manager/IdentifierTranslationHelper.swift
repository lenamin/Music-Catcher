//
//  IdentifierTranslationHelper.swift
//  MusicCatcher
//
//  Created by Lena on 10/30/23.
//


import Foundation

class IdentifierTranslationHelper {
    
    var identifier = Dictionary<String, String>()

    init() {
        identifier["percussion"] = "퍼커션"
        identifier["foghorn"] = "혼 (forhorn)"
        identifier["applause"] = "박수"
        identifier["ukulele"] = "우쿠렐레"
        identifier["organ"] = "오르간"
        identifier["theremin"] = "테르민 (theremin) "
        identifier["hi_hat"] = "하이햇"
        identifier["harp"] = "하프"
        identifier["water"] = "물"
        identifier["zither"] = "지타 (zither) "
        identifier["acoustic_guitar"] = "어쿠스틱 기타"
        identifier["clarinet"] = "클라리넷"
        identifier["hammond_organ"] = "오르간"
        identifier["saxophone"] = "색소폰"
        identifier["rattle_instrument"] = "래틀 (rattle)"
        identifier["humming"] = "허밍"
        identifier["bell"] = "벨"
        identifier["wind_chime"] = "윈드차임 "
        identifier["singing_bowl"] = "싱잉볼"
        identifier["bowed_string_instrument"] = "현악기 "
        identifier["bass_guitar"] = "베이스기타"
        identifier["electronic_organ"] = "전자오르간"
        identifier["bass_drum"] = "베이스 드럼"
        identifier["reverse_beeps"] = "비프음 "
        identifier["clapping"] = "박수 "
        identifier["tabla"] = "타블라 (tabla) "
        identifier["synthesizer"] = "신디사이저"
        identifier["tap"] = "탭 "
        identifier["piano"] = "피아노"
        identifier["tambourine"] = "탬버린"
        identifier["singing"] = "노래부르는 "
        identifier["brass_instrument"] = "금관악기 "
        identifier["didgeridoo"] = "디저리두 (didgeridoo) "
        identifier["guitar"] = "기타"
        identifier["keyboard_musical"] = "건반"
        identifier["accordion"] = "아코디언"
        identifier["drum"] = "드럼"
        identifier["cello"] = "첼로"
        identifier["plucked_string_instrument"] = "현악기 튕기는 "
        identifier["gong"] = "타악기 공"
        identifier["trombone"] = "트럼본"
        identifier["trumpet"] = "트럼펫"
        identifier["cowbell"] = "카우벨 "
        identifier["rapping"] = "랩하는 "
        identifier["vibraphone"] = "비브라폰 "
        identifier["harpsichord"] = "하프시코드"
        identifier["disc_scratching"] = "디제잉"
        identifier["bassoon"] = "바순 "
        identifier["sitar"] = "시타르 (sitar)"
        identifier["flute"] = "플룻"
        identifier["harmonica"] = "하모니카"
        identifier["steel_guitar_slide_guitar"] = "기타 슬라이딩"
        identifier["finger_snapping"] = "스냅 "
        identifier["oboe"] = "오보에"
        identifier["chime"] = "차임벨 "
        identifier["choir_singing"] = "합창단 "
        identifier["drum_kit"] = "드럼"
        identifier["mallet_percussion"] = "말렛 퍼커션"
        identifier["snare_drum"] = "스네어드럼 "
        identifier["church_bell"] = "종"
        identifier["electric_guitar"] = "일렉기타 "
        identifier["orchestra"] = "오케스트라"
        identifier["electric_piano"] = "전자피아노"
        identifier["guitar_strum"] = "기타 스트럼 "
        identifier["wind_noise_microphone"] = "마이크 노이즈 "
        identifier["guitar_tapping"] = "기타 태핑"
        identifier["glockenspiel"] = "글로켄슈필"
        identifier["timpani"] = "팀파니"
        identifier["cymbal"] = "심벌"
        identifier["mandolin"] = "만돌린"
        identifier["wind_instrument"] = "목관악기 "
        identifier["banjo"] = "밴조"
        identifier["marimba_xylophone"] = "마림바나 실로폰"
        identifier["violin_fiddle"] = "바이올린"
        identifier["french_horn"] = "프렌치 호른"
    }
}