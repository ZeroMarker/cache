var BRRowID=getElementValue("BRRowID");
var BRLRowID=getElementValue("BRLRowID")
var TmpSourceID=getElementValue("TmpSourceID");
var oneBuyRequest={}
var oneBuyRequestList={}
var oneBuyRequestDetail={}
var OneArgumentation={}	//add by zy ZY0206
var hiddenFlag=0
var auditAnchor=0	//add by zy ZY0206
var ItemName=""		//add by zy ZY0222 2020-04-16
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
function initDocument()
{
	setElement("BRRequestDate",GetCurrentDate())
	setElement("BRRequestLocDR_CTLOCDesc",getElementValue("BRRequestLoc"))
	setElement("BRPurchaseTypeDR_PTDesc",getElementValue("BRPurchaseType"))
	setElement("BREquipTypeDR_ETDesc",getElementValue("BREquipType"))
	initUserInfo();
    initMessage("BuyRequest"); //��ȡ����ҵ����Ϣ
	initLookUp();
	//modified by zy 20191025 ZY0194
    var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"BRManageLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("BRManageLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
    //czf 2021-06-17 1969255
    var ETParams=[{"name":"Desc","type":"1","value":"BREquipTypeDR_ETDesc"},{"name":"GroupID","type":"3","value":curGroupID},{"name":"Flag","type":"2","value":"0"},{"name":"FacilityFlag","type":"2","value":"0"},{"name":"ManageLocID","type":"4","value":"BRManageLocDR"}];
    singlelookup("BREquipTypeDR_ETDesc","PLAT.L.EquipType",ETParams,"");
	//modified by ZY0256 20210315
    var paramsFrom=[{"name":"EquipTypeDR","type":"0","value":"BREquipTypeDR"},{"name":"StatCatDR","type":"2","value":""},{"name":"Name","type":"1","value":"BRLItemDR_MIDesc"},{"name":"AssetType","type":"2","value":""},{"name":"MaintFlag","type":"2","value":""}];
    singlelookup("BRLItemDR_MIDesc","EM.L.GetMasterItem",paramsFrom,"");
    
	defindTitleStyle();
	///add by ZY0214
	var ItemReqFlag=tkMakeServerCall("web.DHCEQ.Con.BUSContract","CheckMasterItem","91","");
	if (ItemReqFlag==0) (setRequiredElements("BRLItemDR_MIDesc"))
	//add by ZY0224 2020-04-24
	var ItemInputType=getElementValue("ItemInputType")
	if (ItemInputType==0) (setRequiredElements("BRLItemDR_MIDesc"))
	var ModelInputType=getElementValue("ModelInputType")
	if (ModelInputType==0) (setRequiredElements("IFBLModel"))
    //add by ZY 2943640 20220915
    initcomboboxData()
	// MZY0041	1427330		2020-7-22
	setRequiredElements("BRRequestDate^BRRequestLocDR_CTLOCDesc^BRPrjName^BRLName^BRManageLocDR_CTLOCDesc^BRLRequestNum^BRLHold10^BRUseLocDR_CTLOCDesc^BRLHold1_SSUSRName^BRLHold2^BRLHold3_SSUSRName^BRLHold4^BRLRequestReason^BREquipTypeDR_ETDesc"); //������
	initRadio();  //czf 2022-07-25
	fillData(); //�������
	initEvent();
	//showFieldsTip();
    setEnabled(); //��ť����
    //setElementEnabled(); //�����ֻ������ 
    initEditFields(getElementValue("ApproveSetDR"),getElementValue("CurRole"),getElementValue("Action")); //��ȡ�ɱ༭�ֶ���Ϣ
    
    initApproveButtonNew(); //��ʼ��������ť
    //add by zx 2019-09-09 ������ť��ʼ�������ð�ť���
    initButton();
	initButtonWidth();
	//modified by ZY0215 2020-04-02
	//modified by zy 20191025 ZY0194
	//if (getElementValue("BRStatus")>0) createApproveSchedule("ApproveSchedule","1",BRRowID); //add by zx 2019-09-12 ��������չʾ
	createApproveSchedule("ApproveSchedule","1",BRRowID); //add by zx 2019-09-12 ��������չʾ
	
	//createApproveRecord("OpinionRecords","91",BRRowID)
    $(".element-square-btn").css("width","28")
}

function initRadio()
{
	disableElement("BRDHold4",true);
	disableElement("BRDHold5",true);
	disableElement("BRHold4",false);	//�����ɹ�ԭ��
	$HUI.radio("#BRHold3Is",{
        onCheckChange:function(e,value){
            if(value){
	            disableElement("BRHold4",false);
	            setRequiredElements("BRHold4",true);
	        }
            else{
	            disableElement("BRHold4",true);
	            setElement("BRHold4","");
	            setRequiredElements("BRHold4",false);
	        }
        }
    });
    
	$HUI.radio("#BRDMedicalItemIs",{
        onCheckChange:function(e,value){
            if(value){
	            disableElement("BRDHold4",false);
	            disableElement("BRDHold5",false);
	            setRequiredElements("BRDHold4",true);
	            
	        }
            else{
	            disableElement("BRDHold4",true);
	            disableElement("BRDHold5",true);
	            setElement("BRDHold4","");
	            setElement("BRDHold5","");
	            setRequiredElements("BRDHold4",false);
	        }
        }
    });
	disableElement("ARPlaceCondition",true);
    $HUI.radio("#ARPlaceConditionFlagIs",{
        onCheckChange:function(e,value){
            if(value){disableElement("ARPlaceCondition",false);}
            else{
	            disableElement("ARPlaceCondition",true);
            	setElement("ARPlaceCondition","");
            }
        }
    });
	disableElement("ARPlaceReform",true);
    $HUI.radio("#ARPlaceReformFlagIs",{
        onCheckChange:function(e,value){
            if(value){disableElement("ARPlaceReform",false);}
            else{ 
            	disableElement("ARPlaceReform",true);
            	setElement("ARPlaceReform","");
            }
        }
    });
}

