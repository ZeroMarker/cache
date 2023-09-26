var UserId=session['LOGON.USERID']
$("#GSID").val(GSID);
var editIndex=undefined;

document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{

	
	var obj=document.getElementById("OK");
	if(obj) obj.onclick=SaveGSSDetail;
	var obj=document.getElementById("Cancel");
	if(obj) obj.onclick=Close;
	
	
	
	
	
}

function GSSDetailKeyDown()
{
	return ;
	if(window.event.keyCode != 32) return;
	var curtr = document.getElementById("GSSDetail");
	var o = document.createElement("<span style='width:20px; background-color:white;margin:0px;padding:0px;'></span>");
	curtr.appendChild(o);
	window.event.returnValue = false; 
}
function setTextSelected(inputDom, startIndex, endIndex)
 {
	if (CurisIE()=="-1"){
		if (inputDom.setSelectionRange)
		{  
			inputDom.setSelectionRange(startIndex, endIndex);  
		}
	}
    else if (inputDom.createTextRange) //IE 
    {
         var range = inputDom.createTextRange();  
        range.collapse(true);  
        range.moveStart('character', startIndex);  
        range.moveEnd('character', endIndex - startIndex-1);  
        range.select();
     }  
	   inputDom.focus();  
}
//判断是否是IE浏览器  
function CurisIE()  
{  
	var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串 
	var isOpera = userAgent.indexOf("Opera") > -1
	var cisIE = userAgent.indexOf("compatible") > -1  && userAgent.indexOf("MSIE") > -1 && !isOpera; //判断是否IE浏览器  
	if(cisIE)  
	{  
		return "1";  
	}  
	else  
	{  
		if (userAgent.indexOf("rv:11.0") > -1) return "1";  //ie11
		return "-1";  
	}  
}

