var PageLogic={
	PrintData:"",
}
if (websys_isIE==true) {
     var script = document.createElement('script');
     script.type = 'text/javaScript';
     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
     document.getElementsByTagName('head')[0].appendChild(script);
}
$(window).load(function(){
	InitInfo();
})
$(document).ready(function(){
	Init();
	InitEvent();
	PageHandle();
	//CureApplyInfoLoad();
});

function Init(){
	if(ServerObj.DCARowId==""){
		InitItem();	
		InitArcimList();
		new Promise(function(resolve,rejected){
			CheckDiagnose("",resolve);
		}).then(function(rtn){
			if ((!rtn)||(!CheckIsAdmissions())) {
		        ResetItemStyle();
			}
		});
	}else{
		InitItem();
		$("#ArcimDesc").lookup({})
	}
}

function InitEvent(){
	$('#btnSave').bind("click",function(){
		SaveCureApply();	
	});
	
	$('#btnPrint').bind("click",function(){
		btnPrint();	
	}); 
	
	if(ServerObj.DCARowId!=""){
		$('#btnCancel').bind("click",function(){
			CancelApply(ServerObj.DCARowId);	
		}); 
	}else{
		$('#btnAppNext').bind("click",function(){
			AppNext();	
		});	
	}
	var obj=document.getElementById("OrderQty");
	if(obj){
		obj.onblur=	SetPrice;
	}
	document.onkeydown = Doc_OnKeyDown;
}

function SetPrice(){
	if(ServerObj.DCARowId!="")return;
	$('#OrderPrice').val("");
	var ItemRowID=$('#ItemRowid').val();
	if(ItemRowID==""){
		return;	
	}
	var OrderQty=$('#OrderQty').val();
	if(OrderQty==""){
		return;		
	}
	var OrderQty=parseFloat(OrderQty);
	var BillingUOM=$("#BillingUOM").combobox('getValue');
	var BillingUOMDr=CheckComboxSelData("BillingUOM",BillingUOM);
	if(BillingUOMDr==""){
		return;	
	}
	var OrderReLoc=$("#OrderReLoc").combobox('getValue');
	var OrderReLocDr=CheckComboxSelData("OrderReLoc",OrderReLoc);
	if (OrderReLocDr==""){
		//return;	
	}
	var OrderBillType=$("#OrderBillType").combobox('getValue');
	var OrderBillTypeDr=CheckComboxSelData("OrderBillType",OrderBillType);
	if(OrderBillTypeDr==""){
		//return;	
	}
	//ArcimRowid, OrderRecDepRowid, OrderPackUOMRowid, OrdRowID)
	if (ServerObj.GetPriceMethod != "") {
        //var ret = cspRunServerMethod(ServerObj.GetPriceMethod, ServerObj.EpisodeID, ItemRowID, OrderReLocDr,BillingUOMDr,"");
        var ret=$.cm({
	    	ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"GetPrice",
			dataType:"text",
			'EpisodeID':ServerObj.EpisodeID,
			'ArcimRowid':ItemRowID, 
			'OrderRecDepRowid':OrderReLocDr, 
			'OrderPackUOMRowid':BillingUOMDr, 
			'OrdRowID':"",    
	    },false)
	    //alert(OrderQty+","+ret)
        var sum=OrderQty*parseFloat(ret)
        $('#OrderPrice').val(sum);
	}
}

function PageHandle(){
	if(ServerObj.DCARowId==""){
		$('#btnCancel').linkbutton("disable");
		
		var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
		var ObjScope=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"CheckAfterInit",
			'EpisodeID':ServerObj.EpisodeID,
			'ExpStr':ExpStr,
		},false);
		var value=ObjScope.result;
		if((typeof(value)!='undefined')&&(value!="0")){
			$("#warning").prop("innerText","��ʾ��Ϣ:"+value);
			$('#btnSave').linkbutton("disable");
			$('#btnPrint').linkbutton("disable");
			$('#btnAppNext').linkbutton("disable");
			$('#btnSave').unbind();
			$('#btnPrint').unbind();
			$('#btnAppNext').unbind();
		}
	}
	var PanelWidth = $("#apply_form_panel").innerWidth();
	var ItemWidth=PanelWidth*0.921;
	$(".form-table textarea").width(ItemWidth)
}

function InitInfo(){
	var DCARowId=ServerObj.DCARowId;
	var EpisodeID=ServerObj.EpisodeID;
	if(DCARowId!=""){
		initCureApplyInfo(DCARowId,"");
	}else{
		if(EpisodeID!=""){
			initCureApplyInfo("",EpisodeID)	
		}
		
	}	
}

function AppNext(){
	ServerObj.DCARowId="";
	Clear_Mes();
	Init();	
	PageHandle();
	$HUI.lookup("#ArcimDesc").clear();
}

