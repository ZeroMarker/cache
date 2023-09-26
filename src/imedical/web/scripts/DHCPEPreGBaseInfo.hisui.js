
//����	DHCPEPreGBaseInfo.hisui.js
//����	���������Ϣά��
//����	2019.05.27
//������  xy

$(function(){
			
	InitCombobox();
	
	InitPreGBaseInfoDataGrid();  
     
    //��ѯ
	$("#BFind").click(function() {	
		BFind_click();		
        });
      
    //����
	$("#BClear").click(function() {	
		BClear_click();		
        });
             
    //����
    $('#add_btn').click(function(e){
    	AddData();
    });
    
    //�޸�
    $('#update_btn').click(function(){
    	UpdateData();
    });
    
   
    $("#PAPMINo").keydown(function(e) {
		if(e.keyCode==13){
			PAPMINoChange();
		}		
    }); 
    
     $("#CardNo").keydown(function(e) {
		if(e.keyCode==13){
			CardNo_Change();
		}		
    }); 
   
   
})

//������� ������Ӧ����Ϣ
function PAPMINoChange() {
		
		var iPAPMINo=$("#PAPMINo").val();
		if(iPAPMINo==""){ return false; }
				
		iPAPMINo = RegNoMask(iPAPMINo);

		var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo)
		if(flag=="I"){
			$.messager.popover({msg: "����Ա���ڸ���,���ڸ��˻�����Ϣά���������", type: "info"});
	
	    	return false;
		}
		if(flag=="N"){
			$.messager.popover({msg: "�޴˵ǼǺŶ�Ӧ����Ϣ�������½�", type: "info"});
	
	    	return false;
		}
		var iCardTypeID=$("#CardTypeRowID").val(); //������
		
		var GCode=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetGCodeByADM",iPAPMINo)
	
		if (GCode==""){
			var ID="^"+iPAPMINo+"^"+iCardTypeID; 
			var flag=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetHISInfo",'SetHISInfo_Sel','',ID)
			//alert(flag)
			var myCardType=""
			var myCardType=flag.split("^")[1]
			var myCardDesc=""
			myCardDesc=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",myCardType)
			myCardDesc=myCardDesc.split("^")[1]
			$("#CardTypeNew").val(myCardDesc)
			
			if (flag=='0') {return websys_cancel();}
			else if(flag==""){
				var Model=tkMakeServerCall("web.DHCPE.Public.Setting","GetPAPMINoGenModel")
				if ("FreeCreate"==Model) {}
				if ("FreeCreate"!=Model) {
					$.messager.alert('��ʾ',"�ǼǺŲ�����","info");
					Clear_click();
					}
		
				}
			websys_setfocus('Desc');
		}
		if (GCode!=""){
			$.messager.popover({msg: "��������Ϣ�Ѵ���,����������", type: "info"})
			//var ID="^"+GCode; 
			//FindPatDetail(ID);
			}
			
	

}


function Clear_click()
{
	$("#Code,#Desc,#Address,#Postalcode,#Linkman1,#Bank,#Account,#Tel1,#Tel2,#Email,#Linkman2,#FAX,#PAPMINo,#Rebate,#CardNo").val("");
	
}

//����
function BClear_click()
{
	$("#GCode,#GLinkman,#GAddress,#ID").val("");
	$("#GName").combogrid('setValue',"");
	BFind_click();
}

function CardTypeCallBack(myrtn){
   var myary=myrtn.split("^");
   var rtn=myary[0];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			$("#CardNo").focus().val(CardNo);
			$("#PAPMINo").val(PatientNo);
			$("#CardTypeRowID").val(myary[8]);
			PAPMINoChange();
			event.keyCode=13; 
			break;
		case "-200": //����Ч
			$.messager.alert("��ʾ","����Ч","info",function(){$("#CardNo").focus();});
			break;
		case "-201": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			$("#CardNo").focus().val(CardNo);
			$("#PAPMINo").val(PatientNo);
			$("#CardTypeRowID").val(myary[8]);
			PAPMINoChange();
			event.keyCode=13;
			break;
		default:
	}
}


//����
function ReadCard_Click(){
	var myrtn=DHCACC_GetAccInfo7(CardTypeCallBack);	
}

function CardNo_Change()
{
	 var myCardNo=$("#CardNo").val();
	 if (myCardNo=="") return;
	var myrtn=DHCACC_GetAccInfo("",myCardNo,"","PatInfo",CardTypeCallBack);
	return false;
}