function setTareaAutoHeight(e) {
    //e.style.height = e.scrollHeight + "px";
	if (e.scrollHeight<32){
		e.style.height=32+"px";
	}else{
		e.style.height = e.scrollHeight + "px";
	}
	websys_setfocus('OK');
}
function SaveGSSDetail()
{
	
	var obj,encmeth,GSID,GSSDetail;
	
	var obj=document.getElementById("UpdateGSSDetail");
	if (obj) var encmeth=obj.value;
	obj=document.getElementById("GSID");
	if (obj) GSID=obj.value;
	obj=document.getElementById("GSSDetail");
	if (obj) GSSDetail=obj.value;
	
	var GSSYGDetail="";
	obj=document.getElementById("YGGSSDetail");
	if (obj) GSSYGDetail=obj.value;
	
	//var ret=cspRunServerMethod(encmeth,GSID,GSSDetail);
	var ret=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","UpdateGSSDetail",GSID,GSSDetail,GSSYGDetail);
	
	if(ret.split("^")[0]!=-1)
	{
		var Old=tkMakeServerCall("web.DHCPE.ModifyRecord","GetInfo",GSID,"GSSDetail")
		
		var Info=tkMakeServerCall("web.DHCPE.ModifyRecord","Save",GSID,"GSSDetail",Old,GSSDetail,UserId)
	}
	$("#CloseFlag").val(ret);
	parent.$('#GSSDetailWin').window('close');  
	return false;
	
	
}
function Close()
{
	$("#CloseFlag").val("0");
	parent.$('#GSSDetailWin').window('close'); 
	return false;
}
function DeleteGSIllness(GSIll)
{
	
	$.messager.confirm("删除", "确定要删除吗?", function (r) {
				if (r) {
					InString=GSIll+"^^^"+UserId+"^"
				
				var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","UpdateGSIllness",InString,2);
				if (flag.split("^")[0]!="-1")
				{
					$("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
					editIndex=undefined;
				}
				else
				{
					$.messager.alert("提示", flag.split("^")[1], "info");
					$("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
					editIndex=undefined;
				}
				} else {
					return false;
				}
			});
				
}


function endEditing(){
			if (editIndex == undefined){return true}
			if ($('#GSIllness').datagrid('validateRow', editIndex)){
				
				$('#GSIllness').datagrid('endEdit', editIndex);
				
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
}

function IllnessClickRow(index){
		if (editIndex!=index) {
			if (endEditing()){
				$('#GSIllness').datagrid('selectRow',index).datagrid('beginEdit',index);
				editIndex = index;
			} else {
				$('#GSIllness').datagrid('selectRow',editIndex);
			}
		}
}

var init = function(){
	
	
	var IllnessStandardObj = $HUI.combobox("#IllnessStandard",{
		url:$URL+"?ClassName=web.DHCPE.IllnessStandard&QueryName=GetEDiagnosisByAlias&ResultSetType=array",
		valueField:'HIDDEN',
		textField:'Detail'
		})
	
	var GSIllnessObj = $HUI.datagrid("#GSIllness",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.ResultDiagnosisNew",
			QueryName:"FindGSIllness",
			GSID:GSID

		},
		fitColumns:true,
		singleSelect:false,
		checkOnSelect:true,
		selectOnCheck:true,
		rownumbers:true,
		onClickRow: IllnessClickRow,
		toolbar:[{
			iconCls:'icon-add',
			text:'新增',
			handler: function(){
				
				
				if(editIndex != undefined)
				{
					$.messager.alert("提示","还有未保存的数据，请点击修改!","info");	
					return false;
					
				}
				else
				{
				$('#GSIllness').datagrid('insertRow',{
					index: 0,
					row: {
						GSIll:'',
						GSIllnessID:'',
						GSIType:''
						}
				});
				IllnessClickRow(0);
				}
				
				
				
			}
		},{
			iconCls:'icon-write-order',
			text:'修改',
			handler: function(){
				
				endEditing();
				
			}
		},{
			iconCls:'icon-cancel',
			text:'删除',
			handler: function(){
				
				$.messager.confirm("删除", "确定要删除吗?", function (r) {
				if (r) {
					var flag="";	
			
			 var rows = $("#GSIllness").datagrid("getChecked");//获取的是数组，多行数据
			 if(rows.length==0)
			 {
				 $.messager.alert("提示","请选择删除的行!","info");	
				 return false;
				 
			 }
			 for(var i=0;i<rows.length;i++){
				 
				var GSIID=rows[i].GSIll;
				
				if(GSIID=="")
				{
					$.messager.alert("提示","请选择删除的行!","info");	
					return false;
				}
				var InString=GSIID+"^^^"+UserId+"^"
				
				flag=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","UpdateGSIllness",InString,2);
				

				 
				 
			 }
			 if (flag.split("^")[0]!="-1")
				{
					$("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
					editIndex=undefined;
				}	
			else
			{
				
				$.messager.alert("提示", flag.split("^")[1], "info");
				$("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
				editIndex=undefined;
			}
				
			
				} else {
					return false;
				}
			})
		}
		}
		],
		columns:[[
			{field:'select',checkbox:true},
			{field:'operate',title:'操作',
			formatter:function(value,row,index){
					
				return "<a href='#' onclick='DeleteGSIllness(\""+row.GSIll+"\")'>\
						<img style='padding-left:7px;' title='删除疾病111' src='../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png' border=0/>\
					   </a>";
					
			}},
			{field:'GSIll',hidden:true},
			{field:'GSIllnessID',title:'疾病名称',width:150,
		    		formatter:function(value,row){
						return row.IllnessDesc;
					},
		    		editor:{
					type:'combobox',
					options:{
						valueField:'HIDDEN',
						textField:'Detail',
						method:'get',
						url:$URL+"?ClassName=web.DHCPE.IllnessStandard&QueryName=GetEDiagnosisByAlias&ResultSetType=array",
						onBeforeLoad:function(param){
							
							
							}
						
					}
				}
			}
			
			
		]],
		onAfterEdit:function(rowIndex,rowData,changes){
			
			
			var RowID=rowData.GSIll
			var IllID=rowData.GSIllnessID
			if(IllID=="")
			{
				$.messager.alert("提示","疾病不能为空！","info");
				$("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
				editIndex=undefined;
				return false;
				
			}
			var GSIType=rowData.GSIType
			if (GSIType=="") GSIType="D"
			
			var InString=RowID+"^"+IllID+"^"+GSID+"^"+UserId+"^"+GSIType;
			
			var flag=tkMakeServerCall("web.DHCPE.ResultDiagnosisNew","UpdateGSIllness",InString,0);
			if (flag.split("^")[0]!="-1")
			{
				$("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
			
			}
			else
			{
				$.messager.alert("提示", flag.split("^")[1], "info");
				$("#GSIllness").datagrid("load",{ClassName:"web.DHCPE.ResultDiagnosisNew",QueryName:"FindGSIllness",GSID:GSID}); 
				editIndex=undefined;
				
			}
			editIndex=undefined;
			
		},
		onSelect: function (rowIndex, rowData) {
			setValueById("GSIID",rowData.GSIll)
		},
		onLoadSuccess: function () {
        	$(".datagrid-header-inner").removeClass();
        	editIndex=undefined;
        }
		
		});
	
	
}

$(init);