function CancelApply(DCARowId){
	if(DCARowId!=""){
		$.messager.confirm('����',"ȷ��Ҫ���������뵥��",function(r){
			if (r){
				$.m({
					ClassName:"DHCDoc.DHCDocCure.Apply",
					MethodName:"CancelCureApply",
					'DCARowId':DCARowId,
					'UserID':session['LOGON.USERID'],
				},function testget(value){
					if(value == "0"){
						$.messager.show({title:"��ʾ",msg:"�����ɹ�"});
						//window.returnValue = true;
						websys_showModal('hide');
						websys_showModal('options').CureApplyDataGridLoad();
						websys_showModal("close");
					}else{
						if(value=="100")value="�Ѿ���ԤԼ��¼�������Ƽ�¼,��������";
						else if(value=="101")value="�����������Ѿ����,��������";
						else if(value=="102")value="������������������Ƶļ�¼,��������"
						else if(value=="103")value="�����������ѳ���,��������"
						else if(value=="104")value="�����������ѷ���,��������"
						$.messager.alert("��ʾ","����ʧ��,"+value);
						return false;
					}				
					
				});
			}
		})
	}else{
		$.messager.alert("��ʾ","���뵥��Ϣ��ȡ����");
		return false;
	}
			
}
function initCureApplyInfo(DCARowId,EpisodeID){
	PageLogic.PrintData="";
	/*if(DCARowId!=""){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"GetCureApply",
			'DCARowId':DCARowId,
		},function testget(value){
			if(value != ""){
				var CureApplyArr="",CureApplyArr="";
				var TempArr=value.split(String.fromCharCode(1));
				//DisplayPatInfo(TempArr[0])
				ResetItemStyle()
				DisplayCureInfo(TempArr[1]);
				//alert(TempArr[1])
				
			}				
		});
	}*/
	
	$.m({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		MethodName:"GetPatientBaseInfo",
		'DCARowId':DCARowId,
		'adm':EpisodeID,
	},function testget(value){
		if (value!=""){
			DisplayPatInfo(value);
		}
	});
	if(DCARowId!=""){
		var CureInfo=$.cm({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"GetCureApply",
			dataType:"text",
			'DCARowId':DCARowId,
		},false);
		if(CureInfo != ""){
			var CureApplyArr="",CureApplyArr="";
			var TempArr=CureInfo.split(String.fromCharCode(1));
			//DisplayPatInfo(TempArr[0])
			ResetItemStyle()
			DisplayCureInfo(TempArr[1]);
		}
	}
}

function DisplayCureInfo(val){
	var CureApplyArr=val.split("^");
	var ArcimDesc="",OrderQty="",BillingUOM="",OrderReLoc="",ApplyStatus="",ApplyUser="",ApplyDate="";
	var ApplyDate="",ApplyRemarks="",ApplyPlan="";
	var ApplyNo="";
	if(CureApplyArr!=""){
		var ArcimDesc=CureApplyArr[0];
		var OrderQty=CureApplyArr[2];
		var BillingUOM=CureApplyArr[3];
		var OrderReLoc=CureApplyArr[4];
		var ApplyStatus=CureApplyArr[6];
		var ApplyUser=CureApplyArr[7];
		var ApplyDate=CureApplyArr[8];
		var ApplyRemarks=CureApplyArr[13];
		var ApplyPlan=CureApplyArr[14];	
		var OrderBillType=CureApplyArr[26];	
		var OrderPrice=CureApplyArr[16];	
		var DDCISRowid=CureApplyArr[28];	
		var ItemCatDesc=CureApplyArr[29];		
		var ApplyNo=CureApplyArr[30];		
		$HUI.combobox("#CureItemCate").setValue(ItemCatDesc);
		$("#ArcimDesc").prop("innerText",ArcimDesc);
		$("#OrderQty").prop("innerText",OrderQty);
		$("#ApplyStatus").prop("innerText",ApplyStatus);
		$("#ApplyUser").prop("innerText",ApplyUser);
		$("#ApplyDate").prop("innerText",ApplyDate);
		$("#ApplyRemark").val(ApplyRemarks);
		$("#ApplyPlan").val(ApplyPlan);
		$("#OrderPrice").val(OrderPrice);
		$("#CureApplyNo").val(ApplyNo);
		$HUI.combobox("#OrderBillType").setValue(OrderBillType);
		$HUI.combobox("#BillingUOM").setValue(BillingUOM);
		$HUI.combobox("#OrderReLoc").setValue(OrderReLoc);
		CureItemPlanCombCreat(DDCISRowid);
		if(PageLogic.PrintData==""){
			PageLogic.PrintData=ArcimDesc+"^"+OrderQty+"^"+BillingUOM+"^"+OrderReLoc+"^"+ApplyUser+"^"+ApplyDate+"^"+ApplyRemarks+"^"+ApplyPlan;
		}else{
			PageLogic.PrintData=PageLogic.PrintData+"^"+ArcimDesc+"^"+OrderQty+"^"+BillingUOM+"^"+OrderReLoc+"^"+ApplyUser+"^"+ApplyDate+"^"+ApplyRemarks+"^"+ApplyPlan;
		}
	}	
}