//��ѯ
function BFind_click()
{
	
    var GName=$("#GName").combogrid('getValue');
	if (($("#GName").combogrid('getValue')==undefined)||($("#GName").combogrid('getValue')=="")){var GName="";}
	var GName=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetGDescByADM",GName);

	$("#PreGBaseInfoGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreGBaseInfo",
			QueryName:"SearchPreGBaseInfo",
			GCode:$("#GCode").val(),
			GName:GName,
			GAddress:$("#GAddress").val(),
			GLinkman:$("#GLinkman").val(),
	});	
}


function AddData()
{
	
	BCRequired();
	
	$("#PAPMINo").attr('disabled',false);
	$("#Code").attr('disabled',false);
		  		   		
	$("#myWin").show();
	 
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'����',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				iconCls:'icon-w-card',
				text:'����',
				id:'ReadCard',
				handler:function(){
					ReadCard_Click()
				}
			},{
				iconCls:'icon-w-save',
				text:'����',
				id:'save_btn',
				handler:function(){
					SaveForm("")
				}
			},{
				iconCls:'icon-w-close',
				text:'�ر�',
				handler:function(){
					myWin.close();
				}
				
			}]
		});
		$('#form-save').form("clear");
		
	
}

SaveForm=function(id)
{
	 

	 var iPAPMINo=$("#PAPMINo").val();
	 if(iPAPMINo!=""){
		
	 	iPAPMINo = RegNoMask(iPAPMINo);
	 	
	 	var flag=tkMakeServerCall("web.DHCPE.PreIADM","JudgeIGByRegNo",iPAPMINo)
		 if(flag=="I"){
				$.messager.alert("��ʾ","����Ա���ڸ���,���ڸ��˻�����Ϣά���������","info");
	    		return false;
			}
		 if(flag=="N"){
			    $.messager.popover({msg: "�޴˵ǼǺŶ�Ӧ����Ϣ�������½�", type: "info"});
	
	    	    return false;
		    }
	 }
     

	 var iCode=$("#Code").val();
	 var iDesc=$("#Desc").val();
	 if (""==iDesc) {
           	var valbox = $HUI.validatebox("#Desc", {
				required: true,
	   		});
			$.messager.alert('��ʾ','�������Ʋ���Ϊ��!',"info");
		
		return false;

	}
	 var iAddress=$("#Address").val();
	 var iPostalcode=$("#Postalcode").val();
	if(!IsPostalcode(iPostalcode)){
		websys_setfocus(obj.id);
		return;
	}
	 var iLinkman1=$("#Linkman1").val();
	 if (""==iLinkman1) {
           	var valbox = $HUI.validatebox("#Linkman1", {
				required: true,
	   		});
			$.messager.alert('��ʾ','��ϵ��1����Ϊ��!',"info");
		
		return false;

	}
	
	 var iLinkman2=$("#Linkman2").val();
	 var iBank=$("#Bank").val();
	 var iAccount=$("#Account").val();
	 var iTel1=$("#Tel1").val();
	 if (""==iTel1) {
           	var valbox = $HUI.validatebox("#Tel1", {
				required: true,
	   		});
			$.messager.alert('��ʾ','��ϵ�绰1����Ϊ��!',"info");
		
		return false;

	}
	
	if(!CheckTelOrMobile(iTel1,"Tel1","��ϵ�绰1")){	
		websys_setfocus(obj.id);
		return;
	}
	
	 var iTel2=$("#Tel2").val();
	 if(iTel2!=""){
		if(!CheckTelOrMobile(iTel2,"Tel2","��ϵ�绰2")){
		websys_setfocus(obj.id);
		return;
			}
		}
		
	 var iEmail=$("#Email").val();
	 if(!IsEMail(iEmail)){
			websys_setfocus(obj.id);
			return;
		}
		
	 var iFAX=$("#FAX").val();
	 
	
	 
	 var iRebate=$("#Rebate").val();
	 if((iRebate!="")&&((iRebate<=0)||(iRebate>=100))){
		   $.messager.alert('��ʾ','������ۿ���Ӧ����0С��100',"info");
		  return false;
	 }

	  if(!IsFloat(iRebate)){
		  $.messager.alert('��ʾ','������ۿ��ʸ�ʽ����ȷ',"info");
		  return false;
	  }

	 var iCardNo=$("#CardNo").val();

	var Model=tkMakeServerCall("web.DHCPE.Public.Setting","GetPAPMINoGenModel")
	if ("NoGen"==Model) {}

	if ("Gen"==Model) {
		// �ǼǺű���
		if (""==iPAPMINo) {
			$.messager.alert('��ʾ','�ǼǺŲ���Ϊ��!',"info");
			return false;
		} 
	}
	if ("FreeCreate"==Model)
	{
		if (""==iPAPMINo) {
			$.messager.alert('��ʾ','�ǼǺŲ���Ϊ��!',"info");
			return false;
		}
		if (isNaN(iPAPMINo)){
			$.messager.alert("��ʾ","�ǼǺŲ�������","info");
			return false;
		}
	}
	
	var Instring= $.trim(id)			//			1
				+"^"+$.trim(iCode)		//��λ����	2
				+"^"+$.trim(iDesc)		//��    ��	3
				+"^"+$.trim(iAddress)		//��    ַ	4
				+"^"+$.trim(iPostalcode)	//��������	5
				+"^"+$.trim(iLinkman1)	//��ϵ��	6
				+"^"+$.trim(iBank)		//ҵ������	7
				+"^"+$.trim(iAccount)		//��    ��	8
				+"^"+$.trim(iTel1)		//��ϵ�绰1	9
				+"^"+$.trim(iTel2)		//��ϵ�绰2	10
				+"^"+$.trim(iEmail)		//�����ʼ�	11
				+"^"+$.trim(iLinkman2)		//��ϵ��2	12
				+"^"+$.trim(iFAX)		//����	13
				+"^"+$.trim(iPAPMINo)		//�ǼǺ�	14
				+"^"+$.trim(iRebate)  //�ۿ���  15
				+"^"+$.trim(iCardNo)  //CardNo
				;
	
	var flag=tkMakeServerCall("web.DHCPE.PreGBaseInfo","Save",'','',Instring);
	var Data=flag.split("^");
		flag=Data[0];
	if (""==iCode) { //�������
		iRowId=Data[1];
		
	}
	if(flag==0){

		$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
		$("#PreGBaseInfoGrid").datagrid('load',{
			ClassName:"web.DHCPE.PreGBaseInfo",
			QueryName:"SearchPreGBaseInfo",
			GCode:$("#GCode").val(),
			GName:$("#GName").combogrid('getValue'),
			GAddress:$("#GAddress").val(),
			GLinkman:$("#GLinkman").val(),
		});	
			$('#myWin').dialog('close'); 
	    }else{
		    if('Err 01'==flag){
				$.messager.alert("������ʾ","����ʧ��:�����ѱ�ʹ��,��������","error");
				return false;		
			}
			else if('Err 02'==flag){
				$.messager.alert("������ʾ","����ʧ��:��������ı����ѱ�ʹ��,�޷��޸�","error");
				return false;
			}else if('-119'==flag){
				$.messager.alert("������ʾ","����ʧ��:�������Ѿ�����","error");
				return false;
			}else if('-120'==flag){
				$.messager.alert("������ʾ","����ʧ��:�������ƺ����������ظ�","error");
				return false;
			}else if('-119g'==flag){
				$.messager.alert("������ʾ","����ʧ��:�ǼǺŶ�Ӧ�������Ѵ��ڣ������½�","error");
				return false;
			}
			else {
				$.messager.alert("������ʾ","���´��� �����:"+flag,"error");
				return false;
			}
		    
	    }
}



	
function UpdateData()
{
	var ID=$("#ID").val();
	if(ID==""){
		$.messager.alert('��ʾ',"��ѡ����޸ĵļ�¼","info");
		return
	}

	   		
	if(ID!="")
	{	
	      	FindPatDetail(ID);
			
			var Model=tkMakeServerCall("web.DHCPE.Public.Setting","GetPAPMINoGenModel")
			if ("NoGen"==Model) {
				$("#Desc").focus();
		 		var iCode=$("#Code").val();
				if(iCode!=""){
					$("#PAPMINo").attr('disabled',true);
					$("#Code").attr('disabled',true);
				}
		
			}
			
			
			$("#myWin").show();
			
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'�޸�',
				modal:true,
				buttons:[{
				iconCls:'icon-w-card',
				text:'����',
				id:'ReadCard',
				handler:function(){
					ReadCard_Click()
				}
				},{
					iconCls:'icon-w-save',
					text:'����',
					id:'save_btn',
					handler:function(){
						SaveForm(ID)
					}
				},{
					iconCls:'icon-w-close',
					text:'�ر�',
					handler:function(){
						myWin.close();
					}
				}]
			});							
	}
}


