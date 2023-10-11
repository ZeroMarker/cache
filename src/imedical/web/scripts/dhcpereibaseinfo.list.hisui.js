
/*
 * FileName:    dhcpereibaseinfo.list.hisui.js
 * Author:      xy
 * Date:        20221206
 * Description: ���˻�����Ϣά��
 */
 
 $(function(){
	 
	//�����б��
	InitCombobox();
	
	//��ʼ���б�
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
	
	//��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
     });
    
	//����
	$("#BClear").click(function() {	
		BClear_click();		
     });
     
    //����
    $("#BAdd").click(function() {	
		BAdd_click();		
     });
     
})


//����
function BClear_click(){
	$("#RegNo,#Name,#IDCard").val("");
	$("#Birth").datebox('setValue',"");
	$(".hisui-combobox").combobox('setValue',"");
	BFind_click();
}

//��ѯ
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

//�޸���־
function BModifyRecord(PIBIRowId){
	var lnk="dhcpemodifyrecord.hisui.csp"+"?SourceID="+PIBIRowId+"&SourceType="+"IBaseInfo";
	 websys_lu(lnk,false,'width=1095,height=653,hisui=true,title='+$g("���˻�����Ϣ�޸���־"))
}

//�ǼǺ�����
function BIBaseInfoEdit(PIBIRowId){
	var lnk="dhcpepreibaseinfonew.edit.hisui.csp"+"?ID="+PIBIRowId+"&OperType="+"M";
	 websys_lu(lnk,false,'width=795,height=630,hisui=true,title='+$g("���˻�����Ϣά��"))
}

//����
function BAdd_click()
{
	var lnk="dhcpepreibaseinfo.edit.hisui.csp";
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=655,height=630,hisui=true,title='+$g("���˻�����Ϣά��"))
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
        	{field:'TModifyRecord',width:90,title:'�޸���־',align:'center',
				formatter:function(value,rowData,rowIndex){	
					return "<span style='cursor:pointer;' class='icon-paper' onclick='BModifyRecord("+rowData.PIBI_RowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
			    /*
				if(HISUIStyleCode=="lite"){
				    	return "<span style='cursor:pointer;' class='icon-paper' onclick='BModifyRecord("+rowData.PIBI_RowId+")'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
				    }else{
						return '<a><img  src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png"  title="�޸���־" border="0" onclick="BModifyRecord('+rowData.PIBI_RowId+')"></a>';
				    }
				*/
				    
				 
			}},
			{field:'PIBI_PAPMINo',width:120,title:'�ǼǺ�',
				formatter:function(value,rowData,rowIndex){	
					return "<a href='#'  class='grid-td-text' onclick=BIBaseInfoEdit("+rowData.PIBI_RowId+"\)>"+value+"</a>";
					
			}},
			{field:'PIBI_Name',width:130,title:'����'}
				 
		]],
		columns:[[ 
			
		    {field:'PIBI_RowId',title:'PIBI_RowId',hidden: true},
			{field:'PIBI_Sex_DR_Name',width:80,title:'�Ա�'},
			{field:'PIBI_DOB',width:100,title:'��������'},
			{field:'PIBI_Company',width:100,title:'��˾'},
			{field:'PIBI_Address',width:140,title:'סַ'},
			{field:'PACCardDesc',width:100,title:'֤������'},
			{field:'PIBI_IDCard',width:180,title:'֤����'},
			{field:'PIBI_PatType_DR_Name',width:100,title:'��������'},
			{field:'PIBI_Married_DR_Name',width:100,title:'����״��'},
			{field:'PIBI_Age',width:80,title:'����'}, 
			{field:'Position',width:100,title:'����'},
			{field:'PIBI_MobilePhone',width:100,title:'�ƶ��绰'}	
	
		]],
		onSelect: function (rowIndex, rowData) {	
		
		},
		onLoadSuccess: function(data) {
			
		},
			
	})
}

function InitCombobox()
{
	//�Ա�   
	var SexObj = $HUI.combobox("#Sex",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex'
		})
		
	//֤������
	var PAPMICardTypeObj = $HUI.combobox("#PAPMICardType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPAPMICardType&ResultSetType=array",
		valueField:'id',
		textField:'type'
		})
		
   //��������
   var PatTypeObj = $HUI.combobox("#PatType",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatType&ResultSetType=array&HospID="+session['LOGON.HOSPID'],
		valueField:'id',
		textField:'desc'
		})
	
}


