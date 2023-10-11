/*
 * FileName: dhcpe/ct/stationordercom.js
 * Author: xy
 * Date: 2021-08-10
 * Description: վ�����Ŀ���
 */
var lastIndex = "";

var EditIndex = -1;

var ostableName = "DHC_PE_StationOrderSet"; //������Ŀ��չ��

var tableName = "DHC_PE_StationOrder"; //վ����Ŀ��ϱ�

var SessionStr =session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']

$(function(){	
	
	//��ȡ�����б�
	GetLocComp(SessionStr)
	
	InitCombobox();
	
	//��ʼ��վ��Grid 
	InitStationGrid();
	 
	//��ʼ����ĿGrid 
	InitLocOrderGrid();
	
	//��ʼ��������Ŀ����Grid 
	InitLocOrderSetGrid();
	
	 //���������б�change
	$("#LocList").combobox({
       onSelect:function(){
 
	        var LocID=session['LOGON.CTLOCID']
			var LocListID=$("#LocList").combobox('getValue');
			if(LocListID!=""){var LocID=LocListID; }
			var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
			
			//���ﵥ���-���¼���
	     	var PatItemUrl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindPatItem&ResultSetType=array&LocID="+LocID;
            $('#PatItemName').combobox('reload',PatItemUrl);
            //���ﵥ���-���¼���

			//VIP�ȼ�--���¼���
	     	var VIPUrl=$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+LocID;
		    $('#VIPLevel').combobox('reload',VIPUrl);
		    //VIP�ȼ�--���¼���
			
			//����걾--���¼���
		    var PISCodeUrl=$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPISCodeNew&ResultSetType=array&hospId="+hospId;
			$('#PISCode').combobox('reload',PISCodeUrl);
			//����걾--���¼���

	    	BFind_click();//��ѯ

	   	$("#LocOrderGrid").datagrid('load', {
			ClassName:"web.DHCPE.CT.StationOrder",
			QueryName:"FindStationOrderNew",
			StationID:$("#StationID").val(),
			ARCIMDesc:$("#ARCIMDesc").val(),
			Type:"B",
			LocID:LocID,
			hospId: hospId,
			tableName:tableName
		});
		
			//���վ����Ŀ����Ŀ���������ѡ��
			$("#LocOrderGrid").datagrid('clearSelections');
			$("#LocOrderSetGrid").datagrid('clearSelections');
			 lastIndex = "";
		     EditIndex = -1;
	 
       }
		
	});
	
	//��ѯ��վ�㣩
	$("#BFind").click(function() {	
		BFind_click();		
     });
     
     //��ѯ����Ŀ��
	$("#BLFind").click(function() {	
		BLFind_click();		
     });
     //��������Ŀ��
	$("#BAdd").click(function() {	
		BAdd_click();		
     });
        
    //�޸ģ���Ŀ��
	$("#BUpdate").click(function() {	
		BUpdate_click();		
     });
         
      //���棨��Ŀ��
     $('#BSave').click(function(){
    	BSave_click();
    });
    
     //���ݹ������ң���Ŀ��
	$("#BRelateLoc").click(function() {	
		BRelateLoc_click();		
        });
        
      //������������Ŀ���飩
	$("#BOSAdd").click(function() {	
		BOSAdd_click();		
     });
        
    //�޸ģ�������Ŀ���飩
	$("#BOSUpdate").click(function() {	
		BOSUpdate_click();		
     });
         
      
	
})

 
/*******************************������Ŀ���� start**********************************/

