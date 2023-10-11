/*
 * FileName:	insutarcontrastpopup.js
 * User:		JINS 
 * Date:		2022-11-30
 * Description: 医保目录批量对照弹窗 
*/
var GUser=session['LOGON.USERID'];
var HospDr='';
var GlobalInsuType = '';
var GetList_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.DHCTarItem&pClassMethod=GetList";
$.extend($.fn.validatebox.defaults.rules, {
	checkZfblMaxAmt: {    
	    validator: function(value) {
		    return (value >=0)&&(value<=1);
		},
		message: "输入值不能小于0大于1"
	}
});
var Rq = INSUGetRequest();
	var TarConRowId = Rq["TarConRowId"];
	var INSUType=Rq["INSUType"];
	var HospDr=Rq["HospDr"];
	var HisID=Rq["HisID"];

	var INSUID="";
$(function () {
	

	
	//初始化combogrid    
	$HUI.combogrid("#Name",{  
		//idField: 'diccbxid', 
	    panelWidth:380,   
	    panelHeight:150,  
	    idField:'INTIMxmbm',   
	    textField:'INTIMxmmc', 
        pagination: false,
        delay:800,
	    columns:[[   
			{field: 'rowid', title: 'id', width: 20,hidden:true },
			{field: 'INTIMxmbm', title: "医保项目编码", width: 180},
			{field: 'INTIMxmmc', title: '医保项目名称', width: 180},
	    ]],
	    //fitColumns: true,  d ##class(%ResultSet).RunQuery("web.INSUTarItemsCom","QueryAll","1","0","00A","","","2")
        keyHandler:{  
			up: function(){},  
			down: function(){},  
			enter: function(){},  
			query:function(q){ 
				$(this).combogrid('grid').datagrid('unselectAll');
				//异步加载
				$.cm({
					ClassName: 'web.INSUTarItemsCom',
		            QueryName: 'QueryAll',
					txt:q,
		            Class:"3",
		            Type:"00A",
		            zfblTmp:"", 
					ExpStr:"0|全部",
					HospDr:HospDr,
					rows:1000			
				},function(jsonData){	
					
				
				
					$('#Name').combogrid('grid').datagrid('loadData',jsonData.rows);
					$('#Name').combogrid('setText',q);
				}); 
			}  
		},
		onSelect: function (record,selobj) {              //选中处理

			INSUID=selobj.rowid
		}
	}); 
	
	initEvent();
	
	
});	

/*function  InitChargesName(){
	var QueryDesc=getValueById('ChargesName');
	var dicSelid=0
	//初始化combogrid
	$HUI.combogrid("#ChargesName",{  
		//idField: 'diccbxid', 
	    panelWidth:520,   
	    panelHeight:300,  
	    idField:'INTIMxmbm',   
	    textField:'INTIMxmmc', 
        //rownumbers:true,
        pagination: false,
        delay:800,
	    columns:[[   
			{ field: 'rowid', title: 'rowid', width: 10, hidden:true },
			{field: 'INTIMxmbm', title: "医保项目编码", width: 180},
			{field: 'INTIMxmmc', title: '医保项目名称', width: 180},
	    ]],
	    //fitColumns: true,
        keyHandler:{  
			up: function(){},  
			down: function(){},  
			enter: function(){},  
			query:function(q){ 
				$(this).combogrid('grid').datagrid('unselectAll');
				//异步加载
				$.cm({
					ClassName: "web.INSUTarItemsCom",
		            QueryName: "QueryAll",
		
	               txt: QueryDesc,
		           Class: "0",
		            Type: INSUType,
		            zfblTmp: "",
		            ExpStr:"0|全部",
		            HospDr: HospDr,
					rows:1000
				},function(jsonData){	
					$('#ChargesName').combogrid('grid').datagrid('loadData',jsonData.rows);
					$('#ChargesName').combogrid('setText',q);
				}); 
			}  
		},
		onSelect: function (record,selobj) {              //选中处理

		
			
		}
	}); 
	

}
*/
/*function initChargesName() {
	
	$HUI.combogrid("#ChargesName", {
		panelWidth: 360,
		panelHeight: 150,
		striped: true,
		fitColumns: true,
		pagination: true,
		method: 'GET',
		idField: 'INTIMxmbm',
		textField: 'INTIMxmmc',
		columns: [[
			{ field: 'rowid', title: 'rowid', width: 10, hidden:true },
			{field: 'INTIMxmbm', title: "医保项目编码", width: 180},
			{field: 'INTIMxmmc', title: '医保项目名称', width: 180},
			]],
	
		
		onLoadSuccess: function (data) {
			var admIndexEd=data.total;
			if (admIndexEd>0)
			{
				var admdg = $('#ChargesName').combogrid('grid');	
				admdg.datagrid('selectRow',admIndexEd-1);	
			   
			  }


	},
	onLoadError:function(e){
		alert("error")
	},
	onSelect: function (index, row) {
	
		INSUID=
		
    

			   
	},

	});

}

*/



//更新医保目录对照收费项
function UpdateCon() {
var StartDate= getValueById('StartDate');
var EndDate= getValueById('EndDate');
var Account=getValueById('Number')
var userID = session['LOGON.USERID'];
//alert(INSUType)
if (INSUID=="")
{
	$.messager.alert("温馨提示",'医保目录不能为空' , 'info');
}
else{
 if(StartDate==""){
	
	$.messager.alert("温馨提示",'生效日期不能为空' , 'info');
}

 

 else{
	var rtn = $.m({ClassName: "web.INSUTarContrastQry", MethodName: "UpdateConTar", InString:TarConRowId,ActiveDate:StartDate,ExpiryDate:EndDate,Account:Account,HisID:HisID,INSUType:INSUType,userID:userID,INSUID:INSUID,HospDr:HospDr,}, false);
	if (rtn == '0'){
	  $.messager.alert("温馨提示",'添加成功' , 'info');
	  InsuSearch()
  }else{
	  $.messager.alert("温馨提示",'添加失败'  + rtn , 'info');
	  InsuSearch()
  }
 }
}
//alert(TarConRowId+StartDate+EndDate+Account+HisID+INSUType+userID+INSUID+HospDr)
//var UpdateStr = "^" + selTarData.TarId + "^" + selTarData.HisCode + "^" + (selTarData.HisDesc) + "^" + selInsuData.rowid + "^" + selInsuData.INTIMxmbm + "^" + (selInsuData.INTIMxmmc) + "^" + "^" + "^" + "^" + 1 + "^" + "^" + sconActDate + "^" + "^" + $('#insuType').combobox('getValue') + "^" + userID + "^" + "^";
//var savecode = tkMakeServerCall("web.INSUTarContrastCom", "Insert", "", "", UpdateStr);




	

}



function initEvent(){
	
	
	$("#btnU").click(function () {	
		
		UpdateCon();	
		
	});	 
	$("#btnC").click(function () {		
		websys_showModal('close');
	});
	}