function initEvent()
{
	var obj=document.getElementById("BArgumentation");
	if (obj)
	{
		jQuery("#BArgumentation").linkbutton({iconCls: 'icon-w-save'});
		jQuery("#BArgumentation").on("click", BArgumentation_Clicked);
	}
	var obj=document.getElementById("BRLRequestNum");
	if (obj)
	{
		jQuery("#BRLRequestNum").on("change",SetTotal);
	}
	var obj=document.getElementById("BRLHold10");
	if (obj)
	{
		jQuery("#BRLHold10").on("change", SetTotal);
	}
	var obj=document.getElementById("BRAIAuditQuantity");
	if (obj)
	{
		jQuery("#BRAIAuditQuantity").on("change", SetAuditTotal);
	}
	var obj=document.getElementById("BRAIAuditPrice");
	if (obj)
	{
		jQuery("#BRAIAuditPrice").on("change", SetAuditTotal);
	}
	//modified by zy 20191025 ZY0194
	//�ο�ʹ������
	var obj=document.getElementById("BRDUseYearsNum");
	if (obj)
	{
		jQuery("#BRDUseYearsNum").on("change", setFeeOfDepre);
	}
	
	
    /*
    //modofied by zy ZY0206 begin
	$("#ARPlaceConditionFlag").change(function() {
		checkBoxDisplay("ARPlaceConditionFlag","ARPlaceCondition")
	})
	$("#ARPlaceReformFlag").change(function() {
		checkBoxDisplay("ARPlaceReformFlag","ARPlaceReform")
	})
	//add by ZY0224 2020-04-24
	*/
	//��ʼ�����ӵ�����
	if (BRRowID!="")
	{
		setUniteRequest()
		setIfbListForLocNum()
		setEconcalcList("Y")
		setEconcalcList("N")
		setResearchList("0")
		setResearchList("1")
		setEquipServiceList()
		setServiceConsumableList()
		setBuyRequestProcess()		//MZY0041	1427333		2020-7-22
		setBenefitDisplay()	//add by ZY260 20210428
	}
	else
	{
		 $("#ArgumentationLink").hide();	//add by ZY 20220808 1254590
	}
}
// Mozy0041	2011-2-14
function BArgumentation_Clicked()
{
	var BRLRowID=getElementValue("BRLRowID");
	if (BRLRowID=="")
	{
		messageShow("","","","�޲ɹ������豸��Ϣ!")
		return;
	}
	var str="dhceq.em.template.csp?SourceType=3&SourceID="+BRLRowID+'&CurRole='+getElementValue("CurRole")+'&ReadOnly='+getElementValue("ReadOnly")+"&Action="+getElementValue("Action");
	//var str='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQArgumentationNew&BRRowID='+GetElementValue("RowID")+'&BRLRowID='+BRLRowID+'&BRDRowID='+BRDRowID+'&ApproveSetDR='+GetElementValue("ApproveSetDR")+'&CurRole='+GetElementValue("CurRole")+'&Status='+GetElementValue("Status")+'&WaitAD='+GetElementValue("WaitAD");//hisui���� modify by lmm 2018-08-18
   	showWindow(str,"�ɹ���֤","","","icon-w-paper","modal");
}
function BSave_Clicked()
{
	if (getElementValue("BREquipTypeDR")=="")
	{
		messageShow("","","","��������Ϊ��!")
		return
	}
	if (getElementValue("BRLName")=="")
	{
		messageShow("","","","�豸����Ϊ��!")
		return
	}
	if (getElementValue("BRLHold10")=="")
	{
		messageShow("","","","Ԥ�㵥��Ϊ��!")
		return
	}
	if (getElementValue("BRLRequestNum")=="")
	{
		messageShow("","","","��������Ϊ��!")
		return
	}
	//add by zx 2019-09-09
	if(!validateNamber(getElementValue("BRLRequestNum")))
	{
		messageShow('alert','error','��ʾ','���������쳣��������.','','','');
		return;
	}
	
	//czf 2022-07-25 begin
    //modified by ZY20230110 bug:3199308
    var BRDMedicalItemIs=""
    if ($("#BRDMedicalItemIs").length > 0)
    {
        BRDMedicalItemIs=$("#BRDMedicalItemIs").radio('getValue');
        var BRDMedicalItemNot=$("#BRDMedicalItemNot").radio('getValue');
        if ((!BRDMedicalItemIs)&&(!BRDMedicalItemNot))  
        {
            messageShow("","","","��ѡ������ʹ������Ĳ�!")
            return
        }
    }
    var BRHold3Is=""
    if ($("#BRHold3Is").length > 0)
    {
        BRHold3Is=$("#BRHold3Is").radio('getValue');
        var BRHold3Not=$("#BRHold3Not").radio('getValue');
        if ((!BRHold3Is)&&(!BRHold3Not))    
        {
            messageShow("","","","��ѡ���Ƿ�����ɹ�!")
            return
        }
    }
	//var BRHold3=$("#BRHold3").radio('getValue');
	var BRDConsumption=$("#BRDConsumptionIs").radio('getValue');
	var ARPlaceConditionFlag=$("#ARPlaceConditionFlagIs").radio('getValue');
	var ARPlaceReformFlag=$("#ARPlaceReformFlagIs").radio('getValue');
	
	if (checkMustItemNull("")) return
	var data=getInputList();
	data["BRDMedicalItem"]=BRDMedicalItemIs;
	data["BRDConsumption"]=BRDConsumption;
	data["ARPlaceConditionFlag"]=ARPlaceConditionFlag;
	data["ARPlaceReformFlag"]=ARPlaceReformFlag;
	data["BRHold3"]=BRHold3Is;
	//czf 2022-07-25 end
	
	data=JSON.stringify(data);
	//alertShow(data)
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","SaveData",data,"0");
	//alertShow(jsonData)
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var BRYearFlag=getElementValue("BRYearFlag");
		var Action=getElementValue("Action");
		var RoleStep=getElementValue("RoleStep");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&YearFlag="+BRYearFlag+"&Action="+Action+"&RoleStep="+RoleStep;
		var url="dhceq.em.buyrequest.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		//alertShow("������Ϣ:"+jsonData.Data);
		messageShow('popover','error','����',"������Ϣ:"+jsonData.Data);
		return
    }
	
}

function BDelete_Clicked()
{
	if (BRRowID=="")
	{
		//alertShow("û����ⵥɾ��!")
		messageShow("","","","û�п�ɾ������!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","SaveData",BRRowID,"1");
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var WaitAD=getElementValue("WaitAD");
		var QXType=getElementValue("QXType");
		var BRYearFlag=getElementValue("BRYearFlag");
		var Action=getElementValue("Action");
		var RoleStep=getElementValue("RoleStep");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&YearFlag="+BRYearFlag+"&Action="+Action+"&RoleStep="+RoleStep;
		var url="dhceq.em.buyrequest.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		//alertShow("������Ϣ:"+jsonData.Data);
		messageShow("","","","������Ϣ:"+jsonData.Data);
		return
    }
}

function BSubmit_Clicked()
{
	if (BRRowID=="")
	{
		//alertShow("û�����뵥�ύ!");
		messageShow("","","","û�п��ύ����!")
		return;
	}
	if (checkMustItemNull("")) return
	//add by ZY0224 2020-04-24
	var YearFlag=getElementValue("YearFlag")
	var YearMinFee=parseFloat(getElementValue("YearMinFee"))
	var BRLHold10=parseFloat(getElementValue("BRLHold10"))
	if (YearFlag!="Y")
	{
		if (YearMinFee<=BRLHold10)
		{
			alertShow("����Ԥ�㵥�۳���"+YearMinFee+",ֻ����������롣")
			return
		}
	}
	///modified by ZY0266 20210531
	//Ч������Աȿ���ģʽ
	var BenefitFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",101011);
	
	if (BenefitFlag==1)
	{
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","BenefitContrast", getElementValue("BRLEquipCatDR"),getElementValue("BRUseLocDR"), getElementValue("ECWorkLoadNum"));
		jsonData=JSON.parse(jsonData)
		if (jsonData.SQLCODE==0)
		{
			OptSubmit();
		}else
		{
			if (jsonData.SQLCODE==1)
			{
				messageShow("confirm","info","��ʾ","��Ϣ:"+jsonData.Data+",�Ƿ�����ύ?","",OptSubmit,function(){
					return;
				});
			}
			else
			{
				messageShow('alert','info','����',"������Ϣ:"+jsonData.Data);
		    	return
			}
		}
	}
	else
	{
		OptSubmit();
	}
	
}
function OptSubmit()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","SubmitData",BRRowID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var WaitAD=getElementValue("WaitAD");
		var QXType=getElementValue("QXType");
		var BRYearFlag=getElementValue("BRYearFlag");
		var Action=getElementValue("Action");
		var RoleStep=getElementValue("RoleStep");
		var val="&RowID="+jsonData.Data+"&ReadOnly=1&WaitAD="+WaitAD+"&QXType="+QXType+"&YearFlag="+BRYearFlag+"&Action="+Action+"&RoleStep="+RoleStep;
		var url="dhceq.em.buyrequest.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
		//alertShow("������Ϣ:"+jsonData.Data);
		messageShow('alert','info','����',"������Ϣ:"+jsonData.Data);	//modified by ZY260 20210428
		return
    }
}
function BCancelSubmit_Clicked()
{
	if (BRRowID=="")
	{
		alertShow("û�����뵥ȡ��!");
		return;
	}
	if (getElementValue("RejectReason")=="")
	{
		alertShow("�ܾ�ԭ��Ϊ��!");
		//messageShow("","","","�ܾ�ԭ��Ϊ��!")
		setFocus("RejectReason")
		return
	}
	var combindata=GetAuditData();
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","CancelSubmitData",combindata,CurRole);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var WaitAD=1;	//modofied by zy ZY0206
		var QXType=getElementValue("QXType");
		var BRYearFlag=getElementValue("BRYearFlag");
		var Action=getElementValue("Action");
		var RoleStep=getElementValue("RoleStep");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&YearFlag="+BRYearFlag+"&Action="+Action+"&RoleStep="+RoleStep;
		var url="dhceq.em.buyrequest.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.location.href= url;
	}
	else
    {
	    
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }	
}

