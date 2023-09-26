//����	DHCPEFetchReport.hisui.js
//����	ȡ����
//����	2020.02.19
//������  zhongricheng
//ҳ�� dhcpefetchreport.hisui.csp

var ButtonType = "";
var myCombAry=new Array();
//document.write("<object ID='ClsIDCode' WIDTH=0 HEIGHT=0 CLASSID='CLSID:299F3F4E-EEAA-4E8C-937A-C709111AECDC' CODEBASE='../addins/client/ReadPersonInfo.CAB#version=1,0,0,8' VIEWASTEXT>");
//document.write("</object>");

$(function () {
	InitCombobox();
	InitDataGrid();
	
	$("#BSearch").click(function() {
		BSearch_click();
    });
    
    $("#BClear").click(function() {
		BClear_click("1");
    });
    
    $("#BFetch").click(function() {
		ShowFetchInfo("","");
    });
    
    $("#ReadRegInfo").click(function() {
		ReadRegInfo_click();
    });
    
    $("#DoRegNo").blur(function() {
	    var RegNo = $("#DoRegNo").val();
 		if(RegNo != "") {
	 		RegNo = $.m({"ClassName":"web.DHCPE.DHCPECommon", "MethodName":"RegNoMask", "RegNo":RegNo}, false);
			$("#DoRegNo").val(RegNo);
		}
    })
    
    $("#DoRegNo").keydown(function(e) {
	    if (e.keyCode == "13") {
		    var iRegNo = $("#DoRegNo").val();
		     var iRegNo = $("#DoRegNo").val();
 			if(iRegNo != "") {
	 			iRegNo = $.m({"ClassName":"web.DHCPE.DHCPECommon", "MethodName":"RegNoMask", "RegNo":iRegNo}, false);
				//$("#DoRegNo").val(iRegNo);
			}
	    	BClear_click("1");
    		$("#DoRegNo").val(iRegNo);
		    $HUI.datagrid("#FetchReport", { url:$URL, queryParams:{ClassName:"web.DHCPE.FetchReport", QueryName:"SearchFetchReport", RegNo:iRegNo, NoFetchReport:"N"}, 
		    	onLoadSuccess:function(data) {
			    	if (data.rows.length > 0) {
				    	$("#FetchReport").datagrid("selectRow", 0);
						$('#BFetch').linkbutton('enable');
				    	ShowFetchInfo("FetchByReg",data.rows[0]);
			    	}
				}
			});
		    
	    }
    });
    
    $("#HPNo").keydown(function(e) {
	    if (e.keyCode == "13") {
		    var iHPNo = $("#HPNo").val();
	    	BClear_click("1");
    		$("#HPNo").val(iHPNo);
		    $HUI.datagrid("#FetchReport", { url:$URL, queryParams:{ClassName:"web.DHCPE.FetchReport", QueryName:"SearchFetchReport", HPNo:iHPNo, NoFetchReport:"Y"}, 
		    	onLoadSuccess:function(data) {
			    	if (data.rows.length > 0) {
				    	$("#FetchReport").datagrid("selectRow", 0);
						$('#BFetch').linkbutton('enable');
				    	ShowFetchInfo("FetchByHPNo",data.rows[0]);
			    	}
				}
			});
		    
	    }
    });
});

function InitCombobox() {
	// VIP�ȼ�
	$HUI.combobox("#VIPLevel", {
		url:$URL+"?ClassName=web.DHCPE.HISUIOrderSets&QueryName=SearchVIPLevel&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		panelHeight:"210",
		allowNull:false,
		editable:false,
		onLoadSuccess: function(data){
	    }
	});
	
	// ��λ
	$HUI.combogrid("#Group", {
		panelWidth:450,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
			param.ShowPersonGroup="1";
		},
		onChange:function() {
		},
		columns:[[
			{field:'TRowId',title:'����ID',width:70},
			{field:'TGDesc',title:'��������',width:185},
			{field:'TGStatus',title:'״̬',width:70},
			{field:'TAdmDate',title:'����',width:100}
		]]
	});
}

