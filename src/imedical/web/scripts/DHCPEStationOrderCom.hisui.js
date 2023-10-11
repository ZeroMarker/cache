//����	DHCPEStationOrderCom.hisui.js
//����	վ�����Ŀ���
//����	2019.05.22
//������  xy

var WIDTH = $(document).width();
$("#SationOrderComDiv").css("width", WIDTH*0.75);

$(function() {
	
	InitCombobox();
			
	InitStationDataGrid();
	
	InitSationOrderComDataGrid();
	
	iniForm();
	
	//��ѯ
    $('#BFind').click(function(e){
    	BFind_click();
    });
	     
    //����
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
    //ɾ��
    $('#del_btn').click(function(e){
    	DelData();
    });

      //���ÿ���
    $('#Loc_btn').click(function(e){
    	LocData();
    });
    
    //��������
    $('#AddLoc').click(function(e){
    	AddLoc();
    });
    
	 //�޸Ŀ���
    $('#UpdateLoc').click(function(e){
    	UpdateLoc();
    });
      
     //��������
    $('#ClearLoc').click(function(e){
    	ClearLoc();
    });
    //ɾ������
    $('#DelLoc').click(function(e){
    	DelLoc();
    });

	$("#ARCIMDesc").keydown(function(e) {
		if(e.keyCode==13){
			BFind_click();
		}
	});
})

function iniForm() {
	var Desc = $('#StaionDesc').val();
	if (Desc.indexOf("����") >= 0) {
		$("#CPISCode").css('display','block');//��ʾ
	 	$("#PISCode").next(".combo").show();//��ʾ
	} else {
		$("#CPISCode").css('display','none');//����
		$("#PISCode").next(".combo").hide();//����
	}
	
	if (Desc.indexOf("����") >= 0) {
		$("#CYGItem").css('display','block');//��ʾ
	 	$("#YGItem").next(".checkbox").show();//��ʾ
		$('#BarPrintNum').val("1");
	} else {
		$("#CYGItem").css('display','none');//����
		$("#YGItem").next(".checkbox").hide();//����
		$('#BarPrintNum').val("");
	}
	$("#IFPrint").checkbox('setValue',true)
	$("#IFReprotPrint").checkbox('setValue',true)
}

//��ѯ
function BFind_click() {
	$("#SationOrderComTab").datagrid('load', {
		ClassName:"web.DHCPE.StationOrder",
		QueryName:"QueryAll",
		ParRef:$('#ParRef').val(),
		ARCIMDesc:$("#ARCIMDesc").val(), 
		Type:"B",
		LocID:session['LOGON.CTLOCID'],
		hospId:session['LOGON.HOSPID']

	});
}

//����
function AddData() {
	if ($("#StaionDesc").val() == "") {
		$.messager.alert('������ʾ',"��ѡ��վ��","info");
		return 
	}
	$("#OrdARCIMDesc").combogrid('enable');
	$("#myWin").show();

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
					$("#ID,#ChildSub").val("")
					$("#SationOrderComTab").datagrid('load',{
		   	 		ClassName:"web.DHCPE.StationOrder",
					QueryName:"QueryAll",
					ParRef:$("#ParRef").val(),
					Type:"B",
					LocID:session['LOGON.CTLOCID'],
					hospId:session['LOGON.HOSPID']
				}); 


			}
		}]
	});
	
	$('#form-save').form("clear");
	iniForm();
	var StaionDesc=$("#StaionDesc").val();
	$("#OrdStaionDesc").val(StaionDesc);
}