function BApprove_Clicked()
{
	if (BRRowID=="")
	{
		alertShow("û�����뵥���!");
		return;
	}
	if (getElementValue("EditOpinion")=="")
	{
		alertShow("�����������Ϊ��!");
		return;
	}
	if (checkMustItemNull("")) return
	var CurRole=getElementValue("CurRole")
  	if (CurRole=="") return;
	var RoleStep=getElementValue("RoleStep")
  	if (RoleStep=="") return;
	var Action=getElementValue("Action")
	var BRLRequestNum=parseInt(getElementValue("BRLRequestNum"))			//add by wl 2019-11-26 begin WL0016
	var BRAIAuditQuantity=parseInt(getElementValue("BRAIAuditQuantity"))
	if(BRAIAuditQuantity>BRLRequestNum)  
	{ 
		messageShow("","","","��д��ǰ�������������������")
		return;
	}																				
	if ((getElementValue("BuyUserDR")=="")&(Action=="BuyReq_Assign"))
	{
		url="dhceq.em.buyrequestassign.csp?&Action="+Action+"&RowIDs="+BRRowID+"&CurRole="+CurRole+"&RoleStep="+RoleStep;
		messageShow('confirm','info','��ʾ',"��ǰ������Ҫ�ɵ����ɹ�Ա!","",confirmFun,""); //add by wl 2019-11-26 end WL0016
		return;
	}
	var combindata=GetAuditData();
	//var objtbl=getParentTable("ISInStockNo")
	var EditFieldsInfo=approveEditFieldsInfo("");
	if (EditFieldsInfo=="-1") return;
	//alertShow("combindata="+combindata+"EditFieldsInfo="+EditFieldsInfo)
	//return
  	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","AuditData",combindata,CurRole,RoleStep,EditFieldsInfo);
    var jsonData=JSON.parse(jsonData)
    if (jsonData.SQLCODE==0)
    {
		var WaitAD=getElementValue("WaitAD"); 
		var QXType=getElementValue("QXType");
		var BRYearFlag=getElementValue("BRYearFlag");
		var Action=getElementValue("Action");
		var RoleStep=getElementValue("RoleStep");
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&QXType="+QXType+"&YearFlag="+BRYearFlag+"&Action="+Action+"&RoleStep="+RoleStep;
		var url="dhceq.em.buyrequest.csp?"+val
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
	    window.setTimeout(function(){window.location.href=url},50); 
    }
    else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}