function InitDataGrid() {
	$HUI.datagrid("#FetchReport", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.FetchReport",
			QueryName:"SearchFetchReport",
			StartDate:$("#StartDate").datebox('getValue'),
			EndDate:$("#EndDate").datebox('getValue'),
			RegNo:$("#DoRegNo").val(),
			HPNo:$("#HPNo").val(),
			NoFetchReport:($("#NoFetchReport").checkbox('getValue')?"Y":"N"),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			Name:$("#Name").val(),
			GroupID:$("#Group").combogrid('getValue'),
			DepartName:$("#DepartName").val()
		},
		frozenColumns:[[
			{field:'Select', title:'ѡ��', width:50, checkbox:true},
			{field:'TRegNo', title:'�ǼǺ�', width:100, align:'center'}
		]],
		columns:[[
			{field:'ReportID', title:'ReportID', hidden:true},
			{field:'PreIADM', title:'PreIADM', hidden:true},
			{field:'PreGBI', title:'PreGBI', hidden:true},
			{field:'ReportStatus', title:'ReportStatus', hidden:true},
			{field:'RepoerSend', title:'RepoerSend', hidden:true},
			
			{field:'TName', title:'����'},
			{field:'TSex', title:'�Ա�', align:'center'},
			{field:'TBirth', title:'��������', align:'center'},
			{field:'TAge', title:'����', hidden:true},
			{field:'TCardType', title:'֤������', align:'center'},
			{field:'TIDCard', title:'֤����', align:'center'},
			{field:'TVIPLevel', title:'VIP�ȼ�', align:'center'},
			{field:'TGroupName', title:'��λ', width:450},
			{field:'TDepartName', title:'����'},
			{field:'TReportStatus', title:'����״̬', align:'center'},
			{field:'TRepoerSend', title:'��ȡ��ʽ', align:'center'},
			{field:'TAppDate', title:'����Լ��', align:'center'},
			{field:'TSendUser', title:'������', align:'center'},
			{field:'TSendDate', title:'��������', align:'center'},
			{field:'TSendTime', title:'����ʱ��', align:'center', hidden:true},
			{field:'THPNo', title:'�����', align:'center'},
			
			{field:'TFetchInfo', title:'��ȡ����Ϣ', align:'center',
				formatter:function(value, rowData, rowIndex) {
					return "<a href='#' onclick='ShowFetchInfo(\"FetchByIndex\",\"" + rowIndex + "\")'>��ȡ����Ϣ</a>";
				}
			}
		]],
		collapsible: true, //�����������
		lines:true,
		striped:true, // ���ƻ�
		rownumbers:true,
		fit:true,
		fitColumns:true,
		animate:true,
		pagination:true,   // ���α�� ���ܷ�ҳ
		pageSize:25,
		pageList:[10,25,50,100],
		singleSelect: false,
		checkOnSelect: true, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: true,
		
		onClickRow: function (rowIndex, rowData) {  // ѡ�����¼�
		},
		onDblClickRow: function (rowIndex, rowData) {  // ˫�����¼�
		},
		onLoadSuccess:function(data) {
		}
	});
}

function BSearch_click() {
	var StartDate = "", EndDate = "", RegNo = "", HPNo = "", NoFetchReport = "", VIPLevel = "", Name = "", GroupID = "", DepartName = "";
	
	StartDate = $("#StartDate").datebox('getValue');
	if (StartDate == "") { $.messager.alert("��ʾ", "��ѡ��ʼ�����ٽ��в�ѯ��", "info"); return false; }
	
	EndDate = $("#EndDate").datebox('getValue');
	if (EndDate == "") { $.messager.alert("��ʾ", "��ѡ����������ٽ��в�ѯ��", "info"); return false; }
	
	if ($("#NoFetchReport").checkbox('getValue')) {
		//$('#BFetch').linkbutton('enable');
		$('#BFetch').linkbutton({ text:'������ȡ' });
		ButtonType = "Cancel";
	} else {
		//$('#BFetch').linkbutton('disable');
		$('#BFetch').linkbutton({ text:'��ȡ����' });
		ButtonType = "";
	}
	
	$HUI.datagrid("#FetchReport", {
		url:$URL,
		queryParams:{
			ClassName:"web.DHCPE.FetchReport",
			QueryName:"SearchFetchReport",
			StartDate:StartDate,
			EndDate:EndDate,
			RegNo:$("#DoRegNo").val(),
			HPNo:$("#HPNo").val(),
			NoFetchReport:($("#NoFetchReport").checkbox('getValue')?"Y":"N"),
			VIPLevel:$("#VIPLevel").combobox('getValue'),
			Name:$("#Name").val(),
			GroupID:$("#Group").combogrid('getValue'),
			DepartName:$("#DepartName").val()
		},
		onLoadSuccess:function(data) {
		}
	});
}
    