SaveForm = function(id) {
	var Minute = "", iReportItemName = "";
	
	var iParRef = $.trim($("#ParRef").val());
	if (iParRef == "") {
		$.messager.alert('��ʾ','��ѡ��վ��',"info");
		return;
	}
	
	//ԤԼ�޶�
	var iPreNum = $.trim($("#PreNum").val());

	//��¼���� 
	var iChildSub = $.trim($("#ChildSub").val());
	
	//��Ŀ����
    var iARCIMDR = $("#OrdARCIMDesc").combogrid('getValue');
	if (($("#OrdARCIMDesc").combogrid('getValue') == undefined) || ($("#OrdARCIMDesc").combogrid('getValue') == "")) { var iARCIMDR = ""; }
	if(iARCIMDR == "") {	
		var valbox = $HUI.combogrid("#OrdARCIMDesc", { required: true });
		$.messager.alert('��ʾ','��Ŀ���Ʋ���Ϊ��',"info");
		return;
	}
	if (id == "") {
		if((iARCIMDR != "") && (iARCIMDR.split("||").length < 2)) {
			$.messager.alert("��ʾ","��ѡ����Ŀ����","info");
			return false;
		}
	
		if (iARCIMDR != "") {
			var ret = tkMakeServerCall("web.DHCPE.DHCPECommon","IsArcItem",iARCIMDR);
			if (ret == "0") {
				$.messager.alert("��ʾ","��ѡ����Ŀ����","info");
				return false;
			}
		}
	} else {
		iARCIMDR = $("#OrdARCIMID").val();
	}

	//ҽ����
	var iARCOSDR = "";
	/*
    var iARCOSDR=$("#ARCOS_DR_Name").combogrid('getValue');
	if (($("#ARCOS_DR_Name").combogrid('getValue')==undefined)||($("#ARCOS_DR_Name").combogrid('getValue')=="")){var iARCOSDR="";}
	*/
	
	//�����ʽ
	var iReportFormat = $("#ReportFormat").combogrid('getValue');
	if (($("#ReportFormat").combogrid('getValue') == undefined) || ($("#ReportFormat").combogrid('getValue') == "")) { var iReportFormat = ""; }
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
	var ExtendItem = $("#ExtendItem").checkbox('getValue');
	if (ExtendItem) { iExtend = "Y"; }
	
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
	var iBaseInfoBar="0"
	var PrintBaseBar=$("#PrintBaseBar").checkbox('getValue');
	if(PrintBaseBar) {iBaseInfoBar="1";}
	
	//�������
	var iPatFeeType=$("#PatFeeType_DR_Name").combobox('getValue');	
	if (($('#PatFeeType_DR_Name').combobox('getValue')==undefined)||($('#PatFeeType_DR_Name').combobox('getValue')=="")){var iPatFeeType="";}
	
	//�Ա�
	var iSex=$("#Sex_DR_Name").combobox('getValue');
	if (($('#Sex_DR_Name').combobox('getValue')==undefined)||($('#Sex_DR_Name').combobox('getValue')=="")){var iSex="";}
	
	//ģ������
	var TempName=$.trim($("#TempName").val());
	
	// ���쵥��ҽ��˳��
	var iPatPrintOrder=$.trim($("#PatPrintOrder").val());
	
	
	//VIP�ȼ�
	var iVIPLevel=$("#VIPLevel").combobox('getValue');
	if (($('#VIPLevel').combobox('getValue')==undefined)||($('#VIPLevel').combobox('getValue')=="")){var iVIPLevel="";}
	
	//ҽ��˳��
	var iSort=$("#Sort").val();
    
    //PIs�걾����
	var iPISCode = $("#PISCode").combobox('getValue');
	if (($('#PISCode').combobox('getValue')==undefined)||($('#PISCode').combobox('getValue')=="")){var iPISCode="";}
	
	//�����ظ�
	var iAlowAddFlag="0"
	var AlowAddFlag=$("#AlowAddFlag").checkbox('getValue');
	if(AlowAddFlag) {iAlowAddFlag="1";}
	
	
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
    if(iBaseInfoBar=="1"){
	    if(iBarPrintNum==""){var iBarPrintNum=1;}
    }else{
	    var iBarPrintNum="";
    }

  ///�Ƿ��ӡ(����)
	var iIFReprotPrint = "N";
	var IFReprotPrint = $("#IFReprotPrint").checkbox('getValue');
	if (IFReprotPrint) { iIFReprotPrint = "Y";}

	var Instring=iParRef+"^"+""+"^"+iChildSub+"^"+iARCIMDR+"^"+iDiet+"^"+iARCOSDR+"^"+iReportFormat+"^"+iNotice		
				+"^"+iAutoReturn+"^"+iSignItem+"^"+iPhoto+"^"+TempName+"^"+iPatItemName+"^"+iExtend+"^"+iShowOrHide
    			+"^"+iYGCheck+"^"+iPatFeeType+"^"+Minute+"^"+iSex+"^"+iReportItemName+"^"+iSort+"^"+iBaseInfoBar
				+"^"+iPatPrintOrder+"^"+iIFPrint+"^"+iVIPLevel+"^"+iPreNum+"^"+iPISCode+"^"+iAlowAddFlag+"^"+iAgeMax
				+"^"+iAgeMin+"^"+iMarriedDR+"^"+iPrintName+"^"+iBarPrintNum+"^"+iIFReprotPrint;
				;
	//alert(Instring)
	
	var flag = tkMakeServerCall("web.DHCPE.StationOrder","Save",'','',Instring);
    
	if (flag=="0") {
		$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		$("#SationOrderComTab").datagrid('load',{
		    ClassName:"web.DHCPE.StationOrder",
			QueryName:"QueryAll",
			ParRef:iParRef,
			Type:"B",
			LocID:session['LOGON.CTLOCID'],
			hospId:session['LOGON.HOSPID']
		}); 
		//$("#ID,#ChildSub").val("");
			   
		//$('#myWin').dialog('close'); 
	} else if ('-119' == flag || '-120' == flag) {
		$.messager.alert('������ʾ',"����ʧ��:����Ŀ�ѱ�ʹ��","error");
	} else {
		$.messager.alert('������ʾ',"����ʧ��:"+flag,"error");	
	}	
}