function InitDrugInfo(OrderID) {
	
	var Info=tkMakeServerCall("web.DHCPE.CT.StationOrder","GetInfoByOrderID",OrderID)
	var InfoArr=Info.split("^");
	var Id=InfoArr[0];
	//alert(Id)
	// ������λ
	$HUI.combobox("#UOM", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemDoseUOM&ARCIMRowid=" + Id + "&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	
	// Ƶ��
	$HUI.combobox("#Frequence", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemFreq&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	
	// �÷�
	$HUI.combobox("#Instruction", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemInstruction&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	
	// �Ƴ�
	$HUI.combobox("#Duration", {
		url:$URL+"?ClassName=web.DHCPE.CT.OrderSets&QueryName=OrdSetsDrugsInfo&CombName=ItemDuration&ResultSetType=array",
		valueField:'Id',
		textField:'Desc',
		defaultFilter:4
	});
	
}

function InitDrugDisable(OrderID){

	var Info=tkMakeServerCall("web.DHCPE.CT.StationOrder","GetInfoByOrderID",OrderID)
	var InfoArr=Info.split("^");
	var ItemRowid=InfoArr[0];
	
	var OrderType=tkMakeServerCall("web.DHCPE.CT.StationOrder","GetArcItemCat",ItemRowid);
	
	if (OrderType != "R") {
		
		$("#UOM,#Frequence,#Duration,#Instruction").combobox('disable');
		$("#DoseQty").attr('disabled',true);
		
		
	}else{
		$("#UOM,#Frequence,#Duration,#Instruction").combobox('enable');
		$("#DoseQty").attr('disabled',false);
	}
}


//����
function BOSAdd_click() {
	if ($("#OrderID").val() == "") {
		$.messager.alert('������ʾ',"��ѡ����Ŀ","info");
		return 
	}

	$("#myWin").show();

    InitDrugInfo($("#OrderID").val());     //��ʼ��ҩƷ����Ϣ
    InitDrugDisable($("#OrderID").val());  

	var myWin = $HUI.dialog("#myWin",{
		iconCls:'icon-w-add',
		resizable:true,
		title:'����',
		modal:true,
		buttonAlign : 'center',
		buttons:[{
			text:'����',
			id:'save_btn',
			handler:function(){
				SaveForm("");
			}
		},{
			text:'�ر�',
			handler:function(){
				myWin.close();
				$("#LocOrderSetGrid").datagrid('load',{
		    		ClassName:"web.DHCPE.CT.StationOrder",
					QueryName:"FindStationOrderSet",			
					OrderID:$("#OrderID").val(),
					LocID:$("#LocList").combobox('getValue')
				}); 


			}
		}]
	});
	
	$('#form-save').form("clear");
	
	InitLocOrderSet();
	
}

function InitLocOrderSet()
{
	$("#OrdARCIMDesc").val($("#ARCIMName").val());
	$("#OrdStaionDesc").val($("#StaionName").val());
	$("#IFReprotPrint").checkbox('setValue',true);
	$("#IFPrint").checkbox('setValue',true);

	
	
}

SaveForm = function(id) {
	var Minute = "", iReportItemName = "";
	
	var iOrderID = $("#OrderID").val();
	if (iOrderID == "") {
		$.messager.alert('��ʾ','��ѡ����Ŀ',"info");
		return;
	}
	
	//ԤԼ�޶�
	var iPreNum = "";
	//var iPreNum = $.trim($("#PreNum").val());
	
	//�����ʽ
	var iReportFormat = $("#ReportFormat").combobox('getValue');
	if (iReportFormat == "") {	
		var valbox = $HUI.combogrid("#ReportFormat", { required: true });
		$.messager.alert('��ʾ','�����ʽ����Ϊ��',"info");
		return;
	}

	//�Ͳͱ�־
	var iDiet = "N";
	var iDiet = $("#Diet").combobox('getValue');
	if (($('#Diet').combobox('getValue') == undefined) || ($('#Diet').combobox('getValue') == "")) { var iDiet = "N"; }
	
	// ע������
	var iNotice = $.trim($("#Notice").val());
	
	//������
	var iSignItem = "N";
	var SignItem = $("#SignItem").checkbox('getValue');
	if (SignItem) { iSignItem = "Y"; }
	
	//�Ҹ���Ŀ
	var iYGCheck = "N";
	var YGCheck = $("#YGItem").checkbox('getValue');
	if (YGCheck) { iYGCheck = "Y"; }
	
	//�Ƿ���Ƭ��
	var iPhoto = "N";
	var PhotoItem = $("#PhotoItem").checkbox('getValue');
	if (PhotoItem) { iPhoto = "Y"; }	
	
	//���ﵥ���
	var iPatItemName = $("#PatItemName").combobox('getValue')
	if (($('#PatItemName').combobox('getValue') == undefined) || ($('#PatItemName').combobox('getValue') == "")) { var iPatItemName = ""; }
	if (iPatItemName == "") {
		var valbox = $HUI.combobox("#PatItemName", {
			required: true,
	    });
		$.messager.alert('��ʾ','���쵥�����Ϊ��',"info");
		return false;
	}
	
	//�Զ��ش�
	var iAutoReturn = "N";
	var AutoReturn = $("#AutoReturn").checkbox('getValue');
	if (AutoReturn) { iAutoReturn = "Y"; }
	
	//�̳�
	var iExtend = "N";
	//var ExtendItem = $("#ExtendItem").checkbox('getValue');
	//if (ExtendItem) { iExtend = "Y"; }
	
	//����
	var iShowOrHide = "N";
	var ShowOrHide = $("#ShowOrHide").checkbox('getValue');
	if (ShowOrHide) { iShowOrHide="Y"; }
	
	///�Ƿ��ӡ(���ﵥ)
	var iIFPrint = "N";
	var IFPrint = $("#IFPrint").checkbox('getValue');
	if (IFPrint) { iIFPrint = "Y";}
	
	///��ӡ����(���ﵥ)
	var iPrintName = $("#PrintName").val();

	//������Ϣ����
	var iBaseInfoBar="N"
	var PrintBaseBar=$("#PrintBaseBar").checkbox('getValue');
	if(PrintBaseBar) {iBaseInfoBar="Y";}
	
	//�������
	var iPatFeeType=$("#PatFeeType_DR_Name").combobox('getValue');	
	if (($('#PatFeeType_DR_Name').combobox('getValue')==undefined)||($('#PatFeeType_DR_Name').combobox('getValue')=="")){var iPatFeeType="";}
	
	//�Ա�
	var iSex=$("#Sex_DR_Name").combobox('getValue');
	if (($('#Sex_DR_Name').combobox('getValue')==undefined)||($('#Sex_DR_Name').combobox('getValue')=="")){var iSex="";}
	
	//ģ������(������뵥)
	var iTempName=$.trim($("#TempName").val());
	
	//VIP�ȼ�
	var iVIPLevel=$("#VIPLevel").combobox('getValue');
	if (($('#VIPLevel').combobox('getValue')==undefined)||($('#VIPLevel').combobox('getValue')=="")){var iVIPLevel="";}
	
	//ҽ��˳��
	var iSort=$("#Sort").val();
    
    //PIs�걾����
	var iPISCode = $("#PISCode").combobox('getValue');
	if (($('#PISCode').combobox('getValue')==undefined)||($('#PISCode').combobox('getValue')=="")){var iPISCode="";}
	
	//�����ظ�
	var iAlowAddFlag="N"
	var AlowAddFlag=$("#AlowAddFlag").checkbox('getValue');
	if(AlowAddFlag) {iAlowAddFlag="Y";}
	
	
	//����������
	var iAgeMax=$.trim($("#AgeMax").val());
	if (iAgeMax!=""){
		if (!isNumber(iAgeMax))
		{ 
		 	$.messager.alert("��ʾ","�������޸�ʽ����,������������","error");
        	return false;
		}
	}

	var iAgeMin=$.trim($("#AgeMin").val());
	if(iAgeMin!=""){
		if (!isNumber(iAgeMin)) { 
		 	$.messager.alert("��ʾ","�������޸�ʽ����,������������","error");
        	return false;
		}
	}
	if(parseInt(iAgeMax)<parseInt(iAgeMin)){
		$.messager.alert("��ʾ","�������޴�����������","error");
        return false;
	}
	
	//����
	var iMarriedDR = $('#Married_DR_Name').combobox('getValue');
	if (($('#Married_DR_Name').combobox('getValue')==undefined)||($('#Married_DR_Name').combobox('getValue')=="")) {var iMarriedDR = "";}
	
	//��������
	var iBarPrintNum=$("#BarPrintNum").val();
    if(iBarPrintNum!=""){
	    if(!isPositiveInteger(iBarPrintNum)){
		    $.messager.alert("��ʾ","����������ʽ����,����������","info");
		    return false
	    }
	   if((iBaseInfoBar=="0")&&(iReportFormat.indexOf("LIS")<0)){
		    $.messager.alert("��ʾ","�빴ѡ������Ϣ����","info");
		    return false;
		    }

    }
    
    if(iBaseInfoBar=="Y"){
	    if(iBarPrintNum==""){var iBarPrintNum=1;}
    }else{
	    var iBarPrintNum="";
    }

	// ���쵥��ҽ��˳��
	//var iPatPrintOrder=$.trim($("#PatPrintOrder").val());
	var iPatPrintOrder="";

	//˳��(��)
	var iSort=$("#PrintSort").val();
    
    //��ӡ�����棩
    var iIFReprotPrint="N"
	var IFReprotPrint=$("#IFReprotPrint").checkbox('getValue');
	if(IFReprotPrint) {iIFReprotPrint="Y";}
	
    var LocID=$("#LocList").combobox('getValue');
    var UserID=session['LOGON.USERID'];
    
	//������
    var iNoDiscount="N"
	var NoDiscount=$("#NoDiscount").checkbox('getValue');
	if(NoDiscount) {iNoDiscount="Y";}

	//�ϲ���ӡ
	var iPrintType="N"
	var PrintType=$("#PrintType").checkbox('getValue');
	if(PrintType) {iPrintType="Y";}
	
	if((iTempName=="")&&(iPrintType=="Y")){
		
		$.messager.alert("��ʾ","������뵥Ϊ�գ�����Ҫ���úϲ���ӡ��","info");	
		return false;	
		
	}
	
	 //����
	var iDoseQty=$("#DoseQty").val();
	
	//������λ
	var iUOM=$("#UOM").combobox('getValue');
	
	//Ƶ��
	var iFrequence=$("#Frequence").combobox('getValue');
	
	//�Ƴ�
	var iDuration=$("#Duration").combobox('getValue');
	
	//�÷�
	var iInstruction=$("#Instruction").combobox('getValue');

	// ���Ŀ��
	var iPurpose = $.trim($("#Purpose").val());
	
	
	//����ԤԼ
	var iNetPre = "N";
	var NetPre = $("#NetPreFlag").checkbox('getValue');
	if (NetPre) { iNetPre = "Y"; }
	
	var Instring=iOrderID+"^"+LocID+"^"+iDiet+"^"+iReportFormat+"^"+iNotice		
				+"^"+iAutoReturn+"^"+iSignItem+"^"+iPhoto+"^"+iTempName+"^"+iPatItemName+"^"+iExtend+"^"+iShowOrHide
    			+"^"+iYGCheck+"^"+iPatFeeType+"^"+iSex+"^"+iReportItemName+"^"+iSort+"^"+iBaseInfoBar
				+"^"+iPatPrintOrder+"^"+iIFPrint+"^"+iVIPLevel+"^"+iPreNum+"^"+iPISCode+"^"+iAlowAddFlag+"^"+iAgeMax
				+"^"+iAgeMin+"^"+iMarriedDR+"^"+iPrintName+"^"+iBarPrintNum+"^"+iSort+"^"+iIFReprotPrint+"^"+UserID+"^"+iNoDiscount
				+"^"+iPrintType+"^"+iDoseQty+"^"+iUOM+"^"+iFrequence+"^"+iDuration+"^"+iInstruction+"^"+iPurpose+"^"+iNetPre;
				
	//alert(Instring)
	
	var ret = tkMakeServerCall("web.DHCPE.CT.StationOrder","SaveStationOrderSet",id,Instring,ostableName);
    
    var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		$.messager.alert("��ʾ",Arr[1],"error");		
	}else{
		$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		$('#myWin').dialog('close'); 
		$("#LocOrderSetGrid").datagrid('load',{
		    ClassName:"web.DHCPE.CT.StationOrder",
			QueryName:"FindStationOrderSet",			
			OrderID:$("#OrderID").val(),
			LocID:$("#LocList").combobox('getValue')
		}); 

			
	} 	
		
}

//�޸�	
function BOSUpdate_click() {
	var ID=$("#OrderSetID").val();
	
	if(ID==""){
		$.messager.alert('������ʾ',"��ѡ����޸ĵļ�¼","info");
		return
	}

	InitLocOrderSet();
	InitDrugInfo($("#OrderID").val());  //��ʼ��ҩƷ��Ϣ
    InitDrugDisable($("#OrderID").val());

	if(ID!="") {	
		var StationOrdeSetrStr=tkMakeServerCall("web.DHCPE.CT.StationOrder","GetStionOrderSetByID",ID);
		//alert(StationOrdeSetrStr)
		var StationOrderSet=StationOrdeSetrStr.split("^");
	
		$("#Diet").combobox('setValue',StationOrderSet[0]);

		$("#ReportFormat").combobox('setValue',StationOrderSet[1]);

	
		$("#Notice").val(StationOrderSet[2]);
		
		if(StationOrderSet[3]=="Y"){
			$("#AutoReturn").checkbox('setValue',true);
		}else{
			$("#AutoReturn").checkbox('setValue',false);
		}
		
		
		$("#Sort").val(StationOrderSet[4]);
		
		$("#Sex_DR_Name").combobox('setValue',StationOrderSet[5]);
		
		$("#Married_DR_Name").combobox('setValue',StationOrderSet[6]);
		
		$("#AgeMax").val(StationOrderSet[7]);
		
		$("#AgeMin").val(StationOrderSet[8]);
		
		$("#VIPLevel").combobox('setValue',StationOrderSet[9]); 
		 if(StationOrderSet[10]=="Y"){
			$("#PrintBaseBar").checkbox('setValue',true);
		}else{
			$("#PrintBaseBar").checkbox('setValue',false);
		}
		if(StationOrderSet[11]=="Y"){
			$("#AlowAddFlag").checkbox('setValue',true);
		}else{
			$("#AlowAddFlag").checkbox('setValue',false);
		}
		$("#PISCode").combobox('setValue',StationOrderSet[12]);
		
		//$("#PreNum").val(StationOrderSet[13]);

		$("#TempName").val(StationOrderSet[14]);
		
		if (StationOrderSet[15] == "Y") {
			$("#YGItem").checkbox('setValue',true);
		} else {
			$("#YGItem").checkbox('setValue',false);
		}
		if(StationOrderSet[16]=="Y"){
			$("#SignItem").checkbox('setValue',true);
		}else{
			$("#SignItem").checkbox('setValue',false);
		}
		
	
		if(StationOrderSet[17]=="Y"){
			$("#ShowOrHide").checkbox('setValue',true);
		}else{
			$("#ShowOrHide").checkbox('setValue',false);
		}
		/*
		if(StationOrderSet[18]=="Y"){
			$("#ExtendItem").checkbox('setValue',true);
		}else{
			$("#ExtendItem").checkbox('setValue',false);
		}
		*/
		
		if(StationOrderSet[19]=="Y"){
			$("#PhotoItem").checkbox('setValue',true);
		}else{
			$("#PhotoItem").checkbox('setValue',false);
		}
		
		if(StationOrderSet[20]=="Y"){
			$("#IFReprotPrint").checkbox('setValue',true);
		}else{
			$("#IFReprotPrint").checkbox('setValue',false);
		}
		
		$("#BarPrintNum").val(StationOrderSet[21]);
		
		//alert(StationOrderSet[22])
		$("#PatItemName").combobox('setValue',StationOrderSet[22]);
		
		$("#PrintSort").val(StationOrderSet[23]);
		
		if (StationOrderSet[24] == "Y") {
			$("#IFPrint").checkbox('setValue',true);
		} else {
			$("#IFPrint").checkbox('setValue',false);
		}
		
		$("#PrintName").val(StationOrderSet[25]);

		$("#PatFeeType_DR_Name").combobox('setValue',StationOrderSet[26]);
		
			
		if(StationOrderSet[27]=="Y"){
			$("#NoDiscount").checkbox('setValue',true);
		}else{
			$("#NoDiscount").checkbox('setValue',false);
		}

        $("#DoseQty").val(StationOrderSet[28]);
        $("#UOM").combobox('setValue',StationOrderSet[29]);
        $("#Frequence").combobox('setValue',StationOrderSet[30]);
        $("#Duration").combobox('setValue',StationOrderSet[31]);
        $("#Instruction").combobox('setValue',StationOrderSet[32]);
        if (StationOrderSet[33] == "Y") {
			$("#PrintType").checkbox('setValue',true);
		} else {
			$("#PrintType").checkbox('setValue',false);
		}
		$("#Purpose").val(StationOrderSet[34]);
		if (StationOrderSet[35] == "Y") {
			$("#NetPreFlag").checkbox('setValue',true);
		} else {
			$("#NetPreFlag").checkbox('setValue',false);
		}
		$("#myWin").show();
		
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-edit',
			resizable:true,
			title:'�޸�',
			modal:true,
			buttons:[{
				text:'����',
				id:'save_btn',
				handler:function(){
					SaveForm(ID)
				}
			},{
				text:'�ر�',
				handler:function(){
					myWin.close();
					//alert($("#OrderID").val()+"^"+$("#LocList").combobox('getValue'))
					$("#LocOrderSetGrid").datagrid('load',{
		    			ClassName:"web.DHCPE.CT.StationOrder",
						QueryName:"FindStationOrderSet",
						
						OrderID:$("#OrderID").val(),
						LocID:$("#LocList").combobox('getValue')
					}); 
					$("#OrderSetID").val("");

				}
			}]
		});	
							
	}	
}