function BClear_click(Type) {
	
	if (Type == "1") {
		$("#StartDate, #EndDate").datebox("setValue","");
		
		$("#DoRegNo, #HPNo, #Name, #DepartName").val("");
		
		$("#NoFetchReport").checkbox("setValue",false);
		$("#VIPLevel").combobox("setValue","");
		$("#Group").combogrid("setValue","");
	} else if (Type == "0") {
		$("#NameWin,#IDCardWin,#TelWin").val("")
		var valbox = $HUI.validatebox("#NameWin", {
			required: false,
	    });
	    var valbox = $HUI.validatebox("#IDCardWin", {
			required: false,
	    });
	    var valbox = $HUI.validatebox("#TelWin", {
			required: false,
	    });
		//$("#NameWin").val("").validatebox("validate");;
		//$("#IDCardWin").val("").validatebox("validate");;
		//$("#TelWin").val("").validatebox("validate");;
	}
}
    
function BFetch_click(OneOrMore, Type, Data, Instring) {
	if (OneOrMore == "ONE") {
		if (Type == "SELF") {
			
		} else {
			var Instring = Data.ReportID + "^" + Instring;
			// alert(Data.PreIADM + ",," + ButtonType + ",," + Instring); return false;
			if (Type == "��ȡ" || Type == "MORE") {
				var ret = $.m({ClassName:"web.DHCPE.FetchReport", MethodName:"FetchReportHisui", PIADM:Data.PreIADM, NewStatus:"S", Instring:Instring}, false);
			} else  {
				var ret = $.m({ClassName:"web.DHCPE.FetchReport", MethodName:"UpdateFetchReportInfo", Instring:Instring, Flag:"1"}, false);
			}
			
			if (Type == "MORE") return ret;
			
			var Arr = ret.split("^");
			if (Arr[0] != 0) {
				$.messager.alert("��ʾ", Type + "ʧ�ܣ�" + Arr[1] + "��", "info");
				return false;
			} else {
				$.messager.alert("��ʾ", Type + "�ɹ���", "info");
				$("#FetchReport").datagrid("reload");
				BClear_click("0");
				$("#FetchInfoWin").window("close");
			}
		}
	} else {
		var Err = "";
		for(var i = 0; i < Data.length; i++){
			var ret = BFetch_click("ONE", Type, Data[i], Instring);
			
			var Arr = ret.split("^");
			if (Arr[0] != 0){
				if (Err == "") Err = Data[i].TName + " " + Arr[1];
				else Err = Err + "\r\n" + Data[i].TName + " " + Arr[1];
			}
		}
		if (Err == "")  {
			$.messager.alert("��ʾ", "������ȡ�ɹ���", "info");
			$("#FetchReport").datagrid("reload");
			$("#FetchInfoWin").window("close");
			return false;
		} else {
			$.messager.alert("��ʾ", "������ȡʧ�ܣ�����:\r\n" + Err + "", "info");
			$("#FetchReport").datagrid("reload");
			return false;
		}
	}
}