function ResetItemStyle(){
	$HUI.lookup("#ArcimDesc").disable(); //ҽ������
	$("#OrderQty").attr("disabled",true);
	$HUI.combobox("#BillingUOM").disable()
	$HUI.combobox("#OrderReLoc").disable();
	$HUI.combobox("#OrderBillType").disable();
	$HUI.combobox("#CureItemCate").disable();
}
function DisplayPatInfo(val){
	var PatInfoObj=eval("("+val+")");
	if(typeof(PatInfoObj.baseInfoName)=='undefined'){return}
	var PatNo=PatInfoObj.baseInfoRegNo;
	var PatName=PatInfoObj.baseInfoName;
	var PatSex=PatInfoObj.baseInfoSex;
	var PatAge=PatInfoObj.baseInfoAge;
	var PatType=PatInfoObj.baseInfoInsu;
	var patBed=PatInfoObj.baseInfoBedno;
	if(patBed=="")patBed="-";
	var PatTel="";
	var PatAddress="";
	var PatNoi=PatNo
	var InfoAdmDays=PatInfoObj.baseInfoAdmDays;
	var charge="��"+PatInfoObj.baseInfoCharge;
	var Diagnosis=PatInfoObj.baseInfoDiag;
	var IconProfile=PatInfoObj.baseIconProfile;
	$("#patNo").prop("innerText",PatNoi);
	$("#patName").prop("innerText",PatName);
	$("#patSex").prop("innerText",PatSex);
	$("#patSeximg :last-child").remove();
	if(PatSex=="��"){
		var imghtml="<img src='../images/man.png' alt=''/>"
		$("#patSeximg").append(imghtml)
	}else if(PatSex=="Ů"){
		var imghtml="<img src='../images/woman.png' alt=''/>";
		$("#patSeximg").append(imghtml)
	}
	$("#patAge").prop("innerText",PatAge);
	$("#patType").prop("innerText",PatType);
	$("#patBed").prop("innerText",patBed);
	$("#charge").prop("innerText",charge);
	$("#Diagnosis").prop("innerText",Diagnosis);
	//$("#InfoAdmDays").prop("innerText",InfoAdmDays);
	//$("#patAddress").prop("innerText",PatAddress);
	//$("#IconProfile").prop("innerText",IconProfile);
	if(ServerObj.DCARowId==""){
		var trs = $("tr[class='ifhidden']"); 
		for(i = 0; i < trs.length; i++){ 
			trs[i].style.display = "none"; //�����ȡ��trs[i]��DOM���������jQuery������˲���ֱ��ʹ��hide()���� 
		}
	}
	if(PageApplyTreeObj.PrintData==""){
		PageApplyTreeObj.PrintData=PatNo+"^"+PatName+"^"+PatSex+"^"+PatAge+"^"+PatType+"^"+PatTel+"^"+PatAddress;
	}else{
		PageApplyTreeObj.PrintData=PageApplyTreeObj.PrintData+"^"+PatNo+"^"+PatName+"^"+PatSex+"^"+PatAge+"^"+PatType+"^"+PatTel+"^"+PatAddress;
	}
}
function SaveCureApply()
{
    var DCARowId=ServerObj.DCARowId;
	var EpisodeID=ServerObj.EpisodeID;
	var ApplyPlan=$("#ApplyPlan").val();
	if (ApplyPlan=="")
	{
		//$.messager.alert("��ʾ","���Ʒ�������Ϊ��");
		//return;
	}
	var ApplyRemark=$("#ApplyRemark").val();
	if((DCARowId!="")&&(DCARowId!=undefined)){
		$.m({
			ClassName:"DHCDoc.DHCDocCure.Apply",
			MethodName:"SaveCureApply",
			'DCARowId':DCARowId,
			'ApplyPlan':ApplyPlan,
			'ApplyRemark':ApplyRemark,
			'UserID':session['LOGON.USERID'],
		},function testget(value){
			if(value==0)
			{
				$.messager.alert('��ʾ','����ɹ�');
			}else{
				$.messager.alert('��ʾ','����ʧ��,�������:'+value);
			}	
		})
	}else{
		if(EpisodeID==""){
			$.messager.alert("��ʾ","������Ϣ��ȡ����");
			return;	
		}
		new Promise(function(resolve,rejected){
			CheckDiagnose("",resolve);
		}).then(function(rtn){
			if ((!rtn)||(!CheckIsAdmissions())) {
		        return;
			}
			var ItemRowID=$('#ItemRowid').val();
			if(ItemRowID==""){
				$.messager.alert("��ʾ","��ѡ��һ������ҽ��");
				return;	
			}
			if(!CheckDeposit(ItemRowID)){
				return;		
			}
			var OrderQty=$('#OrderQty').val();
			if(OrderQty==""){
				$.messager.alert("��ʾ","����д����");
				return;	
			}
			
			var TmpOrderQty=parseFloat(OrderQty);
			if(TmpOrderQty<=0){
				$.messager.alert("��ʾ","��������д����0����");
				return;		
			}
			var BillingUOM=$("#BillingUOM").combobox('getValue');
			var BillingUOMDr=CheckComboxSelData("BillingUOM",BillingUOM);
			if(BillingUOMDr==""){
				$.messager.alert("��ʾ","��ѡ��������λ");
				return;	
			}
			var OrderReLoc=$("#OrderReLoc").combobox('getValue');
			var OrderReLocDr=CheckComboxSelData("OrderReLoc",OrderReLoc);
			if (OrderReLocDr==""){
				$.messager.alert("��ʾ","��ѡ����տ���");
				return;	
			}
			var OrderBillType=$("#OrderBillType").combobox('getValue');
			var OrderBillTypeDr=CheckComboxSelData("OrderBillType",OrderBillType);
			if(OrderBillTypeDr==""){
				$.messager.alert("��ʾ","��ѡ��ѱ�");
				return;	
			}
			var ExpStr=OrderBillType+"^"+session['LOGON.GROUPID'];
			$.m({
				ClassName:"DHCDoc.DHCDocCure.Apply",
				MethodName:"InsertCureApply",
				'EpisodeID':EpisodeID,
				'ArcimRowid':ItemRowID,
				'OrderQty':OrderQty,
				'BillingUOM':BillingUOM,
				'OrderRecDepRowid':OrderReLoc,
				'ApplyPlan':ApplyPlan,
				'ApplyRemark':ApplyRemark,
				'USERID':session['LOGON.USERID'],
				'CTLOCID':session['LOGON.CTLOCID'],
				'ExpStr':ExpStr,
			},function testget(value){
				var success=value.split("^")[0];
				var msg=value.split("^")[1];
				if(success==0)
				{
					$.messager.alert('��ʾ','����ɹ�');
					ResetItemStyle();
					ServerObj.DCARowId=msg;
					var CureApplyNo=$.cm({
						ClassName:"DHCDoc.DHCDocCure.Apply",
						MethodName:"GetCureApplyNo",
						'DCARowId':ServerObj.DCARowId,
					},false);
					if(CureApplyNo!=""){
						$("#CureApplyNo").val(CureApplyNo);	
					}
				}else{
					msg='����ʧ��,'+msg
					$.messager.alert('��ʾ',msg);
				}	
			})
		});
	}
}