var LocOrderSetColumns = [[
	{field:'TOrderSetID',title:'OrderSetID',hidden:true},
	{field:'TStationName',width:'80',title:'վ������'},
	{field:'TARCIMDesc',width:'80',title:'ҽ������'},
	{field:'TDiet',width:'60',title:'�Ͳ�'},
	{field:'TReportFormat',width:'80',title:'�����ʽ'},
	{field:'TPatItemName',width:'150',title:'���ﵥ���'},
	{field:'TAlowAddFlag',width:'100',title:'�����ظ�����',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TPatFeeType',width:'90',title:'�������'},
	{field:'TSex',width:'60',title:'�Ա�'},
	{field:'TAgeMax',width:'80',title:'��������'},
	{field:'TAgeMin',width:'80',title:'��������'},
	{field:'TMarryDesc',width:'80',title:'����'},
	{field:'TVIPLevel',width:'80',title:'VIP�ȼ�'},
	{field:'TAutoReturn',width:'80',title:'�Զ��ش�',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},	
	{field:'TSignItem',width:'70',title:'������',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
     },
	{field:'TPhoto',width:'80',title:'�Ƿ���Ƭ��',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TTempName',width:'120',title:'ģ������'},
	{field:'TExtend',width:'60',title:'�̳�',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TShowOrHide',width:'60',title:'����',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
    },
	//{field:'TPreNum',width:'100',title:'ԤԼ����'},
	{field:'TBaseInfoBar',width:'120',title:'������Ϣ����',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TBarPrintNum',width:'80',title:'��������'},
	{field:'TPISCode',width:'150',title:'�걾����'},
	{field:'TYGFlag',width:'70',title:'�Ҹ���Ŀ',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TIFReprotPrint',width:'120',title:'��ӡ(����)',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
     },
	  {field:'TNoDiscount',width:'120',title:'������',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
     },
	{field:'TUsherSort',width:'120',title:'˳��(��)'},
	{field:'TUsherPrtName',width:'120',title:'��ӡ����(��)'},
	{field:'TUsherIsPrint',width:'80',title:'��ӡ(��)',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TDoseQty',width:'80',title:'����'},
	{field:'TUOM',width:'100',title:'������λ'},
	{field:'TFrequence',width:'80',title:'Ƶ��'},
	{field:'TDuration',width:'80',title:'�Ƴ�'},
	{field:'TInstruction',width:'80',title:'�÷�'},
	{field:'TPrintType',width:'100',title:'�ϲ���ӡ',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TNetPreFlag',width:'100',title:'����ԤԼ',align:'center',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" value="' + value + '" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
                        
       }
	},
	{field:'TNoticeInfo',width:'120',title:'ע������'},
	{field:'TUpdateDate',width:'100',title:'��������'},
	{field:'TUpdateTime',width:'120',title:'����ʱ��'},
	{field:'TUpdateUser',width:'100',title:'������'}

			
]];
 



//��ʼ��������Ŀ����Grid 
function InitLocOrderSetGrid()
{
	$('#LocOrderSetGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200],  
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns: LocOrderSetColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StationOrder",
			QueryName:"FindStationOrderSet",
			
		},
		onSelect: function (rowIndex, rowData) {
			$("#OrderSetID").val(rowData.TOrderSetID)
			
	
		},
		onLoadSuccess: function (data) {
			
		}
	});
	
	
}
 
 function LoadLocOrderSetGrid(OrderID){
	 $("#LocOrderSetGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.StationOrder",
		QueryName:"FindStationOrderSet",
		OrderID:OrderID,
		LocID:$("#LocList").combobox('getValue')
	});	
 }	