function ShowFetchInfo(Type, Data) {
	if ($("#NoFetchReport").checkbox('getValue')) {
		//$('#BFetch').linkbutton('enable');
		$('#BFetch').linkbutton({ text:'������ȡ' });
		ButtonType = "Cancel";
	} else {
		//$('#BFetch').linkbutton('disable');
		$('#BFetch').linkbutton({ text:'��ȡ����' });
		ButtonType = "";
	}
	

	if (Type == "FetchByReg" || Type == "FetchByHPNo" || Type == "FetchByIndex") {
		if (Type == "FetchByIndex") {
			var Data = $("#FetchReport").datagrid("getRows")[Data];
			if (Data.ReportStatus != "S") { $.messager.alert("��ʾ", "��δȡ���棬����ȡ����Ϣ��", "info"); return false; }
		}
		
		$("#FetchInfoWin").show();
		BClear_click("0");
		
		var ButtonText = "��ȡ";
		if (Type == "FetchByIndex") {	
			var ret = $.cm({ClassName:"web.DHCPE.FetchReport", MethodName:"GetFetchReportInfo", ReportID:Data.ReportID}, false);
			
			$("#NameWin").val(ret.Name).validatebox("validate");;
			$("#IDCardWin").val(ret.IDCard).validatebox("validate");;
			$("#TelWin").val(ret.Tel).validatebox("validate");;
			ButtonText = "�޸�";
		}
		
		var myWin = $HUI.dialog("#FetchInfoWin",{
			iconCls:'icon-w-trigger-box',
			resizable:true,
			title:'��ȡ����Ϣ',
			modal:true,
			buttonAlign:'center',
			onClose: function() { BClear_click("0"); },
			buttons:[{
				text:'&nbsp;&nbsp;&nbsp;&nbsp;' + ButtonText + '&nbsp;&nbsp;&nbsp;&nbsp;',
				handler:function(){
						
					var Name = $("#NameWin").val();
					//if (Name == "") { $.messager.alert("��ʾ", "��������ȡ��������", "info"); return false; }
					if (Name==""){
							$.messager.alert("��ʾ","��������ȡ������!","info",function(){
							var valbox = $HUI.validatebox("#NameWin", {
							required: true,
	   					});
						$("#NameWin").focus();
					});
						return false;
					}
					var IDCard = $("#IDCardWin").val();
					//if (IDCard == "") { $.messager.alert("��ʾ", "��������ȡ�����֤���룡", "info"); return false; }
					if (IDCard==""){
							$.messager.alert("��ʾ","��������ȡ�����֤����!","info",function(){
								var valbox = $HUI.validatebox("#IDCardWin", {
									required: true,
	   							});
							$("#IDCardWin").focus();
							});
					return false;
				}else{
					if (!isIdCardNo(IDCard)) return false;
				}
	
					var Tel = $("#TelWin").val();
					//if (Tel == "") { $.messager.alert("��ʾ", "��������ȡ����ϵ�绰��", "info"); return false; }
					if (Tel==""){
						$.messager.alert("��ʾ","��������ȡ����ϵ�绰!","info",function(){
								var valbox = $HUI.validatebox("#TelWin", {
								required: true,
	   						});
							$("#TelWin").focus();
						});
						return false;
					}else{
		
						if (!CheckTelOrMobile(Tel,"TelWin","")) return false;
					}

	
					var Instring = Name + "^" + IDCard + "^" + Tel;
						//alert(Instring)
					BFetch_click("ONE", ButtonText, Data, Instring);
				}
			},
			/*
			{
				text:'������ȡ',
				handler:function(){
					BFetch_click("ONE", "SELF", PreIADM, Data.ReportID);
				}
			},
			*/
			{
				text:'&nbsp;&nbsp;&nbsp;&nbsp;ȡ��&nbsp;&nbsp;&nbsp;&nbsp;',
				handler:function(){
					BClear_click("0");
					myWin.close();
				}
			}]
		});
	} else {
		var SelRows = $("#FetchReport").datagrid("getChecked");//��ȡ�������飬��������
		if(SelRows.length==0){
			$.messager.alert("��ʾ", "��ѡ�����������Ա��", "info");
			return false
		}

		if (ButtonType == "Cancel") {
			var Err = "";
			for(var i = 0; i < SelRows.length; i++) {
				var ret = $.m({ClassName:"web.DHCPE.FetchReport", MethodName:"CancelFetchReport", ID:SelRows[i].ReportID, CurStatus:"S"}, false);
				
				var Arr = ret.split("^");
				if (Arr[0] != 0){
					if (Err == "") Err = Data[i].TName + " " + Arr[1];
					else Err = Err + "\r\n" + Data[i].TName + " " + Arr[1];
				}
			}
			
			if (Err == "")  {
				$.messager.alert("��ʾ", "�����ɹ���", "info");
				$("#FetchReport").datagrid("reload");
				return false;
			} else {
				if (SelRows.length == 1) { 
					$.messager.alert("��ʾ", "����ʧ�ܣ�" + Err + "��", "info");
				} else {
					$.messager.alert("��ʾ", "��������ʧ�ܣ�����:\r\n" + Err + "", "info");
					$("#FetchReport").datagrid("reload");
				}
				return false;
			}
		} else {
			if (SelRows.length == 1) {
				ShowFetchInfo("FetchByReg", SelRows[0]);
			} else {
				var Flag = "Y", TemGBI = "";
				for(var i = 0; i < SelRows.length; i++) {
					if (SelRows[i].RepoerSend != "GS") {
						$.messager.alert("��ʾ", "���ڷ�ͳȡ��ʽ��ȡ�������Ա����ȷ�ϣ�", "info"); break;
					}
					if (SelRows[i].PreGBI == "") {
						$.messager.alert("��ʾ", "���ڷ������е���Ա����ȷ�ϣ�", "info"); break;
					}
					if (i > 0 && TemGBI != SelRows[i].PreGBI) {
						$.messager.alert("��ʾ", "���ڲ�ͬ�����е���Ա����ȷ�ϣ�", "info"); break;
					}
					TemGBI = SelRows[i].PreGBI;
					if (i == (SelRows.length -1)) Flag = "N";
				}
				if (Flag == "Y") return false;
				
				$("#FetchInfoWin").show();
				BClear_click("0");
			
				var myWin = $HUI.dialog("#FetchInfoWin",{
					iconCls:'icon-w-trigger-box',
					resizable:true,
					title:'��ȡ����Ϣ',
					modal:true,
					buttonAlign:'center',
					onClose: function() { BClear_click("0"); },
					buttons:[{
						text:'&nbsp;&nbsp;&nbsp;&nbsp;��ȡ&nbsp;&nbsp;&nbsp;&nbsp;',
						handler:function(){
						
								var Name = $("#NameWin").val();
							if (Name==""){
								$.messager.alert("��ʾ","��������ȡ������!","info",function(){
										var valbox = $HUI.validatebox("#NameWin", {
										required: true,
	   								});
									$("#NameWin").focus();
								});
								return false;
							}

							var IDCard = $("#IDCardWin").val();
							if (IDCard==""){
								$.messager.alert("��ʾ","��������ȡ�����֤����!","info",function(){
										var valbox = $HUI.validatebox("#IDCardWin", {
										required: true,
	   								});
									$("#IDCardWin").focus();
								});
								return false;
							}else{
								if (!isIdCardNo(IDCard)) return false;
							}

							
							var Tel = $("#TelWin").val();
							if (Tel==""){
									$.messager.alert("��ʾ","��������ȡ����ϵ�绰!","info",function(){
											var valbox = $HUI.validatebox("#TelWin", {
											required: true,
	   									});
										$("#TelWin").focus();
									});
									return false;
							}else{
		
								if (!CheckTelOrMobile(Tel,"TelWin","")) return false;
							}

							var Instring = Name + "^" + IDCard + "^" + Tel;
							BFetch_click("MORE", "MORE", SelRows, Instring);
						}
					},
					/*
					{
						text:'������ȡ',
						handler:function(){
							BFetch_click("ONE", "SELF", PreIADM, Data.ReportID);
						}
					},
					*/
					{
						text:'&nbsp;&nbsp;&nbsp;&nbsp;ȡ��&nbsp;&nbsp;&nbsp;&nbsp;',
						handler:function(){
							BClear_click("0");
							myWin.close();
						}
					}]
				});
			}
		}
	}
}

