/*
模块:		静脉配液中心
子模块:		静脉配液中心-液体量维护
Creator:	hulihua
CreateDate:	2016-12-16
*/

var polid = "";
var url = "DHCST.PIVA.SETRULE.ACTION.csp";
$(function(){

	//初始化界面默认信息
	InitDefault();

	//初始化液体量
	QueryLiquid();
})

///初始化界面默认信息
function InitDefault(){
	polid=getParam("polid");  ///配液类别主表ID
}

///初始化液体量
function QueryLiquid(){
	var result=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","GetPivaCatLiquid",polid);
	if((result=="")||(result==null))
	{
		$('#POLMinVolume').focus()
		return;
	}
	$('#POLMinVolume').val(result.split("^")[0]);
	$('#POLMaxVolume').val(result.split("^")[1]);
}

/// 更新编辑行
function SaveData(){
	if(polid==""){		
		$.messager.alert('提示','请选择需要维护的配液分类！')
		return;	
	}
	
	var POLMinVolume=$('#POLMinVolume').val();
	var POLMaxVolume=$('#POLMaxVolume').val();		
	if((POLMinVolume=="")&&(POLMaxVolume=="")){
		$.messager.alert("提示","最小下限量和最大上限量不能同时为空!"); 
		return false;
	}
	if(POLMinVolume>POLMaxVolume){
		$.messager.alert("提示","最小下限量不能大于最大上限量!"); 
		return false;
	}
	var params=polid+"^^"+POLMinVolume+"^"+POLMaxVolume;
	//保存数据
	var savetype="2";
	var data=tkMakeServerCall("web.DHCSTPIVASETPIVACAT","SavePIVAOrderLink",params,savetype)
	if(data!=""){
		if(data==-1){
			$.messager.alert("提示","最小下限量和最大上限量同时为空,不能保存!"); 
		}else if(data==-2){	
			$.messager.alert('提示','更新失败!');		
		}else{	
			$.messager.alert('提示','更新成功!');		
		}
		QueryLiquid();
	}
}

///清空
function ClearLabel()
{ 
	$('#POLMinVolume').val(''); 
	$('#POLMaxVolume').val('');						
}