//add by wl 2019-11-27 WL0016
function confirmFun()
{
	showWindow(url,"����ɹ�Ա","","","icon-w-paper","modal","","","small",reloadGrid)
}
function GetAuditData()
{
	var ValueList="";
	ValueList=BRRowID;
	ValueList=ValueList+"^"+getElementValue("CancelToFlowDR");
	ValueList=ValueList+"^"+getElementValue("EditOpinion");
  	ValueList=ValueList+"^"+getElementValue("OpinionRemark");
	ValueList=ValueList+"^"+getElementValue("RejectReason");
	ValueList=ValueList+"^"+curUserID;
	ValueList=ValueList+"^"+getElementValue("RoleStep");	//czf 2021-05-17 begin 1837956
	ValueList=ValueList+"^"+getElementValue("ActionID");
	ValueList=ValueList+getElementValue("SplitNumCode");
	var Action=getElementValue("Action");
	if ((Action=="BuyReq_Research")||(Action=="BuyReq_Decision"))	//����������������ű����������
	{
		if ($("#DHCEQBuyReqList").length>0)		//�����ɹ�����
		{
			var rows = $("#DHCEQBuyReqList").datagrid('getRows');
			var RowNo = ""
			for (var i = 0; i < rows.length; i++) 
			{
				var val=rows[i].BRAIRowID;
				val=val+"^"+rows[i].BRLRowID;
				val=val+"^"+rows[i].BRAIAuditQuantity;
				val=val+"^"+rows[i].BRAIAuditPrice;
				val=val+"^"+rows[i].BRAIAuditTotalFee;
				val=val+"^"+rows[i].BRAIHold1;
				val=val+"^"+rows[i].BRAIHold2;
				val=val+"^"+rows[i].BRAIHold3;
				val=val+"^"+rows[i].BRAIHold4;
				val=val+"^"+rows[i].BRAIHold5;
				ValueList=ValueList+val;
				ValueList=ValueList+val+getElementValue("SplitRowCode");
			}
		}
		else
		{
			///modified by ZY0277 20210810
			ValueList=ValueList+getElementValue("BRAIRowID");	//7
			ValueList=ValueList+"^"+getElementValue("BRLRowID");	//BRLRowID
			ValueList=ValueList+"^"+getElementValue("BRAIAuditQuantity");
			ValueList=ValueList+"^"+getElementValue("BRAIAuditPrice");
			ValueList=ValueList+"^"+getElementValue("BRAIAuditTotalFee");
			ValueList=ValueList+"^"+getElementValue("BRAIHold1");
			ValueList=ValueList+"^"+getElementValue("BRAIHold2");
			ValueList=ValueList+"^"+getElementValue("BRAIHold3");
			ValueList=ValueList+"^"+getElementValue("BRAIHold4");
			ValueList=ValueList+"^"+getElementValue("BRAIHold5");
		}
	}
	return ValueList;		//czf 2021-05-17 end 1837956
}
function fillData()
{
	$("#auditpanel").panel('close'); //add by zx 2019-09-12 ������Ĭ�Ϲر�
	if (BRRowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("ApproveRoleDR");
	//alertShow("BRRowID="+BRRowID+",Action="+Action+",Step="+Step+",ApproveRoleDR="+ApproveRoleDR)
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","GetOneBuyRequest",BRRowID,ApproveRoleDR,Action,Step)
	//messageShow("","","",jsonData)
	
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	
	setElementByJson(jsonData.Data);
	setElement("RejectReason",jsonData.BRRejectReason);
	oneBuyRequest=jsonData.Data
    if (jsonData.Data["MultipleRoleFlag"]=="1")
    {
	    setElement("NextRoleDR",getElementValue("CurRole"));
	    setElement("NextFlowStep",getElementValue("RoleStep"));
	}
	
	//czf 2022-08-04 begin
	var BRHold3=oneBuyRequest["BRHold3"];
	if((BRHold3=="1")||(BRHold3=="true")){
		$("#BRHold3Is").radio({'checked':true});
		disableElement("BRHold4",false);
	}else{
		$("#BRHold3Not").radio({'checked':true});
		disableElement("BRHold4",true);
	}
	//czf 2022-08-04 begin
	
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","GetOneBuyRequestList",BRRowID)
	//messageShow("","","",jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	oneBuyRequestList=jsonData.Data
	
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","GetOneBuyRequestDetail",oneBuyRequestList.BRLRowID)
	//messageShow("","","",jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	//setElement("BRDMedicalItem",1);
	oneBuyRequestDetail=jsonData.Data;
	
	//add by czf 2022-07-25 begin
	var BRDMedicalItem=oneBuyRequestDetail["BRDMedicalItem"];
	var BRDConsumption=oneBuyRequestDetail["BRDConsumption"];
	
	if((BRDMedicalItem=="1")||(BRDMedicalItem=="true")){
		$("#BRDMedicalItemIs").radio({'checked':true});
		disableElement("BRDHold4",false);
		disableElement("BRDHold5",false);
	}else{
		$("#BRDMedicalItemNot").radio({'checked':true});
		disableElement("BRDHold4",true);
		disableElement("BRDHold5",true);
	}
	if((BRDConsumption=="1")||(BRDConsumption=="true")) $("#BRDConsumptionIs").radio({'checked':true});
	else $("#BRDConsumptionNot").radio({'checked':true});
	//add by czf 2022-07-25 end
	
	//modofied by zy ZY0206 begin
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","GetOneArgumentation",oneBuyRequestList.BRLRowID)
	//messageShow("","","",jsonData)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	//setElement("BRDMedicalItem",1);
	OneArgumentation=jsonData.Data;
	
	//add by czf 2022-07-25 begin
	var ARPlaceConditionFlag=OneArgumentation["ARPlaceConditionFlag"];
	var ARPlaceReformFlag=OneArgumentation["ARPlaceReformFlag"];
	if((ARPlaceConditionFlag=="1")||(ARPlaceConditionFlag=="true")){
		$("#ARPlaceConditionFlagIs").radio({'checked':true});
		disableElement("ARPlaceCondition",false);
	}else $("#ARPlaceConditionFlagNot").radio({'checked':true});
	if((ARPlaceReformFlag=="1")||(ARPlaceReformFlag=="true")){
		$("#ARPlaceReformFlagIs").radio({'checked':true});
		disableElement("ARPlaceReform",false);
	}
	else $("#ARPlaceReformFlagNot").radio({'checked':true});
	//add by czf 2022-07-25 end
	
	//modofied by zy ZY0206 end
	//modified by zy 20191025 ZY0194
	var IFBLRowID=getElementValue("IFBLRowID")
	if (IFBLRowID!="")
	{
		jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFBList","GetIFBListByID",IFBLRowID)
		//messageShow("","","",jsonData)
		jsonData=jQuery.parseJSON(jsonData);
		if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}

		setElementByJson(jsonData.Data);
		//setElement("BRDMedicalItem",1);
		oneIFBList=jsonData.Data;
	}

	//modified by zy 20200402 ZY0215
	var ECRowID=getElementValue("ECRowID")
	if (ECRowID!="")
	{
		jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEconCalc","GetOneEconCalc",ECRowID)
		//messageShow("","","",jsonData)
		jsonData=jQuery.parseJSON(jsonData);
		if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
		setElementByJson(jsonData.Data);
		OneEconCalc=jsonData.Data;
	}
	//end by zy 20200402 ZY0215
	
	var lastoneBuyReqAuditInfo="";
	var Action=getElementValue("Action");
	var step=getElementValue("RoleStep");
	if (step<1) return;
	for (var i=1;i<=step;i++)
	{
		$("#auditpanel").panel('open'); //add by zx 2019-09-12 �������
		auditAnchor=1  //����ê���ʱ���������ϢҲ���� //modofied by zy ZY0206 
		var HTML=""
		jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","GetOneBuyReqAuditInfo",oneBuyRequestList.BRLRowID,i)
		//alertShow(jsonData)
		jsonData=jQuery.parseJSON(jsonData);
		//if (jsonData.SQLCODE<0) return;
		var oneBuyReqAuditInfo=jsonData.Data
		//ֻ����Action�ڵ��к;��ߵ�ʱ��ſ�����д���������ͼ۸�
		if ((oneBuyReqAuditInfo=="")&&(Action!="BuyReq_Research")&&(Action!="BuyReq_Decision")) continue;
		//Ĭ����ʾǰ���ֵ
		if ((i==step)&(oneBuyReqAuditInfo==""))
		{
			oneBuyReqAuditInfo=lastoneBuyReqAuditInfo
			oneBuyReqAuditInfo.BRAIRowID=""
		}
		var BRAIRowID="" 
		if (oneBuyReqAuditInfo!="") BRAIRowID=oneBuyReqAuditInfo.BRAIRowID
		var BRAIActionDR_ADesc="" 
		if (oneBuyReqAuditInfo!="") BRAIActionDR_ADesc=oneBuyReqAuditInfo.BRAIActionDR_ADesc
		var BRAIAuditQuantity="" 
		if (oneBuyReqAuditInfo!="") BRAIAuditQuantity=oneBuyReqAuditInfo.BRAIAuditQuantity
		var BRAIAuditPrice="" 
		if (oneBuyReqAuditInfo!="") BRAIAuditPrice=oneBuyReqAuditInfo.BRAIAuditPrice
        var BRAIAuditTotalFee="0.00";	// MZY0149	3158816		2023-01-09	����Ĭ��ֵ
		if (oneBuyReqAuditInfo!="") BRAIAuditTotalFee=oneBuyReqAuditInfo.BRAIAuditTotalFee
		
		if (i==step)
		{
			BRAIActionDR_ADesc="��д��ǰ���";
			setElement("BRAIRowID",BRAIRowID);
			HTML=HTML+'<div class="eq-table-td eq-table-label"><label id="cBRAIAuditQuantity" for="BRAIAuditQuantity">'+BRAIActionDR_ADesc+'  ����</label></div>';
			HTML=HTML+'<div class="eq-table-td eq-table-input"><input class="hisui-validatebox" id="BRAIAuditQuantity" value="'+BRAIAuditQuantity+'"></div>';
			HTML=HTML+'<div class="eq-table-td eq-table-label"><label id="cBRAIAuditPrice" for="BRAIAuditPrice">����</label></div>';
			HTML=HTML+'<div class="eq-table-td eq-table-input"><input class="hisui-validatebox" id="BRAIAuditPrice" value="'+BRAIAuditPrice+'"></div>';
			HTML=HTML+'<div class="eq-table-td eq-table-label"><label id="cBRAIAuditTotalFee" for="BRAIAuditTotalFee">�ܽ��</label></div>';
			HTML=HTML+'<div class="eq-table-td eq-table-input"><input class="hisui-validatebox" style="border-color:#fff;background-color:#fff" id="BRAIAuditTotalFee" disabled="true" value="'+BRAIAuditTotalFee+'"></div>';
			
			$("div[name='AuditPriceAndNum']").empty();
			$("div[name='AuditPriceAndNum']").append(HTML);
            $.parser.parse("div[name='AuditPriceAndNum']"); // MZY0149	3158816		2023-01-09
			setRequiredElements("BRAIAuditQuantity^BRAIAuditPrice^BRAIAuditTotalFee"); //������
		}else	//(i<step)
		{
			if (oneBuyReqAuditInfo!="")
			{
				lastoneBuyReqAuditInfo=oneBuyReqAuditInfo
				HTML=HTML+'<div class="eq-table-tr">'
				HTML=HTML+'<div class="eq-table-td eq-table-label"><span>'+BRAIActionDR_ADesc+'  ����:</span></div>';
				HTML=HTML+'<div class="eq-table-td eq-table-input"><span>'+BRAIAuditQuantity+'</span></div>';
				HTML=HTML+'<div class="eq-table-td eq-table-label"><span>����:</span></div>';
				HTML=HTML+'<div class="eq-table-td eq-table-input"><span>'+BRAIAuditPrice+'</span></div>';
				HTML=HTML+'<div class="eq-table-td eq-table-label"><span>�ܽ��:</span></div>';
				HTML=HTML+'<div class="eq-table-td eq-table-input"><span>'+BRAIAuditTotalFee+'</span></div>';
				HTML=HTML+'</div>'
				$("div[name='AuditPriceAndNum']").before(HTML);
			}
		}
	}
}
function setEnabled()
{
	var Status=getElementValue("BRStatus");
	var WaitAD=getElementValue("WaitAD");
	var ReadOnly=getElementValue("ReadOnly");
	if (Status!="0")
	{
		//modofied by zy ZY0206 begin
		hiddenObj("BDelete",1);
		hiddenObj("BSubmit",1);
		//disableElement("BDelete",true)
		//disableElement("BSubmit",true)
		if (Status!="")
		{
			//disableElement("BSave",true)
			hiddenObj("BSave",1);
		}
		//modofied by zy ZY0206 end
	}
	//��˺�ſɴ�ӡ������ת�Ƶ�
	if (Status!="2")
	{
		//modofied by zy ZY0206
		hiddenObj("BPrint",1)
		//disableElement("BPrint",true)
	}
	//�ǽ����ݲ˵�,���ɸ��µȲ�������
	//if (WaitAD!="off") //add by zx 2019-09-06 hisui��ѡ�е�checkboxֵΪchecked,����Ԫ��Ϊ1
	if ((WaitAD=="1")||(WaitAD=="checked"))
	{
		//modofied by zy ZY0206 begin
		hiddenObj("BSave",1);
		hiddenObj("BDelete",1);
		hiddenObj("BSubmit",1);
		//disableElement("BSave",true);
		//disableElement("BDelete",true);
		//disableElement("BSubmit",true);
		//modofied by zy ZY0206 end
		setElement("ReadOnly",1);
		hiddenObj("hiddeFlag",1);
		
	}
	///modefied by zy 20190111 ZY0184
	///���ϰ�ť
	disableElement("BCancel",true);
	if (Status=="2")
	{
		var CancelOper=getElementValue("CancelOper")
		if (CancelOper=="Y")
		{
			disableElement("BCancel",false);
			//2019-05-29  ZY0186  �����������Ѿ��������¼�,�˴�����Ҫ�ظ�����
			//var obj=document.getElementById("BCancel");
			//if (obj) obj.onclick=BCancel_Clicked;
		}
		//���״̬�õ���,�����Ϣһֱ������ʾ
		auditAnchor=1
	}
	else
	{
		hiddenObj("BCancel",1); 
	}
	var Action=getElementValue("Action");
	if (Action!="BuyReq_Decision")
	{
		//hiddenObj("BuyReq_Decision",1);
		if (Action=="")
		{
		    $("div[name='AuditInfo']").each(function(){
			    $(this).hide();
			});
		}
	}
	
	//setArgumentationInfo()  //add by zx 2019-09-16
	setArgumentation();
	//modofied by zy ZY0206 begin
	//checkBoxDisplay("ARPlaceConditionFlag","ARPlaceCondition")
	//checkBoxDisplay("ARPlaceReformFlag","ARPlaceReform")
	//modofied by zy ZY0206 end
	if (Status>0)
	{
	    $("#requestpanel").find("input").each(function(){
		    //$(this).attr("id");
		    disableElement($(this).attr("id"),true);
		});
	    $("#requestpanel").find("textarea").each(function(){
		    //$(this).attr("id");
		    disableElement($(this).attr("id"),true);
		});
	    $("#argumentpanel").find("input").each(function(){
		    //$(this).attr("id");
		    disableElement($(this).attr("id"),true);
		});
	    $("#argumentpanel").find("textarea").each(function(){
		    //$(this).attr("id");
		    disableElement($(this).attr("id"),true);
		});
	}
	//add by ZY0265 20210526
	var BenefitFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo",101011);
	if (BenefitFlag!=1) hiddenObj("cBenefitDisplay",1); 
}
//add by zy ZY0206 begin
//ͨ��chechbox ��������һ��ԭʼ�Ƿ���ʾ
function checkBoxDisplay(checkBoxID,elementID)
{
	if (getElementValue(checkBoxID))
	{
		//add by ZY0214 
		disableElement(elementID,false);
		//hiddenObj(elementID,0);
		//hiddenObj("c"+elementID,0);
	}
	else
	{
		//add by ZY0214 
		disableElement(elementID,true);
		//hiddenObj(elementID,1);
		//hiddenObj("c"+elementID,1);
	}
}
/// author: add by zx 2019-09-10
/// description: ��֤��Ϣ��ʾ����
function setArgumentation()
{
	var argValue=getElementValue("argValue");
	if (argValue=="") argValue=0;
	argValue=parseFloat(argValue);
	//modified by zy 20191025 ZY0194
	var argMust=getElementValue("argMust");
	//modified by zy ZY0223 2020-04-17
	if (argMust=="2")
	{
		argValue=0;
		setRequiredElements("ECWorkLoadNum^ECServiceIncome^ECMaintFee^ECFeeOfEmployee^ECPositiveRate^ECMaterialIncome^ECMaterialFee^ECBuildingFee^ECEffect^ECEnergyFee^ARClinicEffect^BRLHold9^ARPersonnelState^ARPolluteState^ARPlaceConditionFlag^ARPlaceReformFlag"); //������
	}
	var BRLHold10=getElementValue("BRLHold10");
	if (BRLHold10=="") BRLHold10=0;
	BRLHold10=parseFloat(BRLHold10);
	//modofied by zy ZY0206 begin
	var showFlag=0;
	if(argValue<=BRLHold10) 
	{
		showFlag=1;
		setRequiredElements("ECWorkLoadNum^ECServiceIncome^ECMaintFee^ECFeeOfEmployee^ECPositiveRate^ECMaterialIncome^ECMaterialFee^ECBuildingFee^ECEffect^ECEnergyFee^ARClinicEffect^BRLHold9^ARPersonnelState^ARPolluteState^ARPlaceConditionFlag^ARPlaceReformFlag",true); //������
	}
	else
	{
		showFlag=0;
		setRequiredElements("ECWorkLoadNum^ECServiceIncome^ECMaintFee^ECFeeOfEmployee^ECPositiveRate^ECMaterialIncome^ECMaterialFee^ECBuildingFee^ECEffect^ECEnergyFee^ARClinicEffect^BRLHold9^ARPersonnelState^ARPolluteState^ARPlaceConditionFlag^ARPlaceReformFlag",false); //������
	}
	setAnchorInfo(showFlag)
	//modofied by zy ZY0206 end
}
//add by zy ZY0206 begin
//����ê�������
/**
 * ê����������
 * @author zx 2023-01-10
 */