/*******************************������Ŀ���� end************************************/

/*******************************��Ŀ start******************************************/


//���ݹ�������
function BRelateLoc_click()
{
	
	var DateID=$("#OrderID").val()
	if (DateID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��Ȩ�ļ�¼","info"); 
		return false;
	}
   
   var LocID=$("#LocList").combobox('getValue');
   //alert("LocID:"+LocID)
   OpenLocWin(tableName,DateID,SessionStr,LocID,function(){})
   
   $("#LocOrderGrid").datagrid('reload');
   
}


//����
function BAdd_click()
 {
	 var StationID=$("#StationID").val();
	 if(StationID==""){
		$.messager.alert('��ʾ',"��ѡ����Ҫά����վ��",'info');
		return;
	 }
	 
	$('#LocOrderGrid').datagrid('getRows').length
	lastIndex = $('#LocOrderGrid').datagrid('getRows').length - 1;
	$('#LocOrderGrid').datagrid('selectRow', lastIndex);
	$("#LocOrderGrid").datagrid('clearSelections');
	
	var selected = $('#LocOrderGrid').datagrid('getSelected');
	
	if (selected) {
		if (selected.TOrderID == "") {
			$.messager.alert('��ʾ', "����ͬʱ��Ӷ���!", 'info');
			return;
		}
	}
	if ((EditIndex >= 0)) {
		$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
		return;
	}
	$('#LocOrderGrid').datagrid('appendRow', {
		TOrderID: '',
		TARCIMDR:'',
		TARCIMDesc:'',
		TNoActive:'Y'
	});
	
	lastIndex = $('#LocOrderGrid').datagrid('getRows').length - 1;
	$('#LocOrderGrid').datagrid('selectRow',lastIndex);
	$('#LocOrderGrid').datagrid('beginEdit',lastIndex);
	EditIndex = lastIndex;
 }
 
 //�޸�
 function BUpdate_click()
 {
	var selected = $('#LocOrderGrid').datagrid('getSelected');
	if (selected==null){
			$.messager.alert('��ʾ', "��ѡ����޸ĵļ�¼", 'info');
			return;
	}
	if (selected) {
		var thisIndex = $('#LocOrderGrid').datagrid('getRowIndex', selected);
		if ((EditIndex != -1) && (EditIndex != thisIndex)) {
			$.messager.alert('��ʾ', "һ��ֻ���޸�һ����¼", 'info');
			return;
		}
		$('#LocOrderGrid').datagrid('beginEdit', thisIndex);
		$('#LocOrderGrid').datagrid('selectRow', thisIndex);
		EditIndex = thisIndex;
		var selected = $('#LocOrderGrid').datagrid('getSelected');

		var thisEd = $('#LocOrderGrid').datagrid('getEditor', {
				index: EditIndex,
				field: 'TARCIMDesc'  
		});
		$(thisEd.target).combobox('select', selected.TARCIMDR);  
		
	}
 }

