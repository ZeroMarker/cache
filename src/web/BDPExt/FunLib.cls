Class web.BDPExt.FunLib Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2016-12-2
/// Description:获取返回json结果的id值
/// Input:str:{success:'true',id:'4444'}
/// Return:rowid :4444
/// Other:w ##class(web.BDPExt.FunLib).GetResultRowId("{success:'true',id:'4444'}")
ClassMethod GetResultRowId(str) As %String
{
	n (str)
	s rRowId=""
	s str=$tr(str,"{","")
	s str=$tr(str,"}","")
	s str=$tr(str,"""","")
	s str=$tr(str,"'","")
	s str=$tr(str,$c(34),"")
	if (str["success:true")
	{	
		s length=$l(str,",")
		for i=1:1:length
		{
			s istr=$p(str,",",i)
			s prop=$p(istr,":",1)
			if prop="id"
			{
				s rRowId=$p(istr,":",2)
			}			
		}
	}

	q rRowId
}

/// CreatDate:2016-12-2
/// Creator:陈莹
/// Description:拆分多表对应的实体类 ，拆分成具体对应表的实体类 （ 对于导入多表数据的时候调用）
/// w ##class(web.BDPExt.FunLib).TransObj(beobj, EntityClassname)
/// s Bedobj=##class(web.BDPExt.FunLib).TransObj(Ceobj,"web.Entity.CT.PACBed")
ClassMethod TransObj(beobj, EntityClassname) As %Library.RegisteredObject
{
	n (beobj,EntityClassname)
	s newobjstr="s aeobj=##class("_EntityClassname_").%New()"
	x newobjstr
	Set rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary") //取不到继承的类的属性
	do rsltSt.Execute(EntityClassname)
	While(rsltSt.Next()) {
		s propertyName=""
		set propertyName=rsltSt.Data("Name")
		if $zcvt(propertyName,"U")'["ROWID"
		{ 
		
			try
			{
				s estr="s aeobj."_propertyName_"=beobj."_propertyName
				x estr
			}
			catch
			{
				
			}
		}
	}
	
	try
	{
		x "s aeobj.LinkHospId=beobj.LinkHospId"
		
	}
	catch
	{
		
	}
	q aeobj
}

}