function setAnchorInfo(showFlag)
{
	if(showFlag==1)
	{
		//ÿ�μ���֮ǰ�Ƴ���ʽ
		$("#Anchor").empty();
		//modified by ZY20230209 bug:3232106
		//����˳�������һ��
		var dataArr = [{"actionDesc":"���뵥","anchorPoint":"requestpanel"},
                {"actionDesc":"������Ϣ","anchorPoint":"baseInfopanel"},
                {"actionDesc":"ͬ���豸��Ϣ","anchorPoint":"peerpanel"},
                {"actionDesc":"����Ч��","anchorPoint":"benefitpanel"},
                {"actionDesc":"���Ч��","anchorPoint":"socialpanel"},
                {"actionDesc":"ʹ������","anchorPoint":"uesdpanel"}];
        if (auditAnchor==1)
		{
			dataArr.push({"actionDesc":"������Ϣ","anchorPoint":"auditpanel"});
		}
		var anchorHtml = createAnchor(dataArr);
		$("#Anchor").append(anchorHtml);
		$("#baseInfopanel").panel('open'); 
		$("#benefitpanel").panel('open'); 
		$("#socialpanel").panel('open');
		$("#uesdpanel").panel('open'); 
		/*var id='Anchor';
		var section='';
		var item="";
		var lastFlag=0;
		var onOrOff=0
		
		//section='eq-lifeinfo-lock.png^��ʼ';
		section='';
		item='^^%^href="#ApproveSchedule"^��ʼ'
		opt={id:id,section:section,item:item,lastFlag:lastFlag,onOrOff:onOrOff}
		createTimeLine(opt);
		
		section='';
		item='^^'+'%^'+'href="#requestpanel"'+'^���뵥'
		opt={id:id,section:section,item:item,lastFlag:lastFlag,onOrOff:onOrOff}
		createTimeLine(opt);
		
		$("#baseInfopanel").panel('open'); 
		section='';
		item='^^'+'%^'+'href="#baseInfopanel"'+'^������Ϣ';
		opt={id:id,section:section,item:item,lastFlag:lastFlag,onOrOff:onOrOff}
		createTimeLine(opt); 
		
		$("#benefitpanel").panel('open'); 
		section='';
		item='^^'+'%^'+'href="#benefitpanel"'+'^����Ч��';
		opt={id:id,section:section,item:item,lastFlag:lastFlag,onOrOff:onOrOff}
		createTimeLine(opt); 
		
		$("#socialpanel").panel('open');
		section='';
		item='^^'+'%^'+'href="#socialpanel"'+'^���Ч��';
		opt={id:id,section:section,item:item,lastFlag:lastFlag,onOrOff:onOrOff}
		createTimeLine(opt);
		
		$("#uesdpanel").panel('open'); 
		section='';
		item='^^'+'%^'+'href="#uesdpanel"'+'^ʹ������';
		opt={id:id,section:section,item:item,lastFlag:lastFlag,onOrOff:onOrOff}
		createTimeLine(opt);
		
		if (auditAnchor==1)
		{
			section='';
			item='^^'+'%^'+'href="#auditpanel"'+'^�����Ϣ';
			opt={id:id,section:section,item:item,lastFlag:lastFlag,onOrOff:onOrOff}
			createTimeLine(opt);
		}*/
	}
	else
	{
		$("#benefitpanel").panel('close'); 
		$("#socialpanel").panel('close'); 
		$("#uesdpanel").panel('close'); 
		//$("#auditpanel").panel('close');  //modified by ZY0209
		$("#Anchor").empty();
	}
}
/**
 * ê��ѡ���¼�����
 * @author zx 2023-01-10
 */
$("#Anchor").on("click",'a',function () {
	//����ʽ�������������ʽ
	$("#Anchor b").each(function(index,value){
		var len = $("#Anchor b").length;
		$(this).attr("class","");
		if(index===0) {
    		$(this).addClass("eq-anchor-first-point");
		}else if (index===len-1){
    		$(this).addClass("eq-anchor-point eq-anchor-last-point");
		}else{
    		$(this).addClass("eq-anchor-point");
		}
	})
	$("#Anchor a").css("color","#000000");
	$(this).css("color","#339eff");
    var pointEle = $(this).parent().prev();
	$(pointEle).attr("class","");
    $(pointEle).addClass("eq-anchor-point-select");
 });