function FindPatDetail(ID){
	       
			var value=tkMakeServerCall("web.DHCPE.PreGBaseInfo","GetPreGBaseInfo",ID)
		  	var Data=value.split("^");
		  	
			var iLLoop=0;

			var iRowId=Data[iLLoop];	

			iLLoop=iLLoop+1
			//��λ����	
			$("#Code").val(Data[iLLoop])
		
			if ("0"==iRowId) {return false;}
			else{$("#ID").val(iRowId);}
		

			iLLoop=iLLoop+1;
			//��    ��	
			$("#Desc").val(Data[iLLoop])
			
			iLLoop=iLLoop+1;
			//��    ַ	
			$("#Address").val(Data[iLLoop])
			
			iLLoop=iLLoop+1;
			//��������
			$("#Postalcode").val(Data[iLLoop])	
		
			iLLoop=iLLoop+1;
			//��ϵ��	
			$("#Linkman1").val(Data[iLLoop])	
			
			iLLoop=iLLoop+1;
			//ҵ������	
			$("#Bank").val(Data[iLLoop])	
		
			iLLoop=iLLoop+1;
			//��    ��	
			$("#Account").val(Data[iLLoop])

			iLLoop=iLLoop+1;
			//��ϵ�绰1	
			$("#Tel1").val(Data[iLLoop])
			
			iLLoop=iLLoop+1;
			//��ϵ�绰2	
			$("#Tel2").val(Data[iLLoop])	

			iLLoop=iLLoop+1;
			//�����ʼ�	
			$("#Email").val(Data[iLLoop])
		
			iLLoop=iLLoop+1;
			//��ϵ��	
			$("#Linkman2").val(Data[iLLoop])
			
			iLLoop=iLLoop+1;
			//���� 
			$("#FAX").val(Data[iLLoop])
				
			iLLoop=iLLoop+1;
			// ����� 
			$("#PAPMINo").val(Data[iLLoop])
			var PAPMINo=""
			var PAPMINo=Data[iLLoop]			 
			iLLoop=iLLoop+1;
			// �ۿ��� 
			$("#Rebate").val(Data[iLLoop])
			
			iLLoop=iLLoop+1;
			$("#CardNo").val(Data[iLLoop])
		    iLLoop=iLLoop+1;
		
			
			var myCardDesc=""
			myCardDesc=tkMakeServerCall("web.DHCPE.PreIBIUpdate","CardTypeByRegNo",PAPMINo)
			myCardDesc=myCardDesc.split("^")[1]
			$("#CardTypeNew").val(myCardDesc)
}