//����
function BSave_click()
{ 
	$('#LocOrderGrid').datagrid('acceptChanges');
	var selected = $('#LocOrderGrid').datagrid('getSelected');
	if(selected ==null){
		$.messager.alert('��ʾ', "��ѡ������������", 'info');
		return;
	}

	if (selected) {
		
		if (selected.TOrderID == "") {
			if ((selected.TARCIMDesc == "undefined")||(selected.TARCIMDesc == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,���������", 'info');
				$("#LocOrderGrid").datagrid('reload');
				return;
			}
			var StationID=$("#StationID").val();
			var iActive=selected.TNoActive;
			var iARCIMID=selected.TARCIMDesc;	
			var LocID=$("#LocList").combobox('getValue');
			var UserID=session['LOGON.USERID'];
			var Empower=selected.TEmpower;
			var ID=""
			var InputStr=StationID+"^"+ID+"^"+iARCIMID+"^"+iActive+"^"+tableName+"^"+LocID+"^"+UserID+"^"+Empower;
			$.m({
				ClassName: "web.DHCPE.CT.StationOrder",
				MethodName: "Insert",
				InputStr:InputStr
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('����ʧ��:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});	
				}

				$("#LocOrderGrid").datagrid('reload');
			});
		} else {
			$('#LocOrderGrid').datagrid('selectRow', EditIndex);
			var selected = $('#LocOrderGrid').datagrid('getSelected');
			if ((selected.TARCIMDesc == "undefined")||(selected.TARCIMDesc == "")) {
				$.messager.alert('��ʾ', "����Ϊ��,�������޸�", 'info');
				$("#LocOrderGrid").datagrid('reload');
				return;
			}
			var iActive=selected.TNoActive;
			var iARCIMID=selected.TARCIMDesc;	
			if((iARCIMID != "") && (iARCIMID.split("||").length < 2)) {
				$.messager.alert("��ʾ","��ѡ����Ŀ����","info");
				return false;
			}
	
			if (iARCIMID != "") {
				var ret = tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",iARCIMID);
				if (ret == "0") {
					$.messager.alert("��ʾ","��ѡ����Ŀ����","info");
					return false;
				}
			}
			var LocID=$("#LocList").combobox('getValue');
			var UserID=session['LOGON.USERID'];
			var Empower=selected.TEmpower;
			var ID=selected.TOrderID;
			var InputStr=""+"^"+ID+"^"+iARCIMID+"^"+iActive+"^"+tableName+"^"+LocID+"^"+UserID+"^"+Empower;

			$.m({
				ClassName: "web.DHCPE.CT.StationOrder",
				MethodName: "Update",
				InputStr:InputStr	
			}, function (rtn) {
				var rtnArr=rtn.split("^");
				if(rtnArr[0]=="-1"){	
					$.messager.alert('��ʾ', $g('�޸�ʧ��:')+ rtnArr[1], 'error');	
				}else{	
					$.messager.popover({msg: '�޸ĳɹ���',type:'success',timeout: 1000});	
				}
			   $("#LocOrderGrid").datagrid('reload');
			});
		}
	}
}



var LocOrderColumns = [[
	{
		field:'TOrderID',
		title:'TOrderID',
		hidden:true
	},{
		field:'TStationName',
		title:'վ��',
		width: 100
	},{
		field:'TARCIMDR',
		title:'TARCIMDR',
		hidden:true
	},{
		field:'TARCIMCode',
		title:'ҽ������',
		width: 100
	},{
		field: 'TARCIMDesc',
		title: '��Ŀ',
		width: 230,
		formatter:function(value,row){
            return row.TARCIMDesc;
         },
		editor:{
           type:'combobox',
           options:{
	           required: true,
                valueField:'STORD_ARCIM_DR',
                textField:'STORD_ARCIM_Desc',
                 mode:'remote', 
          		/*onShowPanel: function () { // ֻ������������ʾʱ,��ȥ����url��ȡ����,��������ٶ�
					var url = $(this).combobox('options').url;
					if (!url){
						//$(this).combobox('options').mode = 'remote';
						var url = $URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList&ResultSetType=array";
						$(this).combobox('reload',url);		
						}
					},*/

                url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList&ResultSetType=array",
                onBeforeLoad:function(param){   
			       	param.Desc = param.q;
					param.Type="B";
					param.LocID=$('#LocList').combobox('getValue');
					param.hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",$('#LocList').combobox('getValue'));         
                  }
                        
               }
         }
	},{
		field: 'TNoActive',
		width: 60,
		title: '����',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
				on:'Y',
				off:'N'
			}
						
		}
	},{
		field: 'TEmpower',
		width: 80,
		title: '������Ȩ',
		align:'center',
		editor: {
			type: 'checkbox',
			options: {
					on:'Y',
				off:'N'
			}
						
		}
	},{ field:'TEffPowerFlag',width:100,align:'center',title:'��ǰ������Ȩ',
		formatter: function (value, rec, rowIndex) {
			if(value=="Y"){
				return '<input type="checkbox" checked="checked" disabled/>';
			}else{
				return '<input type="checkbox" value="" disabled/>';
			}
		}
	},{
		field: 'TUpdateDate',
		width: '120',
		title: '��������'
	}, {
		field: 'TUpdateTime',
		width: '120',
		title: '����ʱ��'
	}, {
		field: 'TUserName',
		width: '120',
		title: '������'
	}
			
]];


