
/*
 * FileName:    dhcpereibaseinfo.list.hisui.js
 * Author:      xy
 * Date:        20221206
 * Description: 个人基本信息维护
 */
 
 $(function(){
	 
	//下拉列表框
	InitCombobox();
	
	//初始化列表
	InitPreIBaseInfoListGrid();
	
	$("#RegNo").keydown(function (e) {
		if (e.keyCode == 13) {
			BFind_click();
		}
	});
	
	$("#Name").keydown(function (e) {
		if (e.keyCode == 13) {
			BFind_click();
		}
	});
	
	//查询
	$("#BFind").click(function() {	
		BFind_click();		
     });
    
	//清屏
	$("#BClear").click(function() {	
		BClear_click();		
     });
     
    //新增
    $("#BAdd").click(function() {	
		BAdd_click();		
     });
     
})


//清屏
function BClear_click(){
	$("#RegNo,#Name,#IDCard").val("");
	$("#Birth").datebox('setValue',"");
	$(".hisui-combobox").combobox('setValue',"");
	BFind_click();
}

//查询
function BFind_click(){
	
	var CTLocID=session['LOGON.CTLOCID'];
	var HospID=session['LOGON.HOSPID'];
	
	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
	var iRegNo=	$("#RegNo").val();
	if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
			iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
			$("#RegNo").val(iRegNo);
	}
	
	var iName=$("#Name").val();
	
	var iBirth=$("#Birth").datebox('getValue');
	
    var iSex=$("#Sex").combobox('getValue');
    
    var iPAPMICardType=$("#PAPMICardType").combobox('getValue');
    
    var iPatType=$("#PatType").combobox('getValue');
	
	var iIDCard=$("#IDCard").val();
	
	$("#PreIBaseInfoListGrid").datagrid('load',{
		ClassName:"web.DHCPE.PreIBaseInfo",
		QueryName:"SearchPreIBaseInfo",
		RegNo:iRegNo,
		PatName:iName,
		PatType:iPatType,
		PatSex:iSex,
		PatDOB:iBirth,
		PatIDCard:iIDCard,
		PAPMICardType:iPAPMICardType,
		CTLocID:CTLocID,
		HospID:HospID
	});
	
}

//修改日志
function BModifyRecord(PIBIRowId){
	var lnk="dhcpemodifyrecord.hisui.csp"+"?SourceID="+PIBIRowId+"&SourceType="+"IBaseInfo";
	 websys_lu(lnk,false,'width=1095,height=653,hisui=true,title='+$g("个人基本信息修改日志"))
}

//登记号链接
function BIBaseInfoEdit(PIBIRowId){
	var lnk="dhcpepreibaseinfonew.edit.hisui.csp"+"?ID="+PIBIRowId+"&OperType="+"M";
	 websys_lu(lnk,false,'width=795,height=630,hisui=true,title='+$g("个人基本信息维护"))
}

//新增
function BAdd_click()
{
	var lnk="dhcpepreibaseinfo.edit.hisui.csp";
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=655,height=630,hisui=true,title='+$g("个人基本信息维护"))
}


function InitPreIBaseInfoListGrid()
{

	$HUI.datagrid("#PreIBaseInfoListGrid",{
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,  
		rownumbers : true,  
		pageSize: 20,
		pageList : [20,100,200],
		singleSelect: true,
		selectOnCheck: false,
		queryParams:{
			ClassName:"web.DHCPE.PreIBaseInfo",
			QueryName:"SearchPreIBaseInfo",
			
		},
        frozenColumns:[[
        	{field:'TModifyRecord',width:90,title:'修改日志',align:'center',
				formatter:function(value,rowData,rowIndex){	
					return "<span style='cursor:pointer;' class='icon-paper' onclick='BModifyRecord("+rowData.PIBI_RowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
			    /*
				if(HISUIStyleCode=="lite"){
				    	return "<span style='cursor:pointer;' class='icon-paper' onclick='BModifyRecord("+rowData.PIBI_RowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
				    }else{
						return '<a><img  src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="修改日志" border="0" onclick="BModifyRecord('+rowData.PIBI_RowId+')"></a>';
				    }
				*/
				    
				 
			}},
			{field:'PIBI_PAPMINo',width:120,title:'登记号',
				formatter:function(value,rowData,rowIndex){	
					return "<a href='#'  class='grid-td-text' onclick=BIBaseInfoEdit("+rowData.PIBI_RowId+"\)>"+value+"</a>";
					
			}},
			{field:'PIBI_Name',width:130,title:'姓名'}
				 
		]],
		columns:[[ 
			
		    {field:'PIBI_RowId',title:'PIBI_RowId',hidden: true},
			{field:'PIBI_Sex_DR_Name',width:80,title:'性别'},
			{field:'PIBI_DOB',width:100,title:'出生日期'},
			{field:'PIBI_Company',width:100,title:'公司'},
			{field:'PIBI_Address',width:140,title:'住址'},
			{field:'PACCardDesc',width:100,title:'证件类型'},
			{field:'PIBI_IDCard',width:180,title:'证件号'},
			{field:'PIBI_PatType_DR_Name',width:100,title:'病人类型'},
			{field:'PIBI_Married_DR_Name',width:100,title:'婚姻状况'},
			{field:'PIBI_Age',width:80,title:'年龄'}, 
			{field:'Position',width:100,title:'部门'},
			{field:'PIBI_MobilePhone',width:100,title:'移动电话'}	
	
		]],
		onSelect: function (rowIndex, rowData) {	
		
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
}

function InitCombobox()
{
	//性别   
	var SexObj = $HUI.combobox("#Sex",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex'
		})
		
	//证件类型
	var PAPMICardTypeObj = $HUI.combobox("#PAPMICardType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPAPMICardType&ResultSetType=array",
		valueField:'id',
		textField:'type'
		})
		
   //病人类型
   var PatTypeObj = $HUI.combobox("#PatType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatType&ResultSetType=array&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'desc'
		})
	
}