function SetHISInfo_Sel(value) {
	
	Clear_click();
	var Data=value.split("^");
	
	var iLLoop=0;

	iLLoop=iLLoop+1;
	$("#PAPMINo").val(Data[iLLoop]);
	
	iLLoop=iLLoop+1;
	$("#Desc").val(Data[iLLoop]);
	
	iLLoop=iLLoop+1;
	$("#CardNo").val(Data[iLLoop]);
	
}

//��������ȡ��
function BCRequired()
{
	var valbox = $HUI.validatebox("#Tel1,#Linkman1,#Desc", {
				required: false,
	   		});
	
}

function InitCombobox()
{
	
		
	//����
	var GroupNameObj = $HUI.combogrid("#GName",{
		panelWidth:350,
		url:$URL+"?ClassName=web.DHCPE.PreGBaseInfo&QueryName=SearchGListByDesc",
		mode:'remote',
		delay:200,
		idField:'GBI_RowId',
		textField:'GBI_Desc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},

		columns:[[
			{field:'GBI_RowId',title:'����ID',width:80},
			{field:'GBI_Desc',title:'��������',width:140},
			{field:'GBI_Code',title:'�������',width:100}			
			
		]]
		});
}

function InitPreGBaseInfoDataGrid()
{
	
	$HUI.datagrid("#PreGBaseInfoGrid",{
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
			ClassName:"web.DHCPE.PreGBaseInfo",
			QueryName:"SearchPreGBaseInfo",
			GCode:$("#GCode").val(),
			GName:$("#GName").combogrid('getValue'),
			GAddress:$("#GAddress").val(),
			GLinkman:$("#GLinkman").val(),
		   
		},
		frozenColumns:[[
			{field:'PGBI_Code',width:'150',title:'�������'},
			{field:'PGBI_Desc',width:'200',title:'��������'},
			{field:'PGBI_PAPMINo',width:'100',title:'�ǼǺ�'},
		]],
		columns:[[
		    {field:'PGBI_RowId',title:'ID',hidden: true},
			{field:'PGBI_Address',width:'250',title:'��ַ'},
			{field:'PGBI_Linkman',width:'150',title:'��ϵ��1'},
			{field:'PGBI_Tel1',width:'150',title:'��ϵ�绰1'},
			{field:'PGBI_Linkman2',width:'150',title:'��ϵ��2'},
			{field:'PGBI_Tel2',width:'150',title:'��ϵ�绰2'},
			{field:'PGBI_Email',width:'150',title:'�����ʼ�'},
			{field:'PGBI_Postalcode',width:'150',title:'��������'},
			{field:'PGBI_Bank',width:'150',title:'ҵ������'},
			{field:'PGBI_Account',width:'150',title:'�˺�'},		
		
		]],
		onSelect: function (rowIndex, rowData) {
			   
				$("#ID").val(rowData.PGBI_RowId);
				
					
		}
		
			
	})

}