//��ʼ����ĿGrid 
function InitLocOrderGrid(){
	
	var iActive = "N";
	var Active = $("#Active").checkbox('getValue');
	if (Active) { iActive = "Y"; }

    var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

	$('#LocOrderGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		//displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:LocOrderColumns,
		queryParams:{
			ClassName:"web.DHCPE.CT.StationOrder",
			QueryName:"FindStationOrderNew",
			ARCIMDesc:"",
			Active:iActive,
			Type:"B",
			LocID:LocID,
			hospId:hospId,
			tableName:tableName
			
		},
		onSelect: function (rowIndex,rowData) {
			
		if(rowIndex!="-1"){

			if(rowData.TEmpower=="Y"){		
				$("#BRelateLoc").linkbutton('enable');
			}else{
				$("#BRelateLoc").linkbutton('disable');
			}
				
			$("#OrderID").val(rowData.TOrderID);
			$("#StaionName").val(rowData.TStationName);
			$("#ARCIMName").val(rowData.TARCIMDesc);
			LoadLocOrderSetGrid(rowData.TOrderID);
			$("#OrderSetID").val('');
		}

		},
		onLoadSuccess: function (data) {
			EditIndex = -1;	
		}
	});
}

//��ѯ
function BLFind_click(){
	
var iActive = "N";
var Active = $("#Active").checkbox('getValue');
if (Active) { iActive = "Y"; }

var LocID=$("#LocList").combobox('getValue');
var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

$("#LocOrderGrid").datagrid('load', {
	ClassName:"web.DHCPE.CT.StationOrder",
	QueryName:"FindStationOrderNew",
	StationID:$("#StationID").val(),
	ARCIMDesc:$("#ARCIMDesc").val(),
	Active:iActive,
	Type:"B",
	LocID:LocID,
	hospId:hospId,
	tableName:tableName
});
}

