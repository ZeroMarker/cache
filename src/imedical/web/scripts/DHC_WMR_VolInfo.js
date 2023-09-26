/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHCWMRVolInfo

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-6

COMMENT: 卷基本信息

========================================================================= */
function DHC_WMR_VolInfo()
{
	var obj = new Object();
	obj.Rowid = "";					//	DHC_WMR_VolInfo RowID
	obj.PatientName = "";			//	病人姓名
	obj.NameSpell = "";				//	姓名拼音码
	obj.Sex = "";					//	性别
	obj.Birthday = "";				//	生日
	obj.Age = "";					//	年龄
	obj.Wedlock = "";				//	婚姻
	obj.Occupation = "";			//	职业
	obj.City = "";					//	出生市
	obj.County = "";				//	出生县
	obj.Nation = "";				//	民族
	obj.Nationality = "";			//	国籍
	obj.IdentityCode = "";			//	身份证号
	obj.Company = "";				//	工作单位
	obj.CompanyTel = "";			//	工作单位电话
	obj.CompanyZip = "";			//	工作单位邮编
	obj.HomeAddress = "";			//	家庭住址
	obj.HomeTel = "";				//	家庭电话
	obj.HomeZip = "";				//	家庭邮编
	obj.RelationDesc = "";			//	与联系人关系
	obj.RelativeName = "";			//	联系人
	obj.RelativeTel = "";			//	联系人电话
	obj.RelativeAddress	 = "";		//联系人地址
	obj.IsActive = "";				//	是否有效
	obj.ResumeText = "";			//	备注
	obj.Volume_Dr = "";				//	病案的卷

	return obj;
}