function isIdCardNo(pId){
	pId=pId.toLowerCase();
    var arrVerifyCode = [1,0,"x",9,8,7,6,5,4,3,2]; 
    var Wi = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2]; 
    var Checker = [1,9,8,7,6,5,4,3,2,1,1]; 
    if(pId.length != 15 && pId.length != 18){
		 $.messager.alert("��ʾ","���֤�Ź���15λ��18λ","info"); 
		return false;
    }
    var Ai=pId.length==18?pId.substring(0,17):pId.slice(0,6)+"19"+pId.slice(6,15); 
    
    if (!/^\d+$/.test(Ai))
    {
    	 $.messager.alert("��ʾ","���֤�����һλ�����Ϊ����","info");
    	return false;
    }
    var yyyy=Ai.slice(6,10), mm=Ai.slice(10,12)-1, dd=Ai.slice(12,14);
    var d=new Date(yyyy,mm,dd) , now=new Date(); 
    var year=d.getFullYear() , mon=d.getMonth() , day=d.getDate();
    if (year!=yyyy||mon!=mm||day!=dd||d>now||year<1901){
	    $.messager.alert("��ʾ","���֤�������","info");
	    return false;
    }
	for(var i=0,ret=0;i<17;i++) ret+=Ai.charAt(i)*Wi[i]; 
	Ai+=arrVerifyCode[ret%=11];
	
	if (pId.length == 18){
		if(!validId18(pId)){
			 $.messager.alert("��ʾ","���֤��������,����!","info");
			return false;
		}
	}
	if (pId.length == 15){
		if(!validId15(pId)){
			 $.messager.alert("��ʾ","���֤��������,����!","info");
			return false;
		}
	}
	return true;
}
/* 
��;����������Ƿ���ȷ�ĵ绰���ֻ��� 
���룺 �绰��
value���ַ��� 
���أ� ���ͨ����֤����true,���򷵻�false 
*/  
function isMoveTel(telephone){
 	
	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
		return false; 
	}else{ 
		return true; 
	} 

}
//��֤�绰���ƶ��绰
function CheckTelOrMobile(telephone,Name,Type){
	if (isMoveTel(telephone)) return true;
	if (telephone.indexOf('-')>=0){
		$.messager.alert("��ʾ",Type+"�̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
			$("#"+Name).focus();
		});
        return false;
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+"��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+"�����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			});
	        return false;
		}
	}
	return true;
}
function ReadRegInfo_click() {
	var dtformat = tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
	var rtn = tkMakeServerCall("DHCDoc.Interface.Inside.Service","GetIECreat")
	var myHCTypeDR = rtn.split("^")[0];
	var myInfo = DHCWCOM_PersonInfoRead(myHCTypeDR);
    var myary = myInfo.split("^");
 
	if (myary[0]=="0") { 
		SetPatInfoByXML(myary[1]); 
		//var myNameobj=document.getElementById("Name");
		//var myPatNameobj=document.getElementById('Name');
		//if ((myNameobj)&&(myPatNameobj)){
		//	myPatNameobj.value=myNameobj.value; 
		//} 
		//var mycredobj=document.getElementById("CredNo");
		/*
		var myidobj=document.getElementById('IDCard');
	  
		if ((mycredobj)&&(myidobj)){
			myidobj.value=mycredobj.value;
			
		} 
		*/
		
	}
	
	var RegNo=tkMakeServerCall("web.DHCPE.PreIBaseInfo","GetRegNoByIDCard",mycredobj.value);
	if (RegNo==""){
		return false;
	}
	var obj=document.getElementById("DoRegNo");
	if (obj) {
		obj.value=RegNo;
	}
     
}