function CheckComboxSelData(id,selId){
	var Find=0;
	 var Data=$("#"+id).combobox('getData');
	 for(var i=0;i<Data.length;i++){
		 if (id=="ArcimDesc"){
			var CombValue=Data[i].ArcimRowID;
		 	var CombDesc=Data[i].ArcimDesc;
	     }else{
		    var CombValue=Data[i].CombValue  
		 	var CombDesc=Data[i].CombDesc
		 }
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	  }
	  if (Find=="1") return selId
	  return "";
}

function InitItem(){
	CureItemCateCombCreat();
	ItemBillUOMCombCreat("") //����װ��λ		
	DHCDocOrderRecLocCombCreat("","",0);
	DHCDocOrderBillTypeCombCreat();
	CureItemPlanCombCreat("");
}

function InitArcimList(){
	 $("#ArcimDesc").lookup({
        url:$URL,
        mode:'remote',
        disabled:false,
        method:"Get",
        idField:'ArcimRowID',
        textField:'ArcimDesc',
        columns:[[  
            {field:'ArcimDesc',title:'����',width:320,sortable:true},
			{field:'ArcimRowID',title:'ID',width:100,sortable:true},
			{field:'selected',title:'ID',width:120,sortable:true,hidden:true}
        ]],
        pagination:true,
        panelWidth:420,
        panelHeight:260,
        isCombo:true,
        minQueryLen:1,
        rownumbers:true,//���   
		fit: true,
		pageSize: 5,
		pageList: [5],
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.DHCDocCure.Apply',QueryName: 'FindAllItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
	        var CureItemFlag="on";
	        var ManualApply="on";
	        var SubCategory=$("#CureItemCate").combobox('getValue');
	        var SubCategoryID=CheckComboxSelData("CureItemCate",SubCategory);
			param = $.extend(param,{'Alias':desc,'CureItemFlag':CureItemFlag,'GroupID':session['LOGON.GROUPID'],'EpisodeID':ServerObj.EpisodeID,'UserRowId':session['LOGON.USERID'],'ManualApply':ManualApply,'SubCategory':SubCategoryID});
	    },onSelect:function(ind,item){
            var Desc=item['desc'];
			var ID=item['ArcimRowID'];
			OrderItemLookupSelect(ID,item['DDCISRowid'])
			//$HUI.lookup("#ArcimDesc").clear();
			$HUI.lookup("#ArcimDesc").hidePanel();
		}
    });
}

