Class DHCWL.InterManagement.DHCWLCommon.StandRcTab Extends %RegisteredObject
{

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC001 性别值域代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC001()
ClassMethod RC001(mDate) As %Status
{
    q:mDate="" ""
	s mReturn=""
	i mDate["男" s mReturn=1
	i mDate["女" s mReturn=2
	i mDate["未说明的性别" s mReturn=9
	i mDate["未知的性别" s mReturn=0
	i mDate["" s mReturn=0
	Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC002 婚姻状况代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC002()
ClassMethod RC002(mDate) As %Status
{
    q:mDate="" ""
	s mReturn=""
	i mDate["未婚" s mReturn=1
	i mDate["已婚" s mReturn=2
	i mDate["丧偶" s mReturn=3
	i mDate["离婚" s mReturn=4
	i mDate["其他" s mReturn=9
	i mDate["" s mReturn=9
	Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC003 职业代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC003()
ClassMethod RC003(mDate) As %Status
{
 q:mDate="" ""
 s mReturn=""	
 i mDate["国家公务员"	s mReturn=11
 i mDate["专业技术人员"	s mReturn=13
 i mDate["职员"	s mReturn=17
 i mDate["企业管理人员"	s mReturn=21
 i mDate["工人"	s mReturn=24
 i mDate["农民"	s mReturn=27
 i mDate["学生"	s mReturn=31
 i mDate["现役军人"	s mReturn=37
 i mDate["自由职业者"	s mReturn=51
 i mDate["个体经营者"	s mReturn=54
 i mDate["无业人员"	s mReturn=70
 i mDate["退（离）休人员"	s mReturn=80
 i mDate["其他"	s mReturn=90
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC004 入院时情况代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC004()
ClassMethod RC004(mDate) As %Status
{
 q:mDate="" ""
 s mReturn=""	
 i mDate["危"	s mReturn=1
 i mDate["急"	s mReturn=2
 i mDate["一般"	s mReturn=3
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC005出院情况代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC005()
ClassMethod RC005(mDate) As %Status
{
 q:mDate="" ""
 s mReturn=""	
 i mDate["治愈"	s mReturn=1
 i mDate["好转"	s mReturn=2
 i mDate["未愈"	s mReturn=3
 i mDate["死亡"	s mReturn=4
 i mDate["其他"	s mReturn=9
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC006 过敏源代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC006()
ClassMethod RC006(mDate) As %Status
{
 q:mDate="" ""
 s mReturn=""	
 i mDate["镇静麻醉剂过敏"	s mReturn="01"
 i mDate["动物毛发过敏"	s mReturn="02"
 i mDate["抗生素过敏"	s mReturn="03"
 i mDate["柑橘类水果过敏"	s mReturn="04"
 i mDate["室内灰尘过敏"	s mReturn="05"
 i mDate["鸡蛋过敏"	s mReturn="06"
 i mDate["鱼及贝壳类食物过敏"	s mReturn="07"
 i mDate["碘过敏"	s mReturn="08"
 i mDate["牛奶过敏"	s mReturn="09"
 i mDate["带壳的果仁过敏"	s mReturn="10"
 i mDate["花粉过敏"	s mReturn="11"
 i mDate["其他过敏"	s mReturn="99"  
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC007 血液学检查结果代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC007()
ClassMethod RC007(mDate) As %Status
{
 q:mDate="" ""
 s mReturn=""	
 i mDate["未做"	s mReturn="0"
 i mDate["阴性"	s mReturn="1"
 i mDate["阳性"	s mReturn="2"
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC008 诊断符合情况代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC008()
ClassMethod RC008(mDate) As %Status
{
 q:mDate="" ""
 s mReturn=""	
 i mDate["符合"	s mReturn="1"
 i mDate["不符合"	s mReturn="2"
 i mDate["诊断符合情况扩充内容"	s mReturn="X"
 i mDate["无对照"	s mReturn="9"
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC009诊断依据代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC009()
ClassMethod RC009(mDate) As %Status
{
 q:mDate="" ""
 s mReturn=""	
 i mDate["临床"	s mReturn="1"
 i mDate["X线、CT、超声波、内窥镜等"	s mReturn="2"
 i mDate["手术"	s mReturn="3"
 i mDate["生化、免疫"	s mReturn="4"
 i mDate["细胞学、血片"	s mReturn="5"
 i mDate["病理"	s mReturn="6"
 i mDate["尸检（有病理）"	s mReturn="8"
 i mDate["不详"	s mReturn="9"
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC010 分化程度代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC010()
ClassMethod RC010(mDate) As %Status
{
 q:mDate="" ""
 s mReturn=""	
 i mDate["高分化"	s mReturn="1"
 i mDate["中分化"	s mReturn="2"
 i mDate["低分化"	s mReturn="3"
 i mDate["未分化"	s mReturn="4"
 i mDate["未确定"	s mReturn="9"
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC011 病案质量代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC011()
ClassMethod RC011(mDate) As %Status
{
 q:mDate="" ""	
 s mReturn=""	
 i mDate["甲"	s mReturn=1
 i mDate["乙"	s mReturn=2
 i mDate["丙"	s mReturn=3
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC012 手术操作部位代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC012()
ClassMethod RC012(mDate) As %Status
{
 q:mDate="" ""	
 s mReturn=""	
 i mDate["双侧鼻孔"	s mReturn="0001"
 i mDate["臀部"	s mReturn="0002"
 i mDate["左臂"	s mReturn="0003"
 i mDate["左前胸"	s mReturn="0004"
 i mDate["左肘前窝"	s mReturn="0005"
 i mDate["左三角肌"	s mReturn="0006"
 i mDate["左耳"	s mReturn="0007"
 i mDate["左外颈"	s mReturn="0008"
 i mDate["左足"	s mReturn="0009"
 i mDate["左臀中肌"	s mReturn="0010"
 i mDate["左手"	s mReturn="0011"
 i mDate["左内颈"	s mReturn="0012"
 i mDate["左下腹"	s mReturn="0013"
 i mDate["左下臂"	s mReturn="0014"
 i mDate["左中臂"	s mReturn="0015"
 i mDate["左侧鼻孔"	s mReturn="0016"
 i mDate["左后胸"	s mReturn="0017"
 i mDate["左锁骨下"	s mReturn="0018"
 i mDate["左大腿"	s mReturn="0019"
 i mDate["左上臂"	s mReturn="0020"
 i mDate["左上腹"	s mReturn="0021"
 i mDate["左腹侧臀肌"	s mReturn="0023"
 i mDate["左股外肌"	s mReturn="0024"
 i mDate["右眼"	s mReturn="0025"
 i mDate["左眼"	s mReturn="0026"
 i mDate["双眼"	s mReturn="0027"
 i mDate["肛门"	s mReturn="0028"
 i mDate["会阴"	s mReturn="0029"
 i mDate["右臂"	s mReturn="0030"
 i mDate["右前胸"	s mReturn="0031"
 i mDate["右肘前窝"	s mReturn="0032"
 i mDate["右侧三角肌"	s mReturn="0033"
 i mDate["右耳"	s mReturn="0034"
 i mDate["右外颈"	s mReturn="0035"
 i mDate["右足"	s mReturn="0036"
 i mDate["右臀中肌"	s mReturn="0037"
 i mDate["右手"	s mReturn="0038"
 i mDate["右内颈"	s mReturn="0039"
 i mDate["右下腹"	s mReturn="0040"
 i mDate["右下臂"	s mReturn="0041"
 i mDate["右中臂"	s mReturn="0042"
 i mDate["右后胸"	s mReturn="0043"
 i mDate["右锁骨下"	s mReturn="0044"
 i mDate["右大腿"	s mReturn="0045"
 i mDate["右上臂"	s mReturn="0046"
 i mDate["右上腹"	s mReturn="0047"
 i mDate["右腹侧臀肌"	s mReturn="0049"
 i mDate["右股外侧肌"	s mReturn="0050" 
 i mDate["其他"	s mReturn="9999"  
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-01-16
/// Description:：  RC013 麻醉方式代码表
/// Table：         
/// Input：         麻醉描述
/// Output：        标准代码
/// Return：        
/// Others：         w ##class(DHCWL.InterManagement.External.StandRcTab).RC013("全身麻醉")
ClassMethod RC013(mData As %String) As %String
{
 q:mData="" ""		
 s mReturn=""	
 i mDate["全身麻醉"	s mReturn="01"
 i mDate["吸入麻醉 （气管内插管、喉罩、面罩）"	s mReturn="0101"
 i mDate["静脉麻醉 （全凭静脉麻醉）"	s mReturn="0102"
 i mDate["静吸复合麻醉"	s mReturn="0103"
 i mDate["基础麻醉 （直肠注入、肌肉注射）"	s mReturn="0104"
 i mDate["区域麻醉"	s mReturn="02"
 i mDate["椎管内麻醉"	s mReturn="0201"
 i mDate["蛛网膜下腔阻滞"	s mReturn="020101"
 i mDate["硬膜外间隙阻滞（含骶管阻滞）"	s mReturn="020102"
 i mDate["蛛网膜下-硬膜外复合麻醉"	s mReturn="020103"
 i mDate["神经及神经丛阻滞"	s mReturn="0202"
 i mDate["颈丛阻滞"	s mReturn="020201"
 i mDate["臂丛阻滞及上肢神经阻滞"	s mReturn="020202"
 i mDate["腰骶神经丛阻滞及下肢神经阻滞"	s mReturn="020203"
 i mDate["躯干神经阻滞：肋间神经阻滞"	s mReturn="020204"
 i mDate["椎旁神经阻滞"	s mReturn="020205"
 i mDate["会阴神经阻滞"	s mReturn="020206"
 i mDate["交感神经阻滞：星状神经节阻滞"	s mReturn="020207"
 i mDate["胸腰交感神经阻滞	"	s mReturn="020208"
 i mDate["脑神经阻滞：三叉神经阻滞、舌咽神经阻滞"	s mReturn="020209"
 i mDate["局部麻醉"	s mReturn="03"
 i mDate["表面麻醉"	s mReturn="0301"
 i mDate["局部浸润麻醉"	s mReturn="0302"
 i mDate["局部阻滞麻醉"	s mReturn="0303"
 i mDate["静脉局部麻醉"	s mReturn="0304"
 i mDate["针刺镇痛与麻醉"	s mReturn="04"
 i mDate["复合麻醉"	s mReturn="05"
 i mDate["不同药物的复合：普鲁卡因静脉复合全麻，神经安定镇痛麻醉等"	s mReturn="0501"
 i mDate["不同方法的复合：静吸复合全麻，针药复合麻醉，全身-硬膜外复合麻醉，脊髓-硬膜外复合麻醉等"	s mReturn="0502"
 i mDate["特殊方法的复合：全麻复合全身降温（低温麻醉）， 控制性降压等"	s mReturn="0503"
 i mDate["其他"	s mReturn=99
 q $g(mReturn)
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC014 切口愈合等级代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC014()
ClassMethod RC014(mDate) As %Status
{
 q:mDate="" ""	
 s mReturn=""	
 i mDate["有手术，但体表无切口"	s mReturn=0
 i mDate["Ⅰ/甲"	s mReturn=1
 i mDate["Ⅰ/乙"	s mReturn=2
 i mDate["Ⅰ/丙"	s mReturn=3
 i mDate["Ⅰ/其他"	s mReturn=10
 i mDate["Ⅱ/甲"	s mReturn=4
 i mDate["Ⅱ/乙"	s mReturn=5
 i mDate["Ⅱ/丙"	s mReturn=6
 i mDate["Ⅱ/其他"	s mReturn=20
 i mDate["Ⅲ/甲"	s mReturn=7
 i mDate["Ⅲ/乙"	s mReturn=8
 i mDate["Ⅲ/丙"	s mReturn=9
 i mDate["Ⅲ/其他"	s mReturn=3
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC015 重症监护室代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC015()
ClassMethod RC015(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""	
 i mDate["重症监护室（科）"	s mReturn="61"
 i mDate["心脏监护室（CCU）"	s mReturn="6101"
 i mDate["呼吸监护室（RICU）"	s mReturn="6102"
 i mDate["外科监护室（SICU）"	s mReturn="6103"
 i mDate["新生儿监护室（NICU）"	s mReturn="6104"
 i mDate["儿科监护室（PICU）"	s mReturn="6105"
 i mDate["未列入上述名称的监护室"	s mReturn="6106"   
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC016 判断代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC016()
ClassMethod RC016(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""	
 i mDate["是"	s mReturn=1
 i mDate["否"	s mReturn=2
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC017 随诊判断代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC017()
ClassMethod RC017(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""	
 i mDate["是"	s mReturn=1
 i mDate["否"	s mReturn=2
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC018 随诊判断代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC018()
ClassMethod RC018(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""
 i mDate["未输"	s mReturn=0	
 i mDate["有"	s mReturn=1
 i mDate["无"	s mReturn=2
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC019 离院方式代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC019()
ClassMethod RC019(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""	
 i mDate["医嘱离院"	s mReturn=1
 i mDate["医嘱转院"	s mReturn=2
 i mDate["医嘱转社区卫生服务机构/乡镇卫生院"	s mReturn=3
 i mDate["非医嘱离院"	s mReturn=4
 i mDate["死亡"	s mReturn=5
 i mDate["其他"	s mReturn=9
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC024 麻醉分级代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC024()
ClassMethod RC024(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""	
 i mDate["ASAP1级"	s mReturn=1
 i mDate["ASAP2级"	s mReturn=2
 i mDate["ASAP3级"	s mReturn=3
 i mDate["ASAP4级"	s mReturn=4
 i mDate["ASAP5级"	s mReturn=5
 i mDate["ASAP6级"	s mReturn=6
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC026 入院途径代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC026()
ClassMethod RC026(mDate) As %Status
{
	q:mDate="" ""	 
	s ret="" 
	i mDate["门" s ret="2"
	i mDate["急" s ret="1"
	i mDate["其他医疗机构转入" s ret="3"
	i (mDate'["门")&&(mDate'["急")&&(mDate'["其他医疗机构转入") s ret="9"
	Q ret
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC027 入院病情代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC027()
ClassMethod RC027(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""	
 i mDate["有"	s mReturn=1
 i mDate["临床未确定"	s mReturn=2
 i mDate["情况不明"	s mReturn=3
 i mDate["无"	s mReturn=4
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC028 出院31天内再住院计划代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC028()
ClassMethod RC028(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""		
 i mDate["无"	s mReturn=1
 i mDate["有"	s mReturn=2
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC029 手术级别代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC029()
ClassMethod RC029(mDate) As %Status
{
 s mReturn=""		
 i mDate["一级手术"	s mReturn=1
 i mDate["二级手术"	s mReturn=2
 i mDate["三级手术"	s mReturn=3
 i mDate["四级手术"	s mReturn=4
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC030 ABO血型代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC030()
ClassMethod RC030(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""		 
 i mDate["A型"	s mReturn=1
 i mDate["B型"	s mReturn=2
 i mDate["O型"	s mReturn=3
 i mDate["AB型"	s mReturn=4
 i mDate["不详"	s mReturn=5
 i mDate["未查"	s mReturn=6
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC031 Rh血型代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC031()
ClassMethod RC031(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""	
 i mDate["阴性"	s mReturn=1
 i mDate["阳性"	s mReturn=2
 i mDate["不详"	s mReturn=3
 i mDate["未查"	s mReturn=4
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC032 医疗付费方式代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC032()
ClassMethod RC032(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""	
 i mDate["本市城镇职工基本医疗保险"	s mReturn=1.1
 i mDate["外埠城镇职工基本医疗保险"	s mReturn=1.2
 i mDate["本市城乡居民基本医疗保险"	s mReturn=2.1
 i mDate["外埠城镇居民基本医疗保险"	s mReturn=2.2
 i mDate["本市新型农村合作医疗"	s mReturn=3.1
 i mDate["外埠新型农村合作医疗"	s mReturn=3.2
 i mDate["贫困救助"	s mReturn=4
 i mDate["商业医疗保险"	s mReturn=5
 i mDate["全公费"	s mReturn=6
 i mDate["全自费"	s mReturn=7
 i mDate["其他社会保险"	s mReturn=8
 i mDate["其他"	s mReturn=9
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC033 联系人关系代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC033()
ClassMethod RC033(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""	 
 i mDate["本人或户主"	s mReturn=0
 i mDate["配偶"	s mReturn=1
 i mDate["子"	s mReturn=2
 i mDate["女"	s mReturn=3
 i mDate["孙子、孙女或外孙子、外孙女"	s mReturn=4
 i mDate["父母"	s mReturn=5
 i mDate["祖父母或外祖父母"	s mReturn=6
 i mDate["兄弟姐妹"	s mReturn=7
 i mDate["同事同学"	s mReturn=8
 i mDate["其他"	s mReturn=9
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC037 有无药物过敏表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC037()
ClassMethod RC037(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""
 i mDate["无"	s mReturn=1
 i mDate["有"	s mReturn=2
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC040 流感检测代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC040()
ClassMethod RC040(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""
 i mDate["快速抗原检测-胶体金/酶层析法"	s mReturn=1
 i mDate["快速抗原检测-Elisa法"	s mReturn=2
 i mDate["流感核酸法-实时荧光定量RT-PCR"	s mReturn=3
 i mDate["流感核酸法-快速PCR（甲型/乙型流感及呼吸道合胞病毒核酸联合检测等其他多重PCR）"	s mReturn=4
 i mDate["流感核酸法-7/13种呼吸道病原核酸检测"	s mReturn=5
 i mDate["免疫荧光法-呼吸道标本"	s mReturn=6
 i mDate["免疫荧光法-血清"	s mReturn=7
 i mDate["其他"	s mReturn=99
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  RC041 流感检验阳性代码表
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).RC041()
ClassMethod RC041(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""
 i mDate["H1N1"	s mReturn="1"
 i mDate["H3N2"	s mReturn="2"
 i mDate["H3N8"	s mReturn="3"
 i mDate["H5N1"	s mReturn="4"
 i mDate["H5N2"	s mReturn="5"
 i mDate["H5N3"	s mReturn="6"
 i mDate["H5N4"	s mReturn="7"
 i mDate["H5N5"	s mReturn="8"
 i mDate["H5N6"	s mReturn="9"
 i mDate["H5N7"	s mReturn="10"
 i mDate["H5N8"	s mReturn="11"
 i mDate["H5N9"	s mReturn="12"
 i mDate["H7N1"	s mReturn="13"
 i mDate["H7N2"	s mReturn="14"
 i mDate["H7N3"	s mReturn="15"
 i mDate["H7N4"	s mReturn="16"
 i mDate["H7N5"	s mReturn="17"
 i mDate["H7N6"	s mReturn="18"
 i mDate["H7N7"	s mReturn="19"
 i mDate["H7N8"	s mReturn="20"
 i mDate["H7N9"	s mReturn="21"
 i mDate["H9N1"	s mReturn="22"
 i mDate["H9N2"	s mReturn="23"
 i mDate["H9N3"	s mReturn="24"
 i mDate["H9N4"	s mReturn="25"
 i mDate["H9N5"	s mReturn="26"
 i mDate["H9N6"	s mReturn="27"
 i mDate["H9N7"	s mReturn="28"
 i mDate["H9N8"	s mReturn="29"
 i mDate["H9N9"	s mReturn="30"
 i mDate["H10N8"	s mReturn="31"
 i mDate["H10N7"	s mReturn="32"
 i mDate["H6N8"	s mReturn="33"
 i mDate["H2N2"	s mReturn="34"
 i mDate["甲流"	s mReturn="35"
 i mDate["乙流"	s mReturn="36"
 i mDate["其他"	s mReturn="99"
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  CT01.00.001 业务活动类别代码
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).CT0100001()
ClassMethod CT0100001(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""
 i mDate["门诊"	s mReturn=1
 i mDate["急诊"	s mReturn=2
 i mDate["住院"	s mReturn=3
 i mDate["体检"	s mReturn=4
 i mDate["运营"	s mReturn=5
 i mDate["其他"	s mReturn=9
 Q mReturn
}

/// Creator：       PL
/// CreatDate：     2019-11-03
/// Description:：  CV02.01.101身份证件类别代码
/// Table：         
/// Input：         
/// Output：        
/// Return：        代码
/// Others：        w ##class(DHCWL.InterManagement.External.StandRcTab).CV0201101()
ClassMethod CV0201101(mDate) As %Status
{
 q:mDate="" ""		
 s mReturn=""
 i mDate["居民身份证"	s mReturn="01"
 i mDate["居民户口本"	s mReturn="02"
 i mDate["护照"	s mReturn="03"
 i mDate["军官证"	s mReturn="04"
 i mDate["驾驶证"	s mReturn="05"
 i mDate["港澳居民来往内地通行证"	s mReturn="06"
 i mDate["台湾居民来往内地通行证"	s mReturn="07"
 i mDate["母亲身份证"	s mReturn="19"
 i mDate["其他法定有效证件"	s mReturn="99"   
 Q mReturn
}

}