//hisui.common.js���������Ҫ
//add by csj 20181103 onChange����¼�
function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
			//add by ZY0277 20210810
			///��������豸��ʱ���������Ϣ����
			if (vElementDR=="BRLItemDR")
			{
				setElement("BRLEquipCatDR","");
				setElement("BRLEquipCatDR_ECDesc","");
				setElement("BRLUnitDR","");
				setElement("BRLUnitDR_UOMDesc","");
				setElement("BRLStatCatDR","");
				setElement("BRLStatCatDR_SCDesc","");
				setElement("BRDUseYearsNum","");
			}			
		}
	}
}
 
function setSelectValue(elementID,rowData)
{
	///modified by ZY0197
	if(elementID=="BRLItemDR_MIDesc"){setMasterItem(rowData)}
	else if (elementID=="BRUseLocDR_CTLOCDesc") {
			setElement("BRUseLocDR",rowData.TRowID)
			getCountInLoc();	//add by ZY0197
		}	////add by ZY0224 2020-04-24
	else if (elementID=="BRPurchaseTypeDR_PTDesc") {
			setElement("BRPurchaseTypeDR",rowData.TRowID)
			var BRPurchaseTypeDR=rowData.TRowID
			if (BRPurchaseTypeDR=="1")
			{
                $("div[name='Argumentation-PurchaseType']").each(function(){
                    $(this).show();
                });
			}
			else if (BRPurchaseTypeDR=="2")
			{
                $("div[name='Argumentation-PurchaseType']").each(function(){
                    $(this).show();
                });
			}
			else if (BRPurchaseTypeDR=="3")
			{
			    $("div[name='Argumentation-PurchaseType']").each(function(){
				    $(this).hide();
                    setElement($(this).id,"")
				});
			}
		}
	else {setDefaultElementValue(elementID,rowData)}
	/*
	if(elementID=="BRUseLocDR_CTLOCDesc") {setElement("BRUseLocDR",rowData.TRowID)}
	else if(elementID=="BRManageLocDR_CTLOCDesc") {setElement("BRManageLocDR",rowData.TRowID)}	//modified by zy 20191025 ZY0194
	else if(elementID=="BREquipTypeDR_ETDesc") {setElement("BREquipTypeDR",rowData.TRowID)}
	else if(elementID=="BRPurchaseTypeDR_ODesc") {setElement("BRPurchaseTypeDR",rowData.TRowID)}
	else if(elementID=="BRLManuFactoryDR_MFName") {setElement("BRLManuFactoryDR",rowData.TRowID)}
	else if(elementID=="BRLPurposeTypeDR_PTDesc") {setElement("BRLPurposeTypeDR",rowData.TRowID)}
	else if(elementID=="BRLFundsOriginDR_FTDesc") {setElement("BRLFundsOriginDR",rowData.TRowID)}
	else if(elementID=="BRLItemDR_MIDesc"){setMasterItem(rowData)}
	*/
}

function setMasterItem(rowData)
{
	setElement("BRLItemDR_MIDesc",rowData.TName);
	//modified by ZY0222 2020-04-16
	setElement("BRLItemDR",rowData.TRowID);
	setElement("BRLEquipCatDR",rowData.TCatDR);
	setElement("BRLEquipCatDR_ECDesc",rowData.TCat);
	setElement("BRLUnitDR",rowData.TUnitDR);
	setElement("BRLUnitDR_UOMDesc",rowData.TUnit);
	setElement("BREquipTypeDR",rowData.TEquipTypeDR);
	setElement("BREquipTypeDR_ETDesc",rowData.TEquipType);
	setElement("BRLStatCatDR",rowData.TStatCatDR);
	setElement("BRLStatCatDR_SCDesc",rowData.TStatCat);
	setElement("BRDUseYearsNum",rowData.TLimitYearsNum);
	getCountInLoc();
	setFeeOfDepre();
	//modified by zy 20191025 ZY0194
	setCostFee();
	SetReclaimYearsNum();
	//modified by ZY0222 2020-04-16
	ItemName=rowData.TName
	if (getElementValue("BRPrjName")=="")
	{
		setElement("BRPrjName",ItemName);
	}
	else
	{
		messageShow("confirm","","","�Ƿ��滻�����豸����?","",BRPrjNameconfirmFun,"")
	}
	if (getElementValue("BRLName")=="")
	{
		setElement("BRLName",ItemName);
	}
	else
	{
		messageShow("confirm","","","�Ƿ��滻�����豸����?","",BRLNameconfirmFun,"")
	}
}
//modified by ZY0222 2020-04-16
function BRPrjNameconfirmFun()
{
	setElement("BRPrjName",ItemName);
}
//modified by ZY0222 2020-04-16
function BRLNameconfirmFun()
{
	setElement("BRLName",ItemName);
}
///modified by ZY00197
function getCountInLoc()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","GetBRCountInLoc",getElementValue("BRLItemDR"),getElementValue("BRUseLocDR"))
	var list=jsonData.split("^");
	setElement("BRDCountNum",list[0]);
	setElement("BRDCountInLoc",list[1]);
}

function setFeeOfDepre()
{
	var UseYearsNum=+getElementValue("BRDUseYearsNum");
	//if (IsValidateNumber(UseYearsNum,0,1,0,0)==0) return;
	var PriceFee=+getElementValue("BRLHold10");
	//if (IsValidateNumber(PriceFee,0,1,0,0)==0) return;
	//UseYearsNum=parseFloat(UseYearsNum);
	//PriceFee=parseFloat(PriceFee);
	//modified by zy ZY0196  20191122
	var depre=0
	if (UseYearsNum>0) depre=PriceFee/UseYearsNum;
	if (depre!="")
	{
		setElement("BRDFeeOfDepre",depre.toFixed(2));
		//modified by ZY0215 2020-04-02
		setElement("ECDepreFee",depre.toFixed(2));
	}
}
//add by zy 20191025 ZY0194
function setInComeFee()
{
	var BRDWorkLoadPerWeekNum=parseFloat(+getElementValue("BRDWorkLoadPerWeekNum"));	
	//if (IsValidateNumber(UseYearsNum,0,1,0,0)==0) return;
	var BRDUsePriceFee=parseFloat(+getElementValue("BRDUsePriceFee"));
	//if (IsValidateNumber(PriceFee,0,1,0,0)==0) return;
	//UseYearsNum=parseFloat(UseYearsNum);
	//PriceFee=parseFloat(PriceFee); 
	var InComeFee=BRDWorkLoadPerWeekNum*BRDUsePriceFee;
	setElement("BRDYearIncomeFee",InComeFee.toFixed(2));
	SetReclaimYearsNum()
}
function setCostFee()
{
	var BRDWorkLoadPerWeekNum=parseFloat(+getElementValue("BRDWorkLoadPerWeekNum"));
	var BRDUsePerWeekNum=parseFloat(+getElementValue("BRDUsePerWeekNum"));
	var BRDFeeOfMaterial=parseFloat(+getElementValue("BRDFeeOfMaterial"));
	var BRDFeeOfEmployee=parseFloat(+getElementValue("BRDFeeOfEmployee"));
	var BRDYearMaintFee=parseFloat(+getElementValue("BRDYearMaintFee"));
	//modified by ZY0215 2020-04-02
	//var BRDFeeOfDepre=+getElementValue("BRDFeeOfDepre");
	var ECDepreFee=+getElementValue("ECDepreFee");
	
	var CostFee=BRDWorkLoadPerWeekNum*BRDUsePerWeekNum+BRDFeeOfMaterial+BRDFeeOfEmployee+BRDYearMaintFee+ECDepreFee;
	setElement("BRDCostFee",CostFee.toFixed(2));
	SetReclaimYearsNum()
}

function SetReclaimYearsNum()
{
	var PriceFee=+getElementValue("BRLHold10");
	var CostFee=+getElementValue("BRDCostFee");
	var YearIncomeFee=+getElementValue("BRDYearIncomeFee");
	if ((YearIncomeFee-CostFee)>0)
	{
		if (PriceFee<=0) return
		var ReclaimYearsNum=PriceFee/(YearIncomeFee-CostFee);
		setElement("BRDReclaimYearsNum",ReclaimYearsNum.toFixed(2));
	}
	else
	{
		setElement("BRDReclaimYearsNum","");
	}
}