//�޸�	
function UpdateData() {
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('������ʾ',"��ѡ����޸ĵļ�¼","info");
		return
	}
	iniForm();
	var StaionDesc=$("#StaionDesc").val();
	$("#OrdStaionDesc").val(StaionDesc);
	$("#OrdARCIMDesc").combogrid('disable');
	if(ID!="") {	
		var StationOrderStr=tkMakeServerCall("web.DHCPE.StationOrder","GetStionOrderByID",ID);
		//alert(StationOrderStr)
		var StationOrder=StationOrderStr.split("^");
		$("#ID").val(StationOrder[0]);
		$("#OrdARCIMDesc").combogrid('setValue',StationOrder[28]);
		$("#OrdARCIMID").val(StationOrder[1]);

		$("#Diet").combobox('setValue',StationOrder[2]);
		//$("#ARCOS_DR_Name").combogrid('setValue',StationOrder[3]);
		$("#ReportFormat").combogrid('setValue',StationOrder[4]);
		
		if(StationOrder[6]=="Y"){
			$("#AutoReturn").checkbox('setValue',true);
		}else{
			$("#AutoReturn").checkbox('setValue',false);
		}
		
		$("#Sort").val(StationOrder[7]);
		
		$("#TempName").val(StationOrder[8]);
		
		if(StationOrder[9]=="Y"){
			$("#ExtendItem").checkbox('setValue',true);
		}else{
			$("#ExtendItem").checkbox('setValue',false);
		}
		
		if(StationOrder[11]=="Y"){
			$("#ShowOrHide").checkbox('setValue',true);
		}else{
			$("#ShowOrHide").checkbox('setValue',false);
		}
		
		if(StationOrder[12]=="Y"){
			$("#SignItem").checkbox('setValue',true);
		}else{
			$("#SignItem").checkbox('setValue',false);
		}
		
		$("#Sex_DR_Name").combobox('setValue',StationOrder[13]);
		
		if(StationOrder[14]=="Y"){
			$("#PhotoItem").checkbox('setValue',true);
		}else{
			$("#PhotoItem").checkbox('setValue',false);
		}
		
		if(StationOrder[15]=="Y"){
			$("#SignItem").checkbox('setValue',true);
		}else{
			$("#SignItem").checkbox('setValue',false);
		}
		
		$("#PreNum").val(StationOrder[16])

		 if(StationOrder[17]=="1"){
			$("#PrintBaseBar").checkbox('setValue',true);
		}else{
			$("#PrintBaseBar").checkbox('setValue',false);
		}

		
		$("#VIPLevel").combobox('setValue',StationOrder[18]); 
		
		if(StationOrder[20]=="1"){
			$("#AlowAddFlag").checkbox('setValue',true);
		}else{
			$("#AlowAddFlag").checkbox('setValue',false);
		}
		
		if (StationOrder[27] == "Y") {
			$("#YGItem").checkbox('setValue',true);
		} else {
			$("#YGItem").checkbox('setValue',false);
		}
		
		$("#Notice").val(StationOrder[10]);
		$("#AgeMax").val(StationOrder[22]);
		$("#AgeMin").val(StationOrder[21]);
		
		$("#Married_DR_Name").combobox('setValue',StationOrder[23]);
		
		$("#PatItemName").combobox('setValue',StationOrder[25]);
		
		$("#PatPrintOrder").val(StationOrder[26]);
		
		$("#PISCode").combobox('setValue',StationOrder[24]);

		$("#PrintName").val(StationOrder[30])

		if (StationOrder[29] == "Y") {
			$("#IFPrint").checkbox('setValue',true);
		} else {
			$("#IFPrint").checkbox('setValue',false);
		}
		
		$("#BarPrintNum").val(StationOrder[31]);

		if (StationOrder[32] == "Y") {
			$("#IFReprotPrint").checkbox('setValue',true);
		} else {
			$("#IFReprotPrint").checkbox('setValue',false);
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
					$("#ID,#ChildSub").val("")
					$("#SationOrderComTab").datagrid('load',{
		   	 		ClassName:"web.DHCPE.StationOrder",
					QueryName:"QueryAll",
					ParRef:$("#ParRef").val(),
					Type:"B",
					LocID:session['LOGON.CTLOCID'],
					hospId:session['LOGON.HOSPID']
				}); 


				}
			}]
		});	
							
	}	
}