function SetPatInfoByXML(XMLStr)
{
	XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr
	var xmlDoc=DHCDOM_CreateXMLDOMNew(XMLStr);
	if (!xmlDoc) return;
	
	//var xmlDoc=DHCDOM_CreateXMLDOM();
	//xmlDoc.async = false;
	//xmlDoc.loadXML(XMLStr);
	/*
	if(xmlDoc.parseError.errorCode != 0) 
	{    
		$.messager.alert("��ʾ",xmlDoc.parseError.reason,"info");
		return; 
	}
	*/
	var nodes = xmlDoc.documentElement.childNodes;
	if (nodes.length<=0){return;}
	for (var i = 0; i < nodes.length; i++) {

		
		//var myItemName=nodes(i).nodeName;
		//var myItemValue= nodes(i).text;
		
		var myItemName = getNodeName(nodes,i);
		
		var myItemValue = getNodeValue(nodes,i);
		if(myItemName=="Name") $("#Name").val(myItemValue);
		if(myItemName=="Address") $("#Address").val(myItemValue);
	    if(myItemName=="CredNo") $("#CredNo").val(myItemValue);
	  
		
		
		if (myCombAry[myItemName]){
			myCombAry[myItemName].setComboValue(myItemValue);

		}else{
			DHCWebD_SetObjValueXMLTrans(myItemName, myItemValue);
		}
	}
	delete(xmlDoc);
}