function SetTotal()
{
	var PriceFee=parseFloat(+getElementValue("BRLHold10"));	
	var QuantityNum=+getElementValue("BRLRequestNum");
	var fee=PriceFee*QuantityNum;
	setElement("BRLTotalFee",fee.toFixed(2));
	//setArgumentationInfo()  add by zx 2019-09-16
	setArgumentation();
	setFeeOfDepre();
	setCostFee();
	SetReclaimYearsNum();
}
function SetAuditTotal()
{
	var BRAIAuditPrice=parseFloat(+getElementValue("BRAIAuditPrice"));	
	var BRAIAuditQuantity=+getElementValue("BRAIAuditQuantity");
	if (isNaN(BRAIAuditQuantity)||(BRAIAuditQuantity<0)||(parseInt(BRAIAuditQuantity)!=BRAIAuditQuantity))
	{
		alertShow("�� "+BRAIAuditQuantity+" ������������Ч,������!");
		return ;
	}	
	var fee=BRAIAuditPrice*BRAIAuditQuantity;
	setElement("BRAIAuditTotalFee",fee.toFixed(2));
}
//end by zy 20191025 ZY0194
/*
///Creator: zx
///CreatDate: 2018-08-23
///Description filldata��ϸ�ֶ���ʾ����ToolTip
///Input: data ��̨����̨������
function showFieldsTip()
{
	$(".eq-table-info").each(function(){
		var id=$(this).attr("id");
		if (!id) return;  //ռλԪ�ز�����
		if (id=="BRDAdviseModel") var stringDate="��д����������ְ�ơ��Ƿ���ܹ�ʹ����ѵ��";
		else if (id=="BRDHold4") var stringDate="��дʹ�������������������尲װ�ص�";
		else if (id=="BRDHold5") var stringDate="�������۷�������⣬�����ʩ";
		alertShow(stringDate)
		if (stringDate=="") return; //ֵΪ��Ԫ�ز�����
		$HUI.tooltip('#'+id,{
			position: 'bottom',
			content: function(){
					return stringDate; //��ʾֵ�ӷ��������л�ȡ
				},
			onShow: function(){
				$(this).tooltip('tip').css({
					backgroundColor: '#88a8c9',
					borderColor: '#4f75aa',
					boxShadow: '1px 1px 3px #4f75aa'
				});
			 },
			onPosition: function(){
				$(this).tooltip('tip').css('bottom', $(this).offset().bottom);
				$(this).tooltip('arrow').css('bottom', 20);
			}
		});
	});
}
*/
function uniteRequest()
{
    //add by zx 2019-09-11
    var SourceID=getElementValue("BRRowID")
    if (SourceID=="") SourceID=getElementValue("TmpSourceID")
    //add by zx 2019-09-16 ����readonly����
    var val="BRRowID="+SourceID+"&ApproveType=1&ReadOnly="+getElementValue("ReadOnly");
    url="dhceq.em.buyrequestuniteloc.csp?"+val;
    //modified by zy ZY0222 2020-04-16
    showWindow(url,"���ϲɹ�����","","","icon-w-paper","modal","","","small",setUniteRequest);
    //Modified by QW20191205 end �����:1123791  ������Ͽ��Ҳ���ʾ��������
}
function ifbListForLoc()
{
    var SourceID=getElementValue("BRLRowID")
    if (SourceID=="") SourceID=getElementValue("TmpSourceID")
    var val="&SourceType=1&SourceID="+SourceID+"&ReadOnly="+getElementValue("ReadOnly");
    var url="dhceq.em.ifblistforloc.csp?"+val;
    //modified by zy ZY0222 2020-04-16
    showWindow(url,"�ɹ�������֤-�ο�����ͺ�","","","icon-w-paper","modal","","","middle",setIfbListForLocNum);   //modify by lmm 2020-06-04  //modify by txr 2023-01-29
}
//modify by wl 2020-2-12 ����BussType RFunProFlag
function researchList(id)
{
    var SourceID=getElementValue("BRLRowID")
    if (SourceID=="") SourceID=getElementValue("TmpSourceID")
    var val="&BussType=1&SourceType=1&SourceID="+SourceID+"&ReadOnly="+getElementValue("ReadOnly")+"&RFunProFlag=2";    //modified by ZY 2706939
    var title="�ɹ�������֤-������Ŀ"
    if(id=="0")
    {
        val="&BussType=1&SourceType=1&SourceID="+SourceID+"&ReadOnly="+getElementValue("ReadOnly")+"&RFunProFlag=0";
        title="�ɹ�������֤-������Ŀ"
    }
    if(id=="1")
    {
        val="&BussType=1&SourceType=1&SourceID="+SourceID+"&ReadOnly="+getElementValue("ReadOnly")+"&RFunProFlag=1"; //modified by WY 2022-9-27 2970015
        title="�ɹ�������֤-����"
    }
    var url="dhceq.em.research.csp?"+val;
    showWindow(url,title,"","","icon-w-paper","modal","","","small",setResearchList);
}
//add by zy ZY0206 begin
//����Ԥ�����Ӱ�ť
function econcalcList(CalcFlag)
{
    var SourceID=getElementValue("BRLRowID")
    if (SourceID=="") SourceID=getElementValue("TmpSourceID")
    var val="&SourceType=1&SourceID="+SourceID+"&CalcFlag="+CalcFlag+"&ReadOnly="+getElementValue("ReadOnly");
    url="dhceq.em.econcalc.csp?"+val;
    var title="�ɹ�������֤-������Ϣ";
    if (CalcFlag=="N") title="�ɹ�������֤-���豸������";
    else if (CalcFlag=="Y") title="�ɹ�������֤-�����ܺ�";
    //modified by zy ZY0222 2020-04-16
    showWindow(url,title,"","","icon-w-paper","modal","","","middle",setEconcalcList);
}
function reloadGrid()
{
	var WaitAD=getElementValue("WaitAD"); 
	var QXType=getElementValue("QXType");
	var BRYearFlag=getElementValue("BRYearFlag");
	var Action=getElementValue("Action");
	var RoleStep=getElementValue("RoleStep");
	var RowID=getElementValue("BRRowID");
	var val="&RowID="+RowID+"&WaitAD="+WaitAD+"&QXType="+QXType+"&YearFlag="+BRYearFlag+"&Action="+Action+"&RoleStep="+RoleStep;
	var url="dhceq.em.buyrequest.csp?"+val
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
    window.location.href= url;
}
// add by wl 2019-10-25
//modify wl 2019-11-11 WL0010 
function BPrint_Clicked(){ 
	var PreviewRptFlag=getElementValue("PreviewRptFlag");  //����Ԥ����־
	var BRYearFlag=getElementValue("BRYearFlag");//��ȱ�־	
	var fileName=""	
	if(PreviewRptFlag==0)
	{ 
		if(BRYearFlag==0)
		{
	 		fileName="{DHCEQBuyRequestPrint.raq(rowid="+getElementValue("BRRowID")+";USERNAME="+curUserName+";HOSPDESC="+curSSHospitalName+")}";
		}
		if(BRYearFlag==1)
		{ 
			fileName="{DHCEQBuyYearRequestPrint.raq(rowid="+getElementValue("BRRowID")+";USERNAME="+curUserName+";HOSPDESC="+curSSHospitalName+")}";
		}
		
		DHCCPM_RQDirectPrint(fileName);
	}
	if(PreviewRptFlag==1)
	{ 
		if(BRYearFlag==0)
		{
	 	 	fileName="DHCEQBuyRequestPrint.raq&rowid="+getElementValue("BRRowID")+"&USERNAME="+curUserName+"&HOSPDESC="+curSSHospitalName;
		}
		if(BRYearFlag==1)
		{
		 	fileName="DHCEQBuyYearRequestPrint.raq&rowid="+getElementValue("BRRowID")+"&USERNAME="+curUserName+"&HOSPDESC="+curSSHospitalName;
		}
		DHCCPM_RQPrint(fileName); 
	}
}
///modified by ZY20230105 bug:3187233
//add by ZY0222 2020-04-16
function setUniteRequest()
{
    var num=tkMakeServerCall("web.DHCEQ.EM.LIBMultipleApproveInfo","UnitLocNum",BRRowID,"1")
    //$("#cUnitLocNum").html("���Ͽ��ҡ�"+num+"��");
}
//add by ZY0222 2020-04-16
function setIfbListForLocNum()
{
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFBList","GetListNum","1",oneBuyRequestList.BRLRowID)
    jsonData=jQuery.parseJSON(jsonData);
    if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
    jsonData=jsonData.Data;
    var num=jsonData.count-1;
    //add by ZY0224 2020-04-24
    if (num<0) num=0
    //$("#cIfbListForLocNum").html("���ࡾ"+num+"��");
    var firstID=jsonData.firstID
    if (firstID!="")
    {
        jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSIFBList","GetIFBListByID",firstID)
        jsonData=jQuery.parseJSON(jsonData);
        if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
        setElementByJson(jsonData.Data);
        oneIFBList=jsonData.Data;
    }
}
///modified by ZY20230105 bug:3187233
//add by ZY0222 2020-04-16
function setEconcalcList(CalcFlag)
{
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEconCalc","GetListNum","1",oneBuyRequestList.BRLRowID,CalcFlag)
    jsonData=jQuery.parseJSON(jsonData);
    if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
    jsonData=jsonData.Data;
    ///modified by ZY0237 20200805 �޸�������ʾ��������
    //add by ZY0224 2020-04-24
    if (CalcFlag=="Y")
    {
        var num=jsonData.count-1;
        if (num<0) num=0
        //$("#cEconCalcNum").html("���ࡾ"+num+"��");
        var Profit="��ƽ"
        if (jsonData.Profit>0) 
        {
            Profit="ӯ��"
        }
        else if (jsonData.Profit<0) 
        {
            Profit="����"
        }
        setElement("Profit",Profit);
        var firstID=jsonData.firstID
        if (firstID!="")
        {
            jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEconCalc","GetOneEconCalc",firstID)
            //messageShow("","","",jsonData)
            jsonData=jQuery.parseJSON(jsonData);
            if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
            setElementByJson(jsonData.Data);
            //modified by zy ZY0223 2020-04-17
            var ECDepreFee=parseFloat(getElementValue("ECDepreFee"))
            setElement("BRDFeeOfDepre",ECDepreFee.toFixed(2));
            OneEconCalc=jsonData.Data;
        }
    }
    else
    {
        setElement("ECWorkLoadNumAvg",jsonData.ECWorkLoadNumAvg);
        //var num=jsonData.count;
        //$("#cOldEconCalcNum").html("���豸��������"+num+"��");
    }
}
///modified by ZY20230105 bug:3187233
//add by ZY0224 2020-04-24
function setResearchList(RFunProFlag)
{
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSResearch","GetListNum","1","1",oneBuyRequestList.BRLRowID,RFunProFlag)
    jsonData=jQuery.parseJSON(jsonData);
    if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
    jsonData=jsonData.Data;
    //var num=jsonData.count;
    
    setElement("RDesc"+RFunProFlag,jsonData.RDesc);
    return
    if (RFunProFlag=="0")
    {
        $("#cResearchKYNum").html("��չ������Ŀ��"+num+"��");
    }
    else if (RFunProFlag=="1") 
    { 
        $("#cResearchLWNum").html("��չ���ġ�"+num+"��"); //modified by WY 2022-9-27 2970015
    }
    else
    {
        $("#cResearchXMNum").html("��չ������Ŀ��"+num+"��");
    }
    
}