//�������� 
function  IsEMail(elem){
if (elem=="") return true;
 var pattern=/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
 if(pattern.test(elem)){
  return true;
 }else{
	 $.messager.alert("��ʾ","���������ʽ����ȷ","info");
  return false;
 }
}
//�绰����(�ƶ��������绰)
/* 
��;����������Ƿ���ȷ�ĵ绰���ֻ��� 
���룺 
value���ַ��� 
���أ� 
���ͨ����֤����true,���򷵻�false 
*/  
function IsTel(telephone){ 

	var teleReg1 = /^((0\d{2,3})-)(\d{7,8})$/;
	var teleReg2 = /^((0\d{2,3}))(\d{7,8})$/; 
	var mobileReg =/^1[3|4|5|6|7|8|9][0-9]{9}$/;
	if (!teleReg1.test(telephone)&& !teleReg2.test(telephone) && !mobileReg.test(telephone)){ 
		return false; 
	}else{ 
	
		return true; 
	} 
}

//���ܣ��˶��ֻ��ź͵绰�Ƿ���ȷ
//������telephone:�绰���� Name:Ԫ������ Type:Ԫ������
function CheckTelOrMobile(telephone,Name,Type){
	
	if (telephone.length==8) return true;
	if (IsTel(telephone)) return true;
	if (telephone.substring(0,1)==0){
		if (telephone.indexOf('-')>=0){
			$.messager.alert("��ʾ",Type+": �̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,�������ӷ���-������,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+": �̶��绰���ȴ���,�̶��绰���ų���Ϊ��3����4��λ,�̶��绰���볤��Ϊ��7����8��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}else{
		if(telephone.length!=11){
			$.messager.alert("��ʾ",Type+": ��ϵ�绰�绰����ӦΪ��11��λ,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}else{
			$.messager.alert("��ʾ",Type+": �����ڸúŶε��ֻ���,���ʵ!","info",function(){
				$("#"+Name).focus();
			})
	        return false;
		}
	}
	return true;
}




//��������
function  IsPostalcode(elem){
if (elem=="") return true;
 var pattern=/[0-9]\d{5}(?!\d)/;
 if(pattern.test(elem)){
  return true;
 }else{
   $.messager.alert("��ʾ","���������ʽ����ȷ","info");
   //alert("���������ʽ����ȷ");
  return false;
 }
}


function RegNoMask(RegNo)
{
	if (RegNo=="") return RegNo;
	var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo);
	return RegNo;
}


//��֤�Ƿ�Ϊ������
function IsFloat(Value) {
	
	var reg;
	if(""==$.trim(Value)) { 
		return true; 
	}else { Value=Value.toString(); }
	reg=/^((\d+\.\d*[1-9]\d*)|(\d*[1-9]\d*\.\d+)|(\d*[1-9]\d*))$/
	//reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
	
}