//ɾ��
function DelData()
{

	var ID=$("#ID").val();
	var iChildSub=$("#ChildSub").val();
	var iParRef=$("#ParRef").val();
	if(ID==""){
		$.messager.alert('������ʾ',"��ѡ���ɾ���ļ�¼","info");
		return
	}
	$.messager.confirm("ȷ��", "ȷ��Ҫɾ���ü�¼��", function(r){
		if (r){
			
			$.m({ ClassName:"web.DHCPE.StationOrder", MethodName:"Delete", itmjs:'',itmjsex:'',ParRef:iParRef,ChildSub:iChildSub},function(ReturnValue){
				if (ReturnValue!='0') {
					$.messager.alert("��ʾ","ɾ��ʧ��","error");  
				}else{
					$.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
					$("#ID,#ChildSub").val(""); 
					$("#SationOrderComTab").datagrid('load',{
						ClassName:"web.DHCPE.StationOrder",
						QueryName:"QueryAll",
						ParRef:$('#ParRef').val(),
						Type:"B",
						LocID:session['LOGON.CTLOCID'],
						hospId:session['LOGON.HOSPID']
					});	
	
			        $('#myWin').dialog('close'); 
				}
			});	
		}
	});
}


//�޸Ŀ���
function UpdateLoc()
{
	var iOrderLocID=$("#OrderLocID").val();
	if(iOrderLocID==""){
		$.messager.alert('��ʾ',"��ѡ����޸ĵļ�¼","info");
		return
	}
	AddLoc();
	
}

//��������
function ClearLoc()
{
	$("#Loc").combobox('setValue',"");
	$("#OrderLocID").val("")
	$("#LocTable").datagrid('reload'); 
	$("#AddLoc").linkbutton('enable');
}

//��������
function AddLoc(){
	
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('��ʾ',"��ѡ���ά�����ҵ�ҽ��","info");
		return
	}
	//����
	var ilocid = $("#Loc").combobox('getValue');
	if (($('#Loc').combobox('getValue') == undefined) || ($('#Loc').combobox('getValue') == "")) { var ilocid = ""; }
    if(ilocid=="")
    {
	    $.messager.alert('��ʾ',"���Ҳ���Ϊ��","info");
	    return false;
    }

   var iOrderLocID=$("#OrderLocID").val();
   var iNoPrint="N"	
    
   var ExistFlag=tkMakeServerCall("web.DHCPE.SelectLoc","IsExistLoc",$.trim(ilocid),$.trim(ID));
    if(ExistFlag=="1"){
	      $.messager.alert('��ʾ',"�ÿ����Ѵ��ڣ���������","info");
	    return false;
    }

    var Instring=$.trim(ilocid)+"^"+$.trim(ID)+"^"+$.trim(iNoPrint)+"^"+$.trim(iOrderLocID);
    //alert(Instring)
    var flag=tkMakeServerCall("web.DHCPE.SelectLoc","Save",Instring);
    if(flag=="0"){
	    if(iOrderLocID==""){  $.messager.popover({msg: '�����ɹ���',type:'success',timeout: 1000});}
	    else{ $.messager.popover({msg: '�޸���ɣ�',type:'success',timeout: 1000});}
	    ClearLoc();
    }
   
}

