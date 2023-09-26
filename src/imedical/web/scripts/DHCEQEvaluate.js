
function BodyLoadHandler()
{
	InitUserInfo();
	InitEvent();
	SetTableItem('','','');
	disabled();
}
function InitEvent()
{
	var obj=document.getElementById("BEvaluate");
	if (obj) obj.onclick=BEvaluate_Click;

}
function BEvaluate_Click()
{
	var truthBeTold = window.confirm("评价信息一旦保存则不能再次修改!确定保存?");
	if (!truthBeTold) return;
	var SourceType=GetElementValue("SourceType");
	var SourceID=GetElementValue("SourceID");
	var CurRole=GetElementValue("CurRole");
	var ERowID=GetElementValue("ERowID");
	var EvaluateGroupDR=GetElementValue("EvaluateGroupDR");
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth==""){return;}
	//主表信息
	var Eval="^"+SourceType+"^"+SourceID+"^^"+CurRole+"^"+"^^^^^"+"^^^"+ERowID
	//明细信息
	var plist=GetTableInfo(); //函数调用
	var result=cspRunServerMethod(encmeth,Eval,plist,"");
	result=result.replace(/\\n/g,"\n");
	if (result>0)
	{
		alertShow("保存成功!")
		location.reload();
		parent.frames["DHCEQEvaluateDetail"].location.reload()
	}
	else
	{
		alertShow("保存失败!")
		return
	}
	
//	旧版本评价
//	//var truthBeTold = window.confirm("评价信息已经保存后不能再次修改!确定保存?");
//	//if (!truthBeTold) return;
//	var SourceType=GetElementValue("SourceType");
//	var SourceID=GetElementValue("SourceID");
//	var CurRole=GetElementValue("CurRole");
//	var ERowID=GetElementValue("ERowID");
//	var EvaluateGroupDR=GetElementValue("EvaluateGroupDR");
//	var encmeth=GetElementValue("GetUpdate");
//	if (encmeth==""){return;}
//	var plist=GetTableInfo(); //函数调用
//	var result=cspRunServerMethod(encmeth,SourceType,SourceID,CurRole,ERowID,EvaluateGroupDR,plist);
//	result=result.replace(/\\n/g,"\n");
//	if (result>0)
//	{
//		alertShow("保存成功!")
//		location.reload();
//		parent.frames["DHCEQEvaluateDetail"].location.reload()
//	}
//	else
//	{
//		alertShow("保存失败!")
//		return
//	}	
}
function disabled()
{
	var ReturnStr=GetElementValue("CheckEvaluate");
	var CheckEvaluate=ReturnStr.split("^");
	var ReadOnly=0
	if (CheckEvaluate[0]==0) ReadOnly=1;	
	if ((CheckEvaluate[0]<0)||(ReadOnly==1))
	{
		DisableBElement("BEvaluate",true);
		return
	}
}
function GetTableInfo()
{
	//Modify DJ 2018-03-05
    var objtbl=document.getElementById('tDHCEQEvaluate');
	var rows=objtbl.rows.length;
	var valList="";	
	for(var i=1;i<rows;i++)
	{
		var TEvaluateTypeDR=GetElementValue("TEvaluateTypeDRz"+i);
		if (TEvaluateTypeDR=="")
		{
			alertShow("评价项目不能为空!")
			return
		}
		var TScore=GetElementValue("TScorez"+i);
		var TMaxScore=GetElementValue("TMaxScorez"+i);
		var TRemark=GetElementValue("TRemarkz"+i);
		var TEvaluateGroupDR=GetElementValue("TEvaluateGroupDRz"+i);
		if (valList!="") valList=valList+"*"
		valList=valList+i+"^^"+TEvaluateTypeDR+"^"+TScore+"^"+TRemark+"^"+TEvaluateGroupDR+"^^^"
	}
  	return valList;
//    var objtbl=document.getElementById('tDHCEQEvaluate');
//	var rows=objtbl.rows.length;
//	var valList="";
//	for(var i=1;i<rows;i++)
//	{
//		var TEvaluateTypeDR=GetElementValue("TEvaluateTypeDRz"+i);
//		if (TEvaluateTypeDR=="")
//		{
//			alertShow("评价项目不能为空!")
//			return
//		}
//		var TScore=GetElementValue("TScorez"+i);
//		var TMaxScore=GetElementValue("TMaxScorez"+i);
//		var TRemark=GetElementValue("TRemarkz"+i);
//		if (valList!="") valList=valList+"^"
//		valList=valList+TEvaluateTypeDR+"="+TScore+"="+TMaxScore+"="+TRemark
//	}
//  	return valList;
}
function SetTableItem(RowNo,SourceType,selectrow)
{
	var objtbl=document.getElementById('tDHCEQEvaluate');
	var rows=objtbl.rows.length-1;
	for (var i=1;i<=rows;i++)
	{
		ChangeRowStyle(objtbl.rows[i],SourceType);		///改变一行的内容显示
	}
}

///改变一行的内容显示
function ChangeRowStyle(RowObj,SourceType)
{
	for (var j=0;j<RowObj.cells.length;j++)
	{
		var html="";
		var value="";
		var MaxScoreStr=""
    	if (!RowObj.cells[j].firstChild) {continue}
    	
		var Id=RowObj.cells[j].firstChild.id;
		
		var offset=Id.lastIndexOf("z");
		var objindex=Id.substring(offset+1);
		var colName=Id.substring(0,offset);
		
		var objwidth=RowObj.cells[j].style.width;
		var objheight=RowObj.cells[j].style.height;
		if (colName=="TScore")
		{
			var MaxScore=GetElementValue("TMaxScorez"+objindex);
			for (var k=0;k<=MaxScore;k++)
			{
				if (MaxScoreStr!="")
				{
					MaxScoreStr=MaxScoreStr+"&";
				}
				MaxScoreStr=MaxScoreStr+k+"^"+k;
			}
			value=GetElementValue("TScorez"+objindex);
			html=CreatElementHtml(4,Id,100,objheight,"","",MaxScoreStr,"")
		}
		if (html!="") RowObj.cells[j].innerHTML=html;
	    if (value!="")
	    {
		    value=trim(value);
		    if (RowObj.cells[j].firstChild.tagName=="LABEL")
		    {
			    RowObj.cells[j].firstChild.innerText=value;
			}
			else if ((RowObj.cells[j].firstChild.tagName=="INPUT")&&(RowObj.cells[j].firstChild.type=="checkbox"))
		    {
			    RowObj.cells[j].firstChild.checked=value;
			}
			else
		    {
			    RowObj.cells[j].firstChild.value=value;
		    }
	    }
	}
}
document.body.onload = BodyLoadHandler;