//add by zy ZY0224 begin
//������Ŀ���Ӱ�ť
function equipServiceList()
{
    var SourceID=getElementValue("BRLRowID")
    if (SourceID=="") SourceID=getElementValue("TmpSourceID")
    if (getElementValue("BRStatus")>0) setElement("ReadOnly",1)
    var val="&BussType=1&SourceType=3&SourceID="+SourceID+"&ReadOnly="+getElementValue("ReadOnly");
    url="dhceq.ba.equipservice.csp?"+val;
    showWindow(url,"�ɹ�������֤-������Ŀ","","","icon-w-paper","modal","","","large",setEquipServiceList);  //modify by lmm 2020-06-04
}
///modified by ZY20230105 bug:3187233
function setEquipServiceList()
{
    var jsonData=tkMakeServerCall("web.DHCEQ.BA.CTEquipService","GetListNum","1","3",oneBuyRequestList.BRLRowID)
    jsonData=jQuery.parseJSON(jsonData);
    if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
    jsonData=jsonData.Data;
    //var num=jsonData.count;
    //$("#cEquipServiceNum").html("������Ŀ��"+num+"��");
    setElement("ESServiceDR_SIDesc",jsonData.ESServiceDR_SIDesc);
}

function serviceConsumableList()
{
    return
    var SourceID=getElementValue("BRLRowID")
    if (SourceID=="") SourceID=getElementValue("TmpSourceID")
    var val="&SourceType=1&SourceID="+SourceID+"&CalcFlag="+CalcFlag+"&ReadOnly="+getElementValue("ReadOnly");
    url="dhceq.em.econcalc.csp?"+val;
    showWindow(url,"�ɹ�������֤-�Ĳ���Ŀ","","","icon-w-paper","modal","","","small",setServiceConsumableList);
}

function setServiceConsumableList()
{
    return
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSResearch","GetListNum","1","1",oneBuyRequestList.BRLRowID)
    jsonData=jQuery.parseJSON(jsonData);
    if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
    jsonData=jsonData.Data;
    var num=jsonData.count;
    //$("#cServiceConsumableNum").html("�Ĳ���Ŀ��"+num+"��");
}

function benefitDisplay()
{
	var BRLEquipCatDR=getElementValue("BRLEquipCatDR")
	if (BRLEquipCatDR=="")
	{
        //modified by ZY20230111 bug:3199234
        messageShow("","","","����ѡ���豸��,ȷ���ʲ�����!") 
		return
	}
	var val="&EquipCatID="+BRLEquipCatDR+"&UseLocID="+getElementValue("BRUseLocDR")+"&ReportFileName=DHCEQBenefitReportDisplay.rpx";
	url="dhceq.fam.benefitdisplay.csp?"+val;
	showWindow(url,"�ɹ�������֤-ͬ���豸Ч��������","","","icon-w-paper","modal","","","large",setBenefitDisplay);
}
///modified by ZY20230105 bug:3187237
function setBenefitDisplay()
{
    var BRLEquipCatDR=getElementValue("BRLEquipCatDR")
    //modified by ZY20230209 bug:3232106   �������ʾ��ֱ��ɾ��
    var UseLocID=getElementValue("BRUseLocDR")
    var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSBuyRequest","BenefitContrast",BRLEquipCatDR,UseLocID,"","1")
    jsonData=jQuery.parseJSON(jsonData);
    if (jsonData.SQLCODE<0) {messageShow("","","",jsonData.Data);return;}
    jsonData=jsonData.Data;
    setElement("benefit",jsonData.Num+"̨�豸���������"+jsonData.AvgValue);
    //$("#cBenefitDisplay").html("ͬ���豸Ч������ο�");
}
//MZY0041	1427333		2020-7-22
function setBuyRequestProcess()
{
	$("#cBuyRequestProcess").html("�ɹ��������");
}
function BuyRequestProcess()
{
	url="dhceq.em.buyrequestpocess.csp?&TRowID="+getElementValue("BRRowID");
	showWindow(url,"�ɹ��������","","","icon-w-paper","modal","","","middle");
}

//add by ZY 2943640 20220915
function initcomboboxData()
{
    var ARSettleState = $HUI.combobox('#ARSettleState',{
        valueField:'id', textField:'text',panelHeight:"auto",
        data:[{
                id: '',
                text: ''
            },{
                id: '0',
                text: '������ˮ'
            },{
                id: '1',
                text: '������ˮ'
            },{
                id: '2',
                text: '�ɸ�������ˮ'
            }]
    });
    var ARPolluteState = $HUI.combobox('#ARPolluteState',{
        valueField:'id', textField:'text',panelHeight:"auto",
        data:[{
                id: '',
                text: ''
            },{
                id: '0',
                text: '��'
            },{
                id: '1',
                text: '��'
            },{
                id: '2',
                text: '�ɸ���'
            }]
    });
    var AROtherState = $HUI.combobox('#AROtherState',{
        valueField:'id', textField:'text',panelHeight:"auto",
        data:[{
                id: '',
                text: ''
            },{
                id: '0',
                text: '��'
            },{
                id: '1',
                text: '��'
            },{
                id: '2',
                text: '�ɸ���'
            }]
    });
    var ARVoltageType = $HUI.combobox('#ARVoltageType',{
        valueField:'id', textField:'text',panelHeight:"auto",
        data:[{
                id: '',
                text: ''
            },{
                id: '0',
                text: '��380V'
            },{
                id: '1',
                text: '�߱�380V'
            },{
                id: '2',
                text: '��380V�ɸ���'
            }]
    });
}