function OrderItemLookupSelect(icode,DDCISRowid)
{
	Clear_Mes();
	var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
	var ObjScope=$.cm({
		ClassName:"DHCDoc.DHCDocCure.Apply",
		MethodName:"CheckBeforeInsert",
		'EpisodeID':ServerObj.EpisodeID,
		'ArcimRowid':icode,
		'ExpStr':ExpStr,
	},false);
	var value=ObjScope.result;
	if((typeof(value)!='undefined')&&(value!="0")){
		var CheckArcimTypeStr=mPiece(value, "^", 0);
		var ASCheckStr=mPiece(value, "^", 1);
		if(CheckArcimTypeStr!=""){
			$HUI.lookup("#ArcimDesc").clear();
			$.messager.alert("����", CheckArcimTypeStr);
			return false;	
		}
		var ASCheckFlag = mPiece(ASCheckStr, "!", 0);
	    var ASCheckSex = mPiece(ASCheckStr, "!", 1);
	    var ASCheckAgeRange = mPiece(ASCheckStr, "!", 2);
	    if(ASCheckFlag==1){
		    $HUI.lookup("#ArcimDesc").clear();
		    var altmsg="����Ŀ������ʹ��:��������Ϊ:"+ASCheckAgeRange+",�Ա�����Ϊ:"+ASCheckSex;
			$.messager.alert("����", altmsg);
			return false;   
		}
	}
		
	
	//$HUI.textbox("#ItemRowid").setValue(icode)
	$('#ItemRowid').val(icode);
	ItemBillUOMCombCreat(icode) //����װ��λ
    DHCDocOrderRecLocCombCreat(icode,"",0); //���տ���
    CureItemPlanCombCreat(DDCISRowid);
    $("#OrderQty").focus();
}

function Clear_Mes(){
	$HUI.combobox("#OrderReLoc").setValue("");
	$HUI.combobox("#BillingUOM").setValue("");
	$HUI.combobox("#CureItemPlan").setValue("");
	$('#ItemRowid').val("");
	$HUI.numberbox("#OrderQty").setValue("")
	$HUI.combobox("#BillingUOM").setValue("")
	$HUI.combobox("#OrderReLoc").setValue("")
	//$HUI.combobox("#OrderBillType").setValue("")
	$('#ApplyPlan').val("");
	$('#ApplyRemark').val("");
	$("#OrderQty").attr("disabled",false);
	$('#OrderPrice').val("");
	$('#CureApplyNo').val("");
}

//���տ���
function DHCDocOrderRecLocCombCreat(ArcimID,DefaultOrdRecLoc,DefaultFlag){
	//ServerObj.EpisodeID
	//session['LOGON.CTLOCID']
	$HUI.combobox("#OrderReLoc",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=DHCDocOrderRecLoc"+"&Inpute1="+ArcimID+"&Inpute2="+DefaultOrdRecLoc+"&Inpute3="+DefaultFlag+"&Inpute4="+ServerObj.EpisodeID+"&Inpute5="+session['LOGON.CTLOCID']+"&ResultSetType=array",
    	onChange:function(){
			SetPrice();	
		},onLoadSuccess:function(data){
	    	var DefRecLoc="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	var DefRecLoc = data[i].CombValue;
			    	break;
			    }
		    }
		    //�����տ���ֻ��һ������Ĭ��ѡ�񣬷�������ֶ�ѡ��
		    if((DefRecLoc=="")&&(data.length==1)){
				DefRecLoc=data[0].CombValue;    
			}
	    	if(DefRecLoc!=""){$HUI.combobox("#OrderReLoc").setValue(DefRecLoc);}
	    }
	})
}

//�ѱ�
function DHCDocOrderBillTypeCombCreat(){
	$HUI.combobox("#OrderBillType",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=OrderBillType"+"&Inpute1="+ServerObj.EpisodeID+"&Inpute2="+""+"&ResultSetType=array",
    	onLoadSuccess:function(data){
	    	var DefBillType="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	var DefBillType = data[i].CombValue;
			    }
		    }
		    if((DefBillType=="")&&(data.length==1)){
				DefBillType=data[0].CombValue;    
			}
	    	if(DefBillType!=""){$HUI.combobox("#OrderBillType").setValue(DefBillType);}
	    },onChange:function(){
			SetPrice();	
		}
	})
}
function CureItemCateCombCreat(){
	$HUI.combobox("#CureItemCate",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=SubCategory&Inpute1="+""+"&Inpute2="+""+"&Inpute3=&ResultSetType=array",
    	onLoadSuccess:function(data){
	    	/*$HUI.combobox("#CureItemCate").setValue("");
	    	var DefCate="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	var DefCate = data[i].CombValue;
			    }
		    }
		    if((DefCate=="")&&(data.length==1)){
				DefCate=data[0].CombValue;    
			}
	    	if(DefCate!=""){
		    	$HUI.combobox("#CureItemCate").setValue(DefCate);
		    }*/
	    },onLoadError:function(){
		},onSelect:function(){
			ItemBillUOMCombCreat("") //����װ��λ		
			DHCDocOrderRecLocCombCreat("","",0);
			CureItemPlanCombCreat("");
			$("#ArcimDesc").lookup("reset");
			$('#ItemRowid').val("");
			$HUI.numberbox("#OrderQty").setValue("");
			$('#OrderPrice').val("");
			//$('#ApplyPlan').val("");
			//$('#ApplyRemark').val("");	
		}
	})	
} 
function CureItemPlanCombCreat(DDCISRowid){
	$HUI.combobox("#CureItemPlan",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=DHCDoc.DHCDocCure.Apply&QueryName=CombListFind&CombName=CureItemPlan&Inpute1="+DDCISRowid+"&Inpute2="+""+"&Inpute3=&ResultSetType=array",
    	onLoadSuccess:function(data){
	    	$HUI.combobox("#CureItemPlan").setValue("");
	    },onLoadError:function(data){
	    	alert(data)
	    },onSelect:function(record){
            var ID=record['CombValue'];
			var ret=$.cm({
				ClassName:"DHCDoc.DHCDocCure.CureItemSet",
				MethodName:"GetPlanDetailByID",
				dataType:"text",
				'DDCISPRowid':ID,
			},false);
			if(ret!=""){
				$("#ApplyPlan").val("");
				$("#ApplyPlan").val(ret);
			}
		}
	})
}

