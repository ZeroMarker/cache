Class web.DHCWLEPRMRLoad Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 综合查询病案统计相关
/// 获取病案编目病人的信息
/// w ##Class(web.DHCWLEPRMRLoad).GetWMRPatNewMethod("2018-12-28","2019-01-02")
ClassMethod GetWMRPatNewMethod(SDate, EDate) As %String
{
	n (SDate,EDate)
	k ^TEMPDHCWLEPRLoad($j,"EPRPAT") ///global带回结果值
	s SDate=$ZDH(SDate,3)
	s EDate=$ZDH(EDate,3)
	For mDate=SDate:1:EDate {
		Set mTime=0
		For {
			Set mTime = $o(^DHCWMR.FP.FrontPageI("IndexBuildDate",1,mDate,mTime))
			Quit:mTime=""
			Set mMRFPId=""
			For {
				Set mMRFPId = $o(^DHCWMR.FP.FrontPageI("IndexBuildDate",1,mDate,mTime,mMRFPId))
				Quit:mMRFPId=""
				Set objFrontPage = ##class(DHCWMR.FP.FrontPage).GetObjById(mMRFPId)
				Continue:'$IsObject(objFrontPage)
				Set objVol = objFrontPage.FPVolumeDr
				Continue:'$IsObject(objVol)
				Set VolID=objVol.%Id()      
				Set objVolume = ##class(DHCWMR.SS.Volume).GetObjById(VolID)
				Continue:'$IsObject(objVolume)
				Set IsActive = objVolume.SVIsActive
				;Continue:IsActive'="Y"
				Continue:IsActive'="1"          
				
				Set xSub="",EpisodeID=""
				For {
					Set xSub=$o(^DHCWMR.SS.VolumeD(VolID,"P",xSub),-1)
					Quit:xSub=""
					Quit:EpisodeID'="" 
					Set VolPaadmID=VolID_"||"_xSub
					Set objVolPaadm=##Class(DHCWMR.SS.VolPaadm).GetObjById(VolPaadmID)
					Continue:'$IsObject(objVolPaadm)
					Set EpisodeID=objVolPaadm.VPEpisodeID
					q:EpisodeID=""
					s ^TEMPDHCWLEPRLoad($j,"EPRPAT",EpisodeID)=""
				}	
							
			}
		}

	}
	q "1"
}

Storage Default
{
<Data name="DHCWLEPRMRLoadDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCWLEPRMRLoadD</DataLocation>
<DefaultData>DHCWLEPRMRLoadDefaultData</DefaultData>
<IdLocation>^web.DHCWLEPRMRLoadD</IdLocation>
<IndexLocation>^web.DHCWLEPRMRLoadI</IndexLocation>
<StreamLocation>^web.DHCWLEPRMRLoadS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