function LoadLocOrderGrid(StationID){
	
var iActive = "N";
var Active = $("#Active").checkbox('getValue');
if (Active) { iActive = "Y"; }

var LocID=$("#LocList").combobox('getValue');
var hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);

$("#LocOrderGrid").datagrid('load', {

	ClassName:"web.DHCPE.CT.StationOrder",
	QueryName:"FindStationOrderNew",
	StationID:StationID,
	ARCIMDesc:"",
	Active:iActive,
	Type:"B",
	LocID:LocID,
	hospId:hospId,
	tableName:tableName

});
	
}
/*******************************��Ŀ end*******************************************/



/*******************************վ�� start*****************************************/

// ��ʼ��վ��ά��DataGrid
function InitStationGrid()
{
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }
	
	$('#StaionGrid').datagrid({
		url:$URL,
		fit : true,
		border : false,
		striped : true,
		fitColumns : false,
		autoRowHeight : false,
		rownumbers:true,
		pagination : true,
		pageSize: 20,
		pageList : [20,100,200], 
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������" 
		rownumbers : true,  
		singleSelect: true,
		selectOnCheck: true,
		columns:[[
		
		    {field:'TStationID',title:'ID',hidden: true},
			{field:'TStationCode',title:'����',width: 70},
			{field:'TStationDesc',title:'����',width: 180},
		]],
		queryParams:{
			ClassName:"web.DHCPE.CT.Station",
			QueryName:"FindStationSet",
			LocID:LocID,
			STActive:"Y"
			
		},
		onSelect: function (rowIndex,rowData) {
			
			$("#StationID").val(rowData.TStationID);
			LoadLocOrderGrid(rowData.TStationID);
			LoadLocOrderSetGrid("");
			$("#OrderID").val('');
			$("#OrdARCIMDesc").val('');
			$("#OrdStaionDesc").val('');
			$("#OrderSetID").val('');
			//���վ����Ŀ����Ŀ���������ѡ��
			$("#LocOrderGrid").datagrid('clearSelections');
			$("#LocOrderSetGrid").datagrid('clearSelections');
			 lastIndex = "";
		     EditIndex = -1;
		
		},
		onLoadSuccess: function (data) {
			
		}
	});
	
}