//����װ��λ
function ItemBillUOMCombCreat(ArcimDr)
{
	var Edit=true
	var INPut="N"
	var ChoseType=""
	$HUI.combobox("#BillingUOM",{
		valueField:'CombValue',   
    	textField:'CombDesc',
    	editable:false,
    	url:$URL+"?ClassName=web.UDHCFavItemNew&QueryName=CombListFind&CombName=ItemBillUOM&Inpute1="+INPut+"&Inpute2="+ArcimDr+"&Inpute3=&ResultSetType=array",
		onHidePanel:function(){
			 var SubDesc=$('#BillingUOM').combobox('getText')
			 if ((SubDesc!="")&&(SubDesc.indexOf("-")>0)){
				var SetDesc=SubDesc.split("-")[1]
				if (SetDesc==""){SetDesc=SubDesc}
				$('#BillingUOM').combobox('setText',SetDesc)	
			}
		},
		onChange:function(){
			SetPrice();	
		},onLoadSuccess:function(data){
			var DefBillUOM="";
	    	for(var i=0;i<data.length;i++){
		    	if(data[i].selected==1){
			    	var DefBillUOM = data[i].CombValue;
			    	break;
			    }
		    }
		    if((DefBillUOM=="")&&(data.length>0)){
				DefBillUOM=data[0].CombValue;    
			}
	    	if(DefBillUOM!=""){$HUI.combobox("#BillingUOM").setValue(DefBillUOM);}
		}
	})
}

function mPiece(s1, sep, n) {
    //Getting wanted piece, passing (string,separator,piece number)
    //First piece starts from 0
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length - 1) && (n >= 0)) return delimArray[n];
}

function btnPrint()
{	
	var DCARowId=ServerObj.DCARowId; //$('#DCARowId').val()
	if (DCARowId==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ��ӡ�����뵥��")
		return false
	}
	var getpath=tkMakeServerCall("web.UDHCJFCOMMON","getpath")
	var Template=getpath+"DHCDocCureApplyPrt.xls";
	var xlApp,xlsheet,xlBook
 
	//���ұ߾�
    xlApp = new ActiveXObject("Excel.Application");
    xlBook = xlApp.Workbooks.Add(Template);
    xlsheet = xlBook.ActiveSheet;
    xlsheet.PageSetup.LeftMargin=0;  //lgl+
    xlsheet.PageSetup.RightMargin=0;
 
	
	var xlsrow=2; //����ָ��ģ��Ŀ�ʼ����λ��
	var xlsCurcol=1;  //����ָ����ʼ������λ��
	
	
	var RtnStr=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetCureApply",DCARowId)
	var RtnStrArry=RtnStr.split(String.fromCharCode(1));
	var PatientArr=RtnStrArry[0].split("^"); //���߻�����Ϣ
	var CureApplyArr=RtnStrArry[1].split("^"); //ԤԼ����Ϣ
	//"�����Բ��������������^��ʵ^2^��^��������^
	//44^ԤԼ^��ϼ[1045]^2018-04-26 09:40:55^0^
	//2^0^0^^^
	//638^70.00^��^35.00^^
	//41^^��ԤԼ^0^"
	//s CureAppInfo=ArcimDesc_"^"_OrderStatus_"^"_OrderQty_"^"_BillingUOM_"^"_OrderReLoc_"^"_OrdReLocId_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_ApplyAppedTimes_"^"_ApplyNoAppTimes_"^"_ApplyFinishTimes_"^"_ApplyNoFinishTimes_"^"_ApplyRemarks_"^"_ApplyPlan_"^"_Adm_"^"_OrdPrice_"^"_Ordbilled_"^"_UnitPrice_"^"_FinishUser
	//s CureAppInfo=CureAppInfo_"^"_ServiceGroupDR_"^"_CallStatus_"^"_ApplyExec_"^"_ControlFlag_"^"_HistoryRes

	
	var PatID=PatientArr[0]
	var PatNo=PatientArr[1];
	var PatName=PatientArr[2];
	var PatSex=PatientArr[3];
	var PatAge=PatientArr[4];
	var PatType=PatientArr[6];
	var PatTel=PatientArr[24];
	var PatAddress=PatientArr[10];
	
	var ArcimDesc=CureApplyArr[0]
	var AppOrderQty=CureApplyArr[2]
	var AppOrderUom=CureApplyArr[3]
	AppOrderQty=AppOrderQty+AppOrderUom;
	var RelocID=CureApplyArr[5]
	var AppReloc=CureApplyArr[4]
	var ApplyStatus=CureApplyArr[6]
	var ApplyUser=CureApplyArr[7]
	var ApplyDate=CureApplyArr[8]
	var ApplyRemarks=CureApplyArr[13]
	var ApplyPlan=CureApplyArr[14]
	var AdmID=CureApplyArr[15]
	var Price=CureApplyArr[16]
	var UnitPrice=CureApplyArr[18]	
	var AppLoc=CureApplyArr[25]
	var DocCurNO=CureApplyArr[30];	
	/*var d=new Date();
	var year=d.getFullYear();
	var month=d.getMonth()+1;
	var day=d.getDate()
	var h=d.getHours();
	var m=d.getMinutes();
	var s=d.getSeconds()
	var InsertDate=year+"-"+month+"-"+day+" "+h+":"+m+":"+s;*/
	var InsertDate=CureApplyArr[27];
	var Hospital=tkMakeServerCall("DHCDoc.DHCDocCure.Apply","GetHospitalDesc",session['LOGON.HOSPID'])
	var Title=Hospital+"��������ƾ֤";
	
	xlsheet.cells(1,2)=Title;
	xlsheet.cells(xlsrow,xlsCurcol+8)=DocCurNO
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=PatName
	xlsheet.cells(xlsrow,xlsCurcol+4)=PatSex
	xlsheet.cells(xlsrow,xlsCurcol+6)=PatTel
	xlsheet.cells(xlsrow,xlsCurcol+8)=PatNo
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=PatAddress
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+6)=AppLoc
	xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyUser
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=AppOrderQty
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=AppReloc
	xlsheet.cells(xlsrow,xlsCurcol+6)=ApplyDate
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=ArcimDesc
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyPlan
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyRemarks
	xlsrow=xlsrow+1
	xlsheet.cells(xlsrow,xlsCurcol+2)=ApplyUser
	xlsheet.cells(xlsrow,xlsCurcol+6)=InsertDate

	
    xlBook.PrintOut()
    xlBook.Close (savechanges=false);
    xlApp.Quit();
	xlApp=null;
	xlsheet=null;
}
//��excel����л��ߵķ�����
function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
}