//ɾ������
function DelLoc(){
	var OrderLocID=$("#OrderLocID").val();
	if(OrderLocID==""){
		$.messager.alert('��ʾ',"��ѡ���ɾ��������","info");
		return false;
	}
	var LocID=$("#LocID").val();
	var Instring=$.trim(LocID)+"^"+""+"^"+$.trim(OrderLocID);
            
     var flag=tkMakeServerCall("web.DHCPE.SelectLoc","Delete",Instring);
    if(flag=="0"){
	  
	    $.messager.popover({msg: 'ɾ���ɹ���',type:'success',timeout: 1000});
	     ClearLoc();
	    
    }
	
}
//���ÿ���ά��
function LocData(){
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('������ʾ',"��ѡ���ά�����ҵļ�¼","info");
		return false;
	}
	$("OrderLocWin").show();

	var myWin = $HUI.dialog("#OrderLocWin",{
		title:'���ÿ���ά��',
		minimizable:false,
		collapsible:false,
		modal:true,
		width:710,
		height:390
		
	});
	var LocLisObj = $HUI.datagrid("#LocTable",{
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
		queryParams:{
			ClassName:"web.DHCPE.SelectLoc",
			QueryName:"Search",
			RowId:ID,
		},
		
		columns:[[
			{field:'TRowId',title:'ID',hidden: true},
			{field:'TLocId',title:'ID',hidden: true},
			{field:'TSelectLoc',width:'400',title:'����'}, 
		]],
	onSelect: function (rowIndex, rowData) { 
				$("#OrderLocID").val(rowData.TRowId);
				$("#LocID").val(rowData.TLocId); 
				$("#AddLoc").linkbutton('disable');
		}
		
		})
	
}



function InitCombobox() {
	//ҽ������
	var ARCIMDObj = $HUI.combogrid("#OrdARCIMDesc",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ArcItmmastList",
		mode:'remote',
		delay:200,
		idField:'STORD_ARCIM_DR',
		textField:'STORD_ARCIM_Desc',
		onBeforeLoad:function(param){
			param.Desc = param.q;
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID'];

		},
		columns:[[
		    {field:'STORD_ARCIM_DR',title:'ID',width:40},
			{field:'STORD_ARCIM_Desc',title:'ҽ������',width:200},
			{field:'STORD_ARCIM_Code',title:'ҽ������',width:150},			
		]],
		onLoadSuccess:function(){
			//$("#OrdARCIMDesc").combogrid('setValue',"")
			
		},
	});
		
	/*
	//ҽ����
	var OPNameObj = $HUI.combogrid("#ARCOS_DR_Name",{
		panelWidth:400,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=ARCOrdSetList",
		mode:'remote',
		delay:200,
		idField:'ARCOS_RowId',
		textField:'ARCOS_Desc',
		onBeforeLoad:function(param){
			param.ARCIMDR = param.q;
		},
		columns:[[
		    {field:'ARCOS_RowId',title:'ID',width:40},
			{field:'ARCOS_Desc',title:'����',width:200},
			{field:'ARCOS_Code',title:'����',width:150},			
		]],
		onLoadSuccess:function(){
			$("#ARCOS_DR_Name").combogrid('setValue',"")
			
		},
	});
	*/

	
	//�����ʽ
	var ReportFormatObj  = $HUI.combogrid("#ReportFormat",{
		panelWidth:200,
		url:$URL+"?ClassName=web.DHCPE.StationOrder&QueryName=SearchReportFormat",
		mode:'remote',
		delay:200,
		idField:'ReportFormat',
		textField:'ReportFormat_desc',
		onBeforeLoad:function(param){
		
		},
		columns:[[
			{field:'ReportFormat',title:'��ʽ',width:65},
			{field:'ReportFormat_desc',title:'����',width:110},			
		]],
		onLoadSuccess:function(){
			$("#ReportFormat").combogrid('setValue',"")
			
		},
	});
		
	//���ﵥ���
	var PatItemObj = $HUI.combobox("#PatItemName",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindPatItem&ResultSetType=array",
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
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
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
            {id:'PRE',text:'��ǰ'},
            {id:'POST',text:'�ͺ�'},
            {id:'N',text:'����'},
           
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
			param.hospId = session['LOGON.HOSPID']; 
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


	// ���ÿ��� 
	$HUI.combobox("#Loc", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=QueryLoc&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		//defaultFilter:4,
		onBeforeLoad:function(param){
			param.Type="B";
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId = session['LOGON.HOSPID']; 
		}

		
	});

}


