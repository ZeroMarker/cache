/*
 * 预约限额模板维护 dhcpe.pretemplate.js
 * @Author wangguoying
 * @DateTime 2020-11-16
*/


var editFlag="undefined";

var templateDatagrid = $HUI.datagrid("#template-list",{
		
		url:$URL,
		fit : true,
		border : false,
		striped : false,
		fitColumns : true,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		
		queryParams:{
			ClassName:"web.DHCPE.PreTemplate",
			QueryName:"SerchPreNum"
			
		},
		columns:[[
			{field:'VIPID',hidden:true},
			{field:'Type',hidden:true},
			{field:'VIPDesc',width:100,title:'VIP等级'},
			{field:'NUM0',width:60,title:'周日',editor:'text'},
			{field:'NUM1',width:60,title:'周一',editor:'text'},
			{field:'NUM2',width:60,title:'周二',editor:'text'},
			{field:'NUM3',width:60,title:'周三',editor:'text'},
			{field:'NUM4',width:60,title:'周四',editor:'text'},
			{field:'NUM5',width:60,title:'周五',editor:'text'},
			{field:'NUM6',width:60,title:'周六',editor:'text'}
		]],
		onSelect:function(rowIndex,rowData){

			if (editFlag != "undefined") {
		    	$('#template-list').datagrid('endEdit', editFlag);
		    	editFlag = "undefined";
		    }
		},
		onDblClickRow: function(rowIndex,rowData){
			if(!$("#ModifyTime").switchbox("getValue")){
				$('#template-list').datagrid('beginEdit', rowIndex);
		    	editFlag = rowIndex;
			}	   
		},
		onDblClickCell: function(index,field,value){
			if($("#ModifyTime").switchbox("getValue")){
				modifyTime(index,field,value);
			}
		},	
		
	});
/**
 * [修改时段开关切换事件]
 * @Author   wangguoying
 * @DateTime 2020-11-16
 */
function modifyTime_change(){
	if($("#ModifyTime").switchbox("getValue")){  //开启修改时段时，判断行编辑状态
		if(editFlag != "undefined"){
			$('#template-list').datagrid('endEdit', editFlag);
			editFlag = "undefined";
		}
	}
}
/**
 * [修改时段]
 * @param    {[int]}    index [行号]
 * @param    {[String]}    field [单元格所在列名]
 * @param    {[String]}    value [值]
 * @Author   wangguoying
 * @DateTime 2020-11-16
 */
function modifyTime(index,field,value){
	var Arr=field.split("NUM");
	var WeekInfo=Arr[1];
	var rowData = $('#template-list').datagrid("getRows")[index];
	var LocID=session['LOGON.CTLOCID'];
	var ID=tkMakeServerCall("web.DHCPE.PreTemplate","GetOneID",LocID,rowData.VIPID,WeekInfo,rowData.Type);
	//var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEPreTemplateTime&Type=T&ParRef="+ID; //+"&ShowFlag=#(ShowFlag)#"
	   var lnk="dhcpepretemplatetime.hisui.csp?Type=T&ParRef="+ID;
	var nwin='hisui=true,title=预约限额模板维护,width=600,height=600';
	websys_lu(lnk,false,nwin);
}
function init(){
	//保存  
	$("#BUpdate").click(function() {	
		BUpdate_click();		
        });
     
    //创建   
   $("#BCreate").click(function() {	
		BCreate_click();		
        });
	
}
function BUpdate_click()
{
	if(editFlag != "undefined"){
		$('#template-list').datagrid('endEdit', editFlag);
		editFlag = "undefined";
	}
	var obj,VIPID,Type,Num,OneStr="",Str="",LocID,UserID,rows=0,encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=session['LOGON.USERID']; 
	var objtbl = $("#template-list").datagrid('getRows');
    var rows=objtbl.length
	for (var i=0;i<rows;i++){
		
		VIPID=objtbl[i].VIPID;
		OneStr=VIPID;
		Type=objtbl[i].Type;
		OneStr=OneStr+"^"+Type;
	    Num=objtbl[i].NUM1;		
		OneStr=OneStr+"^"+Num;
	    Num=objtbl[i].NUM2;		
		OneStr=OneStr+"^"+Num;
		Num=objtbl[i].NUM3;		
		OneStr=OneStr+"^"+Num;
		 Num=objtbl[i].NUM4;		
		OneStr=OneStr+"^"+Num;
	    Num=objtbl[i].NUM5;		
		OneStr=OneStr+"^"+Num;
		Num=objtbl[i].NUM6;		
		OneStr=OneStr+"^"+Num;
		Num=objtbl[i].NUM0;		
		OneStr=OneStr+"^"+Num;
		OneStr=OneStr+"^"+Num;
		if (Str==""){
			Str=OneStr;
		}else{
			Str=Str+"$"+OneStr;
		}
	}
	var ret=tkMakeServerCall("web.DHCPE.PreTemplate","Update",LocID,UserID,Str);
	if(ret==1) {
		$.messager.alert("提示","保存成功","success");
	}
	else {
		$.messager.alert("提示",ret,"info");
	}
}


function BCreate_click()
{
	var obj,LocID="",UserID="",StartDate="",EndDate="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=session['LOGON.USERID'];
	
	StartDate=getValueById("StartDate");
	EndDate=getValueById("EndDate");
	
	if ((StartDate=="")||(EndDate=="")){
		$.messager.alert("提示","日期不能为空","info");
		return false;
	}
	var ret=tkMakeServerCall("web.DHCPE.PreTemplate","CreateRecord",LocID,UserID,StartDate,EndDate);
	if(ret=="OVER") {
		$.messager.alert("提示","创建成功","success");
	}
	else {
		$.messager.alert("提示",ret,"info");
	}
}
$(init);