function PrintCureApply()
{
    DHCP_GetXMLConfig("InvPrintEncrypt","DHCDocCureApply");
    if(PageLogic.PrintData=="")return;
    var TempArrApply=PageLogic.PrintData.split("^");
    var PatNo=TempArrApply[0];
    var PatName=TempArrApply[1];
    var PatSex=TempArrApply[2];
    var PatAge=TempArrApply[3];
    var PatType=TempArrApply[4];
    var PatTel=TempArrApply[5];
    var PatAddress=TempArrApply[6];
    var ArcimDesc=TempArrApply[7];
    var OrderQty=TempArrApply[8];
    var BillingUOM=TempArrApply[9];
    var OrderReLoc=TempArrApply[10];
    var ApplyUser=TempArrApply[11];
    var ApplyDate=TempArrApply[12];
    var ApplyRemarks=TempArrApply[13];
    var ApplyPlan=TempArrApply[14];
    var PDlime=String.fromCharCode(2);
    var MyPara="ArcimDesc"+PDlime+ArcimDesc
    var MyPara=MyPara+"^"+"PatNo"+PDlime+PatNo
    var MyPara=MyPara+"^"+"PatName"+PDlime+PatName
    var MyPara=MyPara+"^"+"PatSex"+PDlime+PatSex
    var MyPara=MyPara+"^"+"PatAge"+PDlime+PatAge
    var MyPara=MyPara+"^"+"PatType"+PDlime+PatType
    var MyPara=MyPara+"^"+"PatTel"+PDlime+PatTel
    var MyPara=MyPara+"^"+"PatAddress"+PDlime+PatAddress
    var MyPara=MyPara+"^"+"ArcimDesc"+PDlime+ArcimDesc
    var MyPara=MyPara+"^"+"OrderQty"+PDlime+OrderQty
    var MyPara=MyPara+"^"+"BillingUOM"+PDlime+BillingUOM
    var MyPara=MyPara+"^"+"OrderReLoc"+PDlime+OrderReLoc
    var MyPara=MyPara+"^"+"ApplyUser"+PDlime+ApplyUser
    var MyPara=MyPara+"^"+"ApplyDate"+PDlime+ApplyDate
    var MyPara=MyPara+"^"+"ApplyRemarks"+PDlime+ApplyRemarks
    var MyPara=MyPara+"^"+"ApplyPlan"+PDlime+ApplyPlan
    //alert(MyPara);
    var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,"");
}