//��Ŀ�����Ϣ
function InitSationOrderComDataGrid()
{
	$HUI.datagrid("#SationOrderComTab",{
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
		selectOnCheck: true,
		queryParams:{
			ClassName:"web.DHCPE.StationOrder",
			QueryName:"QueryAll",
			ParRef:"",
			Desc:"",
			Code:"",
			Type:"B",
			LocID:session['LOGON.CTLOCID'],
			hospId:session['LOGON.HOSPID']
		},
		frozenColumns:[[
			{field:'STORD_ARCIM_Code',width:'100',title:'��Ŀ����'},
			{field:'STORD_ARCIM_Desc',width:'150',title:'��Ŀ����'},
		]],
		columns:[[
		    {field:'STORD_ParRef',title:'STID',hidden: true},
		    {field:'STORD_RowId',title:'OrdID',hidden: true},
		    {field:'STORD_Childsub',title:'OrdSID',hidden: true},
		    {field:'STORD_ARCIM_DR',title:'ARCIMID',hidden: true},
			{field:'STORD_Diet',width:'60',title:'�Ͳ�'},
			{field:'STORD_ReportFormat',width:'80',title:'�����ʽ'},
			{field:'TPatItemName',width:'150',title:'���ﵥ���'},
			{field:'TAlowAddFlag',width:'100',title:'�����ظ�����'},
			{field:'TSex',width:'60',title:'�Ա�'},
			{field:'TAgeMax',width:'80',title:'��������'},
			{field:'TAgeMin',width:'80',title:'��������'},
			{field:'TMarryDesc',width:'80',title:'����'},
			{field:'TVIPLevel',width:'80',title:'VIP�ȼ�'},
			{field:'TAutoReturn',width:'80',title:'�Զ��ش�'},	
			{field:'TSignItem',width:'70',title:'������'},
			{field:'TPhotoItem',width:'80',title:'�Ƿ���Ƭ��'},
			{field:'TTempName',width:'120',title:'ģ������'},
			{field:'TExtendItem',width:'60',title:'�̳�'},
			{field:'TShowOrHide',width:'60',title:'����'},
			{field:'TPatPrintOrder',width:'120',title:'���ﵥ��ӡ˳��'},
			{field:'TPreNum',width:'100',title:'ԤԼ����'},
			{field:'TBaseBar',width:'120',title:'������Ϣ����'},
			{field:'TBarPrintNum',width:'80',title:'��������'},
			{field:'STORD_Notice',width:'150',title:'ע������'},
			{field:'TPISCode',width:'150',title:'�걾����'},
			{field:'TYGFlag',width:'70',title:'�Ҹ���Ŀ'},
			{field:'STORD_ARCOS_DR_Name',width:'100',title:'ҽ����'},
			{field:'TPrintName',width:'120',title:'��ӡ����(��)'},
			{field:'TIFPrint',width:'80',title:'��ӡ(��)'},
			{field:'TIFReprotPrint',width:'80',title:'��ӡ(��)'}
			
		]],
		onSelect: function (rowIndex, rowData) {
		
			$("#ID").val(rowData.STORD_RowId)
			$("#ChildSub").val(rowData.STORD_Childsub)
			
			  									
		}
		
			
	})
}

function LoadSationOrderComlist(rowData)
{
	
	$('#ParRef').val(rowData.ST_RowId);
	$('#StaionDesc').val(rowData.ST_Desc);
	$("#ID,ChildSub").val("");
	$('#SationOrderComTab').datagrid('load', {
			ClassName:"web.DHCPE.StationOrder",
			QueryName:"QueryAll",
			ParRef:$('#ParRef').val(),
			ARCIMDesc:"",
			Type:"B",
			LocID:session['LOGON.CTLOCID'],
			hospId:session['LOGON.HOSPID']
	});
	
	
}


//վ���б�
function InitStationDataGrid()
{
	
	$HUI.datagrid("#StationTab",{
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
		displayMsg:"",//���ط�ҳ���������"��ʾ��ҳ����ҳ,������������"
		singleSelect: true,
		selectOnCheck: true,
		toolbar: [],//��ͷ�ͱ��֮��ļ�϶2px
		queryParams:{
			ClassName:"web.DHCPE.Station",
			QueryName:"StationList",
		},
		columns:[[

		    {field:'ST_RowId',title:'ID',hidden: true},
		    {field:'ST_Code',title:'����',hidden: true},
			{field:'ST_Desc',width:240,title:'վ������'}, 	
		]],
		onSelect: function (rowIndex, rowData) {
			  		
			$('#SationOrderComTab').datagrid('loadData', {
				total: 0,
				rows: []
			});
			LoadSationOrderComlist(rowData);
					
		}
		
			
	});

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