//��ѯ��վ�㣩
function BFind_click(){
	$("#StaionGrid").datagrid('load',{
		ClassName:"web.DHCPE.CT.Station",
		QueryName:"FindStationSet",
		LocID:$("#LocList").combobox('getValue'),
		Desc:$("#Desc").val(),
		STActive:"Y"
	});	
	
}
/*******************************վ�� end*************************************/

var ReportFormatData = [{
		id: 'RF_CAT',
		text: $g('��ӡ��ʽ ���')
	}, {
		id: 'RF_LIS',
		text: $g('��ӡ��ʽ ����')
	}, {
		id: 'RF_NOR',
		text: $g('��ӡ��ʽ Ĭ��')
	}, {
		id: 'RF_RIS',
		text: $g('��ӡ��ʽ ���')
	}, {
		id: 'RF_EKG',
		text: $g('��ӡ��ʽ �ĵ�')
	}, {
		id: 'RF_PIS',
		text: $g('��ӡ��ʽ ����')
}];

function InitCombobox(){
	
	var LocID=session['LOGON.CTLOCID']
	var LocListID=$("#LocList").combobox('getValue');
	if(LocListID!=""){var LocID=LocListID; }

	//�����ʽ
	$HUI.combobox("#ReportFormat", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:ReportFormatData
	});
		
	//���ﵥ���
	var PatItemObj = $HUI.combobox("#PatItemName",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindPatItem&ResultSetType=array&LocID="+LocID,
		valueField:'id',
		textField:'desc',
	});
		
	//���ѱ�
	var PatFeeObj = $HUI.combobox("#PatFeeType_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatFeeType&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:'70',
	});
			
	//�Ա�
	var SexObj = $HUI.combobox("#Sex_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindSex&ResultSetType=array",
		valueField:'id',
		textField:'sex',
		panelHeight:'130',
	});
	
	//VIP�ȼ�	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+LocID,
		valueField:'id',
		textField:'desc',
	});
		
	//����״��	
	var MarriedObj = $HUI.combobox("#Married_DR_Name",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindMarried&ResultSetType=array",
		valueField:'id',
		textField:'married'
	});
		
	//�Ͳ�
	var DietObj = $HUI.combobox("#Diet",{
		valueField:'id',
		textField:'text',
		panelHeight:'100',
		data:[
            {id:'PRE',text:$g('��ǰ')},
            {id:'POST',text:$g('�ͺ�')},
            {id:'N',text:$g('����')},
           
        ]

	});	
	
	
	//����걾����
	var flag=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSendPisInterface");
	if (flag == 1) {
		var PISObj = $HUI.combobox("#PISCode",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPISCodeNew&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		onBeforeLoad:function(param){ 
			param.hospId = tkMakeServerCall("web.DHCPE.CT.DHCPEMappingLoc","GetHospIDByLocID",LocID);
		}

		});
	} else {
		var PISObj = $HUI.combobox("#PISCode",{
			valueField:'id',
			textField:'text',
			panelHeight:'100',
			data:[
	            {id:'20',text:'ϸ��'},
	            {id:'23',text:'TCT'},
        	]

		});	
	}

    
}


//�Ƿ�Ϊ������
function isPositiveInteger(s){

     var re =/^\+?[1-9][0-9]*$/ ;

     return re.test(s)

 }

//�ж�������ַ����Ƿ�Ϊ�Ǹ�����
function isNumber(elem){
 var pattern= /^\d+$/;
 if(pattern.test(elem)){
  return true;
 }else{
  return false;
 }
}