function CheckDiagnose(ordertype,callBackFun) {
	new Promise(function(resolve,rejected){
		if ((ServerObj.PAADMMotherAdmId!="")||(ServerObj.PAAdmType=="H")) {
			resolve(true);
			return;
		}
		var NeedDiagnosFlag = 1;
		//�����ﲡ������,¼����ϻ�ɾ����Ϻ�δˢ��ҽ��¼�����,�����������ȡ�Ĵ���
    	var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", ServerObj.mradm);
    	ServerObj.MRDiagnoseCount = Ret;
    	if ((ServerObj.MRDiagnoseCount == 0) && (NeedDiagnosFlag == 1)&&(ServerObj.OrderLimit!=1)) {
	    	if ((t['NO_DIAGNOSE']) && (t['NO_DIAGNOSE'] != "")) {
		    	var iframeName = window.name
	            if (iframeName == "") {
	                iframeName = window.parent.frames("oeordFrame").name
	            }
	            if ((iframeName == "oeordFrame")||(GlobalObj.CareProvType != "DOCTOR")) {
	                resolve(true);
	            }else{
			    	(function(callBackFunExec){
					    new Promise(function(resolve,rejected){
							$.messager.alert("��ʾ",t['NO_DIAGNOSE'],"info",function(){
								websys_showModal({
									url:"diagnosentry.v8.csp?PatientID=" + ServerObj.PatientID + "&EpisodeID=" + ServerObj.EpisodeID + "&mradm=" + ServerObj.mradm,
									title:'���¼��',
									width:((top.screen.width - 100)),height:(top.screen.height - 120),
									onClose:function(){
										var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", ServerObj.mradm);
							            GlobalObj.MRDiagnoseCount = Ret;
							            if (Ret == 0) { Ret = false; } else { Ret = true; }
										resolve(Ret);
									}
								})
					    	})
						}).then(function(rtn){
							callBackFunExec(rtn);
						});
				    })(resolve);
	            }
		    }else{
			    resolve(false);  
			}
	    }else{
		    //�������
		    resolve(true);
		}
	}).then(function(rtn){
		callBackFun(rtn);
	})
	
	/*if ((ServerObj.PAADMMotherAdmId!="")||(ServerObj.OrderLimit=="1")) return true;
    var NeedDiagnosFlag = 1;
    //�����ﲡ������,¼����ϻ�ɾ����Ϻ�δˢ��ҽ��¼�����,�����������ȡ�Ĵ���
    var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", ServerObj.mradm);
    var MRDiagnoseCount = Ret;
    if ((MRDiagnoseCount == 0) && (NeedDiagnosFlag == 1)) {
        dhcsys_alert("δ�����,����¼�����");
        var iframeName = window.name
        if (iframeName == "") {
            iframeName = window.parent.frames("oeordFrame").name
        }
        if (iframeName == "oeordFrame") {
            return false;
        } else {
            if (ServerObj.CareProvType == "DOCTOR") { 
                var DiagnosURL = "diagnosentry.v8.csp?PatientID=" + ServerObj.PatientID + "&EpisodeID=" + ServerObj.EpisodeID + "&mradm=" + ServerObj.mradm;
                window.showModalDialog(DiagnosURL, "", "dialogHeight: " + (top.screen.height - 100) + "px; dialogWidth: " + (top.screen.width - 100) + "px");
            }
        }
        var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", ServerObj.mradm);
        MRDiagnoseCount = Ret;
        if (Ret == 0) { Ret = false; } else { Ret = true; }
        return Ret;
    }
    return true;*/
}

//סԺ��������Ѻ�����
function CheckDeposit(arcim) {
	var amount=$('#OrderPrice').val();
    if (ServerObj.NotDoCheckDeposit==1) return true;
    if (ServerObj.SupplementMode==1){return true;}
    if ((ServerObj.PAAdmType != "I") && (ServerObj.GetStayStatusFlag != 1) && (ServerObj.GetStayStatusFlag != 2)) { return true }
    if (ServerObj.CheckIPDepositMethod != "") {
        var retDetail = cspRunServerMethod(ServerObj.CheckIPDepositMethod, ServerObj.EpisodeID, amount, "OE");
        if (retDetail != 0) {
            var retArray = retDetail.split("^");
            if (retArray[4] == 'C') {
                if (retArray[5] == 'N') {
                    dhcsys_alert("Ѻ������" + retArray[0]+",�޷�����");
                    return false;
                } else {
                    if (arcim != "") {
                        var retDetail = cspRunServerMethod(ServerObj.CheckDepositOrderMethod, retArray[2], arcim);
                        if (retDetail == 0) {
                            dhcsys_alert("Ѻ������" + retArray[0]+",�޷�����");
                            return false;
                        }
                    }
                }
            }
        }
    }
    return true;
}
function Doc_OnKeyDown(e){
	//��ֹ�ڿհ״����˸���������Զ����˵���һ������
	if (!websys_cancelBackspace(e)) return false;
	//�������Backspace������  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }  
    if (e){
        var ctrlKeyFlag=e.ctrlKey;
    }else{
        var ctrlKeyFlag=window.event.ctrlKey;
    }
    if (ctrlKeyFlag){
        return false;
	}
}
function CheckIsAdmissions(){
	var warning=$.cm({
    	ClassName:"web.DHCDocOutPatientList",
		MethodName:"CheckIsAdmissions",
		dataType:"text",
		'EpisodeID':ServerObj.EpisodeID,
		'UserID':session['LOGON.USERID']   
	},false)
	if (warning!=""){
		$.messager.alert("��ʾ",warning);
		return false;
	}
	return true;
}