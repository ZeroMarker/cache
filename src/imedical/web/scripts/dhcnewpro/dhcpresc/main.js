
var itemSelFlag = 0;   //ҳǩѡ��
var stateFlag = 0;	   //״̬
var res = ""
var auditId = "";	   //���Id
var imgurl = "../scripts/dhcnewpro/dhcpresc/images/"; //ͼ��·��
var color = ["#2AB66A","#FFB519","#FF5219","#000000"];	//��ɫ����ʾ�����ѡ���ʾ����ֹ
var stdate = formatDate(0);
var enddate= formatDate(0);
var selectIndex = -1	//����б�����
var admId = "";
var patientId = "";
var patNumFlag=""; //�Ƿ����������Աߵ�����
var loopPointer = "";
/// ҳ���ʼ������
function initPageDefault(){
	
	initCompent();				//�ж��Ƿ�����	
	initCombobox();				//��ʼ��������
	initButton();				//��ʼ��ҳ�淽��
	initAuditList();			//��ʼ������б�
	initDateBox();				//��ʼ����ѯ����
	initLisDatagrid();			//��ʼ�������б�
	initInsDatagrid();			//��ʼ������б�
	loopPointer = setInterval("reloadAuditList()",5000);		//ˢ������б��б�
	
	
}

//�ж��Ƿ�����
function initCompent()
{
	runClassMethod(
		"web.DHCPRESCAudit",
		"Isactive",
			{
				"userId":LgUserID
			},
			function(data){
				
				if((data == 0)||(data == "-1")){
					var tipstr = "";
					if(data == 0){
						tipstr = "������������״̬~";
					}
					if(data == "-1"){
						tipstr = "��δѡ������ң�����ѡ��~";
					}
					$HUI.dialog('#onlinedialog').open();
					$("#tips").html(tipstr);
				}
	},'text');
	
}
///��ʼ������б�
function initAuditList()
{
	///  ����columns
	var columns=[[
		{field:'PatLabel',title:'����б�',width:160,formatter:setCellLabel,align:'center'}
	]];
	
	///  ����datagrid
	var option = {
		showHeader:false,
		rownumbers : false,
		singleSelect : true,
        onSelect:function(rowIndex, rowData){
	        if(!rowData) return;
	        if(rowData.auditId!=auditId){
		    	patNumFlag = "";
		    	LoadPatInfo(rowData);					//���ػ��߻�����Ϣ
				LoadPrescNo(rowData.auditId);			//���ش�����Ϣ
				LoadPrescPro(rowData.auditId);			//�����������
				LoadAuditRes(rowData.auditId);			//ҩʦ������
		    }
		    admId = rowData.admId;
			patientId = rowData.patientId;
		    initLisDatagrid();			
			initInsDatagrid();
			
			auditId = rowData.auditId;
			
			
			//setTimeout("initContentfold()", 100 );
			selectIndex = rowIndex;
			
	    },
	    onClickRow:function(rowIndex, rowData){
		    LoadButtons();
		    ChangeStyle(rowData.auditId);
	        if(rowData.status=="0")
	        {
				setReadFlag(rowData.auditId);           //��Ϣ�����������Ķ���� 2022-3-7  shy
				if(stateFlag==0){
	        		$("#adtRedFlag"+rowData.auditId).css({"display":"block"});;
	        	}
	        }
	    },
		onLoadSuccess:function(data){
			if ("string" == typeof data )		//��ʱ������ѯ
			{     
				if (data.toLowerCase().indexOf("logon")>-1 || data.toLowerCase().indexOf("login")>-1)
				{      
					clearInterval(loopPointer);
				} 
			}
			var newtask = data.newtask;
			var contask = data.contask;
			var comtask = data.comtask;
			var mustedit = data.mustedit;
			var dblcheck = data.dblcheck;
			var pass = data.pass;
			$("#tt-keywords ul li").each(function(index){
				if(index==0){
					newTitile = "������("+ newtask +")";
				}
				if(index==1){
					newTitile = "�����("+ comtask +")";
				}
				if(index==2){
					newTitile = "�����޸�("+ mustedit +")";
				}
				if(index==3){
					newTitile = "˫ǩͨ��("+ dblcheck +")";
				}
				if(index==4){
					newTitile = "ͨ��("+ pass +")";
				}
				if(index==5){
				}
				updTabsTitle(index,newTitile);
				
		    });
			///ѡ����ѡ�б�
			var rows = $("#auditList").datagrid('getRows');
            for(var i=0; i<rows.length; i++ )
            {
	            if(rows[i].auditId==auditId)
	            {
		            $('#auditList').datagrid('selectRow',i);
				}
				if((rows[i].readFlag=="Y")&&(stateFlag==0)){
					$("#adtRedFlag"+rows[i].auditId).css({"display":"block"});
				}
	         }
            $('.pagination-page-list').hide();
            $('.pagination-info').hide();
            
            itemSelFlag = 1;  /// ��ѡ�б�ǰ״ֵ̬
            $("#auditList").datagrid('selectRow',selectIndex);
            var rowData = $("#auditList").datagrid('getSelected');
            if(rowData != null){
	            var overReadTime = rowData.overReadTime;
	            var readFlag = rowData.readFlag;
	            var time = "";
	           	if(overReadTime>OverTime){
		           	time = overReadTime;
		        }else{
			       	time = OverTime;
			    }
	            $("#rematime").html(time-rowData.imdtime);
	            if((time-rowData.imdtime)<5){
		            $("#rematime").html(0);
		        }
            }
            //BindTips(); /// ����ʾ��Ϣ
		},
		rowStyler:function(index,rowData){   
	        if (rowData.repStatCode == "ֹͣ"){
	            return 'background-color:Pink;'; 
	        }
	    },
	    onLoadError:function(){
		  	console.log("���б��ȡ�����쳣,ֹͣ�Զ���ѵ!");
			if(loopPointer) clearInterval(loopPointer); 
		}
	};
	var searchNo=$("#search").searchbox('getValue');  //xww 2022-03-03 �����ţ��ǼǺŻ�����
	var params = stdate + "^" + enddate + "^" + stateFlag + "^"+ LgUserID + "^" + res + "^" + searchNo + "^" + "" + "^" +MenuModule;
	var uniturl = $URL +"?ClassName=web.DHCPRESCAudit&MethodName=QueryAuditList&params="+params;
	new ListComponent('auditList', columns, uniturl, option).Init();
	
	///  ����ˢ�°�ť
	$('#auditList').datagrid('getPager').pagination({ showRefresh: false}); 
	
	///  ���ط�ҳͼ��
    var panel = $("#auditList").datagrid('getPanel').panel('panel');  
    panel.find('.pagination-page-list').hide();
    panel.find('.pagination-info').hide()
    
}

///ˢ������б�
function reloadAuditList(serachFlag)
{
	var selectPatientId = "";
	if((patNumFlag==1)&&(serachFlag!=1)){
		selectPatientId = patientId;
	}

	var searchNo=$("#search").searchbox('getValue');  //xww 2022-03-03 �����ţ��ǼǺŻ�����
	var params = stdate + "^" + enddate + "^" + stateFlag + "^"+ LgUserID + "^" + res + "^" + searchNo + "^" + selectPatientId + "^" +MenuModule; 
	$("#auditList").datagrid("reload");
}

//xww 2022-03-03
function reloadAuditListByPat(){
	patNumFlag=1;
	reloadAuditList();
}

function searchAuditList(){
	
	var inPatNo = $('#search').searchbox('getValue');
	var patNo = GetWholePatNo(inPatNo);
	$('#search').searchbox("setValue",patNo)
	reloadAuditList(1);
}

// �����б� ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){
	var patType='';
	if(rowData.patType=="E"){
		patType='<span style="color:red">(��)</span>'
	}
	var htmlstr = '<div class="celllabel">'
	 	htmlstr = htmlstr + '<h3 style="float:left;background-color:transparent;">'+ rowData.patName +patType+'</h3><span style="float:right;background-color:transparent;font-size:5px;">'+ rowData.prescNo +'</span><br>'
	 	htmlstr = htmlstr + '<span style="float:right;color:rgb(1,123,206);background-color:transparent;font-size:10px;padding-top:5px;font-weight:bold;display:none;" id=adtRedFlag'+rowData.auditId+'>�� '+rowData.readTime+'</span><br>';	 	
	 	htmlstr = htmlstr + '<span style="float:left;background-color:transparent;font-size:10px;padding-top:5px;">'+ rowData.locDesc+'</span>'
		htmlstr = htmlstr + '<span style="float:right;color:red;background-color:transparent;font-size:10px;padding-top:5px;">'+ rowData.imdtime +'</span><br>';
		htmlstr = htmlstr +'</div>';
	return htmlstr;
}

///���ػ��߻�����Ϣ
function LoadPatInfo(rowData)
{
	var patNameHtml='<a style="text-decoration:underline" href="#" onclick="reloadAuditListByPat()">('+rowData.patNum+')</a>';  //\''+rowData.patientId+'\'
	$("#patName").html(rowData.patName);		
	$("#sex").html(rowData.patSex);	
	$("#age").html(rowData.patAge);
	var weight = rowData.weight;
	if(weight!="")
	{
		weight = weight+"kg";
	}
	$("#weight").html(weight);
	$("#patNo").html(rowData.patNo);
	$("#admNo").html(rowData.admNo);
	$("#loc").html(rowData.locDesc);
	$("#doc").html(rowData.docDesc);
	$("#diag").html(rowData.spdiag);
	$("#chndiag").html(rowData.dischdiag)
	$("#docname").html(rowData.docDesc);
	$("#docimg").attr('src',"../scripts/dhcnewpro/dhcpresc/images/doc.png");
	$("#docimg").css({'width':50});
	$("#admId").val(rowData.admId);
	$("#patientId").val(rowData.patientId);
	$("#mradm").val(rowData.mradm);
	$("#locTelphone").html(rowData.locTelPhone);
	$("#docTelphone").html(rowData.docPhone);
	$("#audremark").html(rowData.docremark);
	var params = "Audit"+"^"+rowData.docId;
	//againFlushNumber(params);
	//setInterval(function(){
	//		againFlushNumber(params)
	//},5000);
	
	BindTips(rowData.diag,rowData.chndiag);
}

///���ش�����Ϣ
function LoadPrescNo(auditId)
{
	runClassMethod("web.DHCPRESCAudit","GetPrescNo",{"auditId":auditId},
		function(jsonString){
			var json= eval('(' + jsonString + ')');
			if(json.length!=0)
			{
				if(json[0].cat=="�в�ҩ"){
					AppendHerbaHtml(json);
				}else{
					AppendPrescHtml(json);
				}
			}
	},'text');
}
///������в�ҩ��html
function AppendHerbaHtml(json)
{
	var $prescInfo = $("#prescInfo");
	$prescInfo.empty();
	
	var length = json.length;
	var prescNo = json[0].prescNo;
	
	$row = $("<div class='presc-pre'></div>");
	$row.append("<span class='icon-paper-pen-blue' >&nbsp;&nbsp;&nbsp;&nbsp;</span>");
	$row.append("<span class='presc-col' >����</span>");
	$row.append("<span class='presc-no'>"+prescNo+"</span>");
	$prescInfo.append($row);
	
	for(var i=0;i<length;i++){
		var drugDesc = json[i].drugDesc;
		var drugCode = json[i].drugCode;
		var onceDose = json[i].onceDose; //���� ��λ
		var $cols = $("<div class='presc-drug' style='float:left;min-width:160px;width:30%'></div>");
		$prescInfo.append($cols);
		var spanHtml = "<span class='presc-text'>"+drugDesc+" "+onceDose+"</span><a href='javascript:void(0);' onclick='litratrue(this)' style='float:right;padding-right:5px;' value='"+drugDesc+"'";
		spanHtml = spanHtml + "data-code='"+drugCode+"' data-libId= '"+json[i].libDrugId+ "' data-libCode='"+json[i].libDrugCode+"' data-libDesc='"+json[i].libDrugDesc+ "'><img src='../scripts/dhcnewpro/dhcpresc/images/lit.png' style='height:18px'/></a>";
		if(((i+1)%3)==0){
			spanHtml=spanHtml+"<br>";
		}
		$cols.append(spanHtml);
	}
	
	var $dashline = $('<div class="dasline" style="clear:both"></div>');
	$prescInfo.append($dashline);
	
	var freq = json[0].freq;
	var treatment = json[0].treatment;
	var preMet = json[0].preMet;
	var PrescQty = json[0].PrescQty;
	var $usecols = $("<div class='presc-pre'></div>");
	$prescInfo.append($usecols);
	$usecols.append("<span>��"+treatment+"</span>");
	$usecols.append("<span class='presc-use'>�÷���</span>");
	$usecols.append("<span>"+ preMet + " " + freq +"</span>");
	$usecols.append("<span class='presc-use'>һ��������</span>");
	$usecols.append("<span>"+ PrescQty +"</span>");



	
}
///��������html
function AppendPrescHtml(json)
{
	
	var $prescInfo = $("#prescInfo");
	$prescInfo.empty();
	
	var length = json.length;
	var prescNo = json[0].prescNo;
	
	$row = $("<div class='presc-pre'></div>");
	$row.append("<span class='icon-paper-pen-blue' >&nbsp;&nbsp;&nbsp;&nbsp;</span>");
	$row.append("<span class='presc-col' >����</span>");
	$row.append("<span class='presc-no'>"+prescNo+"</span>");
	$prescInfo.append($row);
	
	for(var i=0;i<length;i++){
		var drugDesc = json[i].drugDesc;
		var drugCode = json[i].drugCode;
		var onceDose = json[i].onceDose;
		var preMet = json[i].preMet;
		var freq = json[i].freq;
		var treatment = json[i].treatment;
		var $cols = $("<div class='presc-drug'></div>");
		$prescInfo.append($cols);
		$cols.append("<span>"+(i+1)+"</span>");
		var spanHtml = "<span class='icon-drug'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span><span class='presc-text'>"+drugDesc+"</span><a  href='javascript:void(0);' onclick='litratrue(this)' style='float:right;padding-right:20px;' value='"+drugDesc+"'";
		spanHtml = spanHtml + "data-code='"+drugCode+"' data-libId= '"+json[i].libDrugId+ "' data-libCode='"+json[i].libDrugCode+"' data-libDesc='"+json[i].libDrugDesc+ "'><img src='../scripts/dhcnewpro/dhcpresc/images/lit.png' style='height:18px'/></a><br>";
	
		$cols.append(spanHtml);
	
		
		var $usecols = $("<div class='presc-pre'></div>");
		$prescInfo.append($usecols);
		$usecols.append("<span class='presc-use'>���μ�����</span>");
		$usecols.append("<span>"+ onceDose +"</span>");
		$usecols.append("<span class='presc-use'>��ҩ;����</span>");
		$usecols.append("<span>"+ preMet +"</span>");
		$usecols.append("<span class='presc-use'>Ƶ�Σ�</span>");
		$usecols.append("<span>"+ freq +"</span>");
		$usecols.append("<span class='presc-use'>�Ƴ̣�</span>");
		$usecols.append("<span>"+ treatment +"</span>");
		
		var $entrust = $("<div class='entrust'></div>");
		$prescInfo.append($entrust);
		var $contmore = $("<div class='contmore'></div>");
		$entrust.append($contmore);
		if(i<1){
			$contmore.append("<span></span>")

		}
		var $dashline = $('<div  id="dasline"></div>');
		if(i<length-1){
			$prescInfo.append($dashline);
		}
	}
}

///�����������
function LoadPrescPro(auditId){
	
	runClassMethod("web.DHCPRESCAudit","GetAuditInfo",{"auditId":auditId},
		function(jsonString){
			var json= eval('(' + jsonString + ')');
			AppendProbHtml(json);
	},'text');
}

///��������html
function AppendProbHtml(retJson)
{
	var $probInfo = $("#proInfo");
	$probInfo.empty();
	if ($.isEmptyObject(retJson)){
		return;	
	}
	var itemsArr = retJson.items;
	var arr = [];
	var keyArr = [];
	var manLevArr = [];
	//��ȡjson���ݣ���ȡһ�����
	for (var i = 0; i < itemsArr.length; i++){
		var warnsArr = itemsArr[i].warns;
		for (var j = 0; j < warnsArr.length; j++){
			var msgItmsArr = warnsArr[j].itms;
			for (var k = 0; k < msgItmsArr.length; k++){
				var valItemArr = msgItmsArr[k].itms;
				for (var x = 0; x < valItemArr.length; x++){
					var obj = {};
						obj.item = itemsArr[i].item;
						obj.manLev = warnsArr[j].manLev;
						obj.keyname = warnsArr[j].keyname;
						obj.val = valItemArr[x].val;
						arr.push(obj);
				}
			}
		}		
	}
	
	//������ʾ�ȼ���������࣬ȥ��
	for (var n = 0; n < arr.length; n++){
		keyArr.push(arr[n].keyname);
		keyArr = unique(keyArr);
	}
	for (var m = 0; m < keyArr.length; m++){
		//������Ƭ
		var $keyCard = $("<div style=\"background-color:#FFFCF7;margin:20px 10px 10px 10px;height:auto;border:1px dashed #ccc;padding:10px;position:relative\"></div>");
		$probInfo.append($keyCard);	
		var manLevArr = [];
		for (var p = 0; p < arr.length; p++){
			if (arr[p].keyname == keyArr[m]){
				manLevArr.push(arr[p].manLev);	
			}	
		}
		manLevArr = unique(manLevArr);
		for (var o = 0; o < manLevArr.length; o++){
			//��Ŀ���������ͼ��ͱ߿���ɫ
			var manLevIcon = (manLevArr[o] == "��ʾ") ? "tips.png" : (manLevArr[o] == "����" ? "remind.png" :(manLevArr[o] == "��ʾ" ? "warn.png" : (manLevArr[o] == "��ֹ" ? "forbid.png" : "")))
			var manLevcolor = (manLevArr[o] == "��ʾ") ? color[0] : (manLevArr[o] == "����" ? color[1] :(manLevArr[o] == "��ʾ" ? color[2] : (manLevArr[o] == "��ֹ" ? color[3] : "")))
			var $manLev = $("<div><img style=\"height:30px;position:absolute;left:-5px;top:-15px\" src = \""+ imgurl +""+manLevIcon+"\"/></div>");
			var $infoCard = $("<div style=\"margin-top:-20px;padding:5px;width:70%;\"></div>");
			$keyCard.append($manLev);
			$keyCard.append("<div style=\"width:25%;text-align:right;float:right;margin-top:15px;margin-right:30px;color:"+ manLevcolor +"\"><b>"+keyArr[m]+"</b></div>");
			$keyCard.append("<div style='clear:both;width:0px'></div>");	//�հ������ſ�����
			for (var r = 0; r < arr.length; r++){
				if (arr[r].keyname == keyArr[m]&&arr[r].manLev == manLevArr[o]){
					$infoCard.append("<span class='icon-drug'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>")
					$infoCard.append(arr[r].item+"<br/>");
					$infoCard.append("<div style=\"color:#676360;font-size:12px;margin-left:25px;\">"+arr[r].val+"<br/></div>");	
				}	
			}
			$keyCard.append($infoCard);
		}
	}
}

///��ʼ����˽���
function LoadAuditRes(auditId)
{
	runClassMethod("web.DHCPRESCAudit","GetAuditRes",{"auditId":auditId},
		function(ret){
			if(ret!=""){
				var itmId = ret.split("^")[0];
				
				var result = ret.split("^")[1];
				
				var audres = ret.split("^")[2];
				$("#inselitm").combobox("setValue",itmId);
				$("#remark").val(result);
				$("#audres").html(audres);
			}
			
	},'text');
}
///��ʼ��������
function initCombobox()
{
	var uniturl = $URL+"?ClassName=web.DHCPRESCCommonUtil&MethodName="  

	$HUI.combobox("#inselitm",{
		url:uniturl+"QueryDicItem&code=RIT&hospId="+LgHospID,
		valueField:'value',
		textField:'text',
		panelHeight:"200",
		mode:'remote',
		onSelect:function(ret){
			
		 }
	})	
}

///����TabsTitle
function updTabsTitle(index,newtitle)
{
	var  tab = $('#tt-keywords' ).tabs( 'getTab' ,index); 
	$( '#tt-keywords' ).tabs( 'update' , {
         tab: tab,
         options: {
            title:  newtitle
         }
	});
}

///��ʼ����ť
function initButton()
{
	$("#mody").bind('click',modify);    	//�����޸�
	//$("#signrev").bind('click',signrev);    //˫ǩ����
	$("#signpass").bind('click',signpass);  //˫ǩͨ��
	$("#pass").bind('click',auditpass);    	//ͨ��
	
	/// tabs ѡ�
	$("#tt-keywords").tabs({
		onSelect:function(title){
		   if (itemSelFlag == 1){
			  clearInfo()
			  patNumFlag="";
			  auditId = "";
		   	  LoadPrescList(title);
		   	  LoadPrescNo(auditId);			//���ش�����Ϣ
			  LoadPrescPro(auditId);		//�����������
			  LoadButtons();				//����ҳ�水ť
		   }
		}
	});
	
	/// tabs ѡ�
	$("#presc-keywords").tabs({
		onSelect:function(title){
		   if (title == "������Ϣ"){
				initLisDatagrid();
		   }else if(title == "�����Ϣ"){
			   initInsDatagrid();
		   }
		}
	});
	
	//$("#docname").bind('click',linkChat);    	//��������
	
	$("#away").bind('click',leademobil);		//�뿪
	
	$("#batch").bind('click',OpenBatchWin);		//�������
	
	$("#collection").bind('click',OpenCaseCollectionWin);			//�����ղ�
	
	$("#aa").bind('click',ChangeStyle);			//�����ղ�
	
	$("#admNo").bind('click',panoview);			//��תȫ����ͼ
	
}

///��ʼ���б�
function LoadPrescList(title)
{
	if (title.indexOf("������")>=0){ 
		stateFlag = "0";
		res = "";
	}else if (title.indexOf("��ȷ��")>=0){
		stateFlag = "1";
	}else if (title.indexOf("�����޸�")>=0){
		stateFlag = "2";
		res = "STA01";	
	}else if(title.indexOf("˫ǩͨ��")>=0){
		stateFlag = "2";
		res = "STA03";	
	}else if (title.indexOf("ͨ��")>=0){
		stateFlag = "2";
		res = "STA04";	
	}else{
		stateFlag = "2";
		res = "";	
	}
	var searchNo=$("#search").searchbox('getValue');  //xww 2022-03-03 �����ţ��ǼǺŻ�����

	var params = stdate + "^" + enddate + "^" + stateFlag + "^"+ LgUserID + "^" + res + "^" + searchNo + "^" + "" + "^" +MenuModule;
	$("#auditList").datagrid("load",{"params":params});
}

///�����޸�
function modify()
{
	var code = "STA01";
	saveAuditRes(code);
	
}

///˫ǩ����
function signrev()
{
	var code = "STA02";
	saveAuditRes(code);
	
}

///˫ǩͨ��
function signpass()
{
	var code = "STA03";
	saveAuditRes(code);
	
}

///ͨ��
function auditpass()
{
	var code = "STA04";
	saveAuditRes(code);
	
}

///������˽��
function saveAuditRes(stateCode)
{
	var rowData = $("#auditList").datagrid('getSelected');
	if(rowData==null){
		$.messager.alert("��ʾ","��ѡ���������ݣ�","info");
		return;
	}
	var itemId = $HUI.combobox("#inselitm").getValue();		//���¼����Ŀ
	var remark = $("#remark").val();						//��ע
	var readCode = 0;
	var listData = auditId +"^"+ itemId +"^"+ LgUserID +"^"+ stateCode +"^"+ readCode +"^"+ remark+"^"+LgCtLocID;
	runClassMethod(
		"web.DHCPRESCAudit",
		"saveAuditInfo",
		{
			"listData":listData
		},
		function(ret){
			if(ret==0){
				$.messager.alert('��ʾ',"����ɹ���","info");
				reloadAuditList();
				clearInfo();
				return;
			}else{
				$.messager.alert('��ʾ',"����ʧ�ܣ�"+ret,"error");
				return;
			}
		}
	,'text');
	$HUI.combobox("#inselitm").setValue("");
	$("#remark").val("");
	
}

///�����۵�����
function initContentfold()
{
	var slidHeight = 40;
	$(".contmore").each(function(){
         var curHeight = $(this).height();
         if(curHeight>slidHeight) {
              $(this).css("height",slidHeight); 
              $(this).after("<a class='toggle-btn' value="+curHeight+">չ��</a>");
         }
    });
    
    $(".toggle-btn").click(function(){
	    debugger;
	     var oldheight = $(this).attr("value");
	     var curHeight = $(this).parent().children(".contmore").height();
	     if(curHeight == slidHeight){
				$(this).parent().children(".contmore").animate({
					'height':oldheight
				},'normal')
				$(this).html('�۵�');
				$(this).css("background","url(../images/fa-angle-double-up_40a2de_12.png) no-repeat center");
		 }else{
				$(this).parent().children(".contmore").animate({
					'height':slidHeight
				},'normal')
				$(this).html('չ��');
				$(this).css("background","url(../images/fa-angle-double-down_40a2de_12.png) no-repeat center");
		 }
    });
}

///�������촰��
function linkChat()
{
	/*_openMassTalkPage(auditId);
	return;*/

	if ('undefined'!==typeof websys_getMWToken){
		var url = "dhcpresc.newscontact.csp?";
		url += "MWToken="+websys_getMWToken();
		url += "&userType=Audit&auditId="+auditId;
	}else{
		var url = "dhcpresc.newscontact.csp?";
		url += "userType=Audit&auditId="+auditId;
	}
	
	$("#newsContact").attr("src",url);
	
	if($("#newsWin").hasClass("panel-body")){
		$("#newsWin").window("open");
	}else{
		$("#newsWin").window({
			iconCls:'icon-w-save',
			resizable:true,
			modal:false,
			isTopZindex:true
		});
	}
}

///������˽���
function OpenBatchWin()
{
	var width = (document.documentElement.clientWidth-100);
	var height = (document.documentElement.clientHeight-100);

	var lnk = "dhcpresc.batchview.csp?MenuModule="+MenuModule;
	websys_showModal({
		url:lnk,
		title:'�������',
		iconCls:'icon-w-save',
		width:width,
		height:height,
		top:(document.documentElement.clientWidth-width)/2,
		left:(document.documentElement.clientHeight-height)/2,
		onClose: function() {
			
		}
	});
}

///�����ղؽ��� $('#aaa').validatebox({required:false});
function OpenCaseCollectionWin()
{
	if (auditId=="")
	{
		$.messager.alert("��ʾ","��ѡ�񴦷��ղط���","warning")
		return ;	
	}
	
	var width = (document.documentElement.clientWidth-100);
	var height = (document.documentElement.clientHeight-100);
	var lnk = "dhcpresc.casecollection.csp?AuditId="+auditId;
	websys_showModal({
		url:lnk,
		title:'�����ղط���',
		iconCls:'icon-w-save',
		width:width,
		height:height,
		top:(document.documentElement.clientWidth-width)/2,
		left:(document.documentElement.clientHeight-height)/2,
		onClose: function() {
			
		}
	});
}
///�����ղط���ͼ����ʽ�޸� lidong	
function ChangeStyle()
{	
	/* $('#collection').linkbutton({iconCls:'icon-star'}); */
	runClassMethod("web.DHCPrescCaseCollection","CheckCollect",{"AuditId":auditId},function(getString){
		if (getString == 'Y'){
			$('#collection').linkbutton({iconCls:'icon-star'});	
		}else if (getString == ''){
			$('#collection').linkbutton({iconCls:'icon-star-empty'});
			}
	},'text');
}
///����˵����
function litratrue(obj)
{
	var drugCode = $(obj).attr("data-code");
	var drugDesc = $(obj).attr("value");
	var libId = $(obj).attr("data-libid");
	if(isOwnSys==1){
		getDrugIns_click(drugCode,drugDesc);
	}else{
		
		if (libId!="0"){
			
			if ('undefined'!==typeof websys_getMWToken){
				var url = "dhcckb.pdss.instruction.csp?";
				url += "MWToken="+websys_getMWToken();
				url += "&IncId="+libId;
			}else{
				var url = "dhcckb.pdss.instruction.csp?";
				url += "IncId="+libId;
			}
			
		}else{
			
			if ('undefined'!==typeof websys_getMWToken){
				var url = "dhcckb.pdss.instruction.csp?";
				url += "MWToken="+websys_getMWToken();
				url += "&IncId=&IncCode="+drugCode+"&IncDesc="+encodeURI(drugDesc);
			}else{
				var url = "dhcckb.pdss.instruction.csp?";
				url += "IncId=&IncCode="+drugCode+"&IncDesc="+encodeURI(drugDesc);
			}
			
		}
		var width = (document.documentElement.clientWidth-100);
		var height = (document.documentElement.clientHeight-100);

		websys_showModal({
			url:url,
			title:'ҩƷ˵����',
			width:width,
			height:height,
			top:(document.documentElement.clientWidth-width)/2,
			left:(document.documentElement.clientHeight-height)/2,
			onClose: function() {
				
			}
		});
	}
}

///��������
function OpenEmrO()
{
	var admId = $("#admId").val();
	var patientId = $("#patientId").val();
	var url="dhcem.consultpatemr.csp?";
	if ('undefined'!==typeof websys_getMWToken){
		url += "&MWToken="+websys_getMWToken();
	}
	url += "&EpisodeID="+admId+"&PatientID="+patientId+"&targetName=Attitude"+"&TextValue="; //+obj.text;
	var result = window.open(url,"_blank",'dialogTop:50;dialogWidth:1250px;DialogHeight=600px;center=1'); 
	try{
		if (result){
			if ($("#remark").val() == ""){
				$("#remark").val(result.innertTexts);  		/// ��Ҫ����
			}else{
				$("#remark").val($("#remark").val()  +"\r\n"+ result.innertTexts);  		/// ��Ҫ����
			}
		}
	}catch(ex){}
}

///�뿪
function leademobil()
{
		$.messager.confirm("��ʾ", "ѡ���뿪�������������������", function (res) {//��ʾ�Ƿ�ɾ��
			if (res) {
				runClassMethod(
					"web.DHCPRESCAudit",
					"updScheState",
					{
						"userId":LgUserID,
						"state":"����",
					},
					function(ret){
						if(ret==1){
							$.messager.alert('��ʾ',"��δѡ����˿��ң�����������Դ����ҳ��ά����","warning");
							return;
						}else if(ret==0){
							initCompent();      //�����ɹ�ֱ���ж�����״̬��ʾ shy 2023-1-16
							//$.messager.alert('��ʾ',"�����ɹ���");
							return;
						}else{
							$.messager.alert('��ʾ',"����ʧ�ܣ�"+ret,"error");
							return;
						}
					}
				,'text');
			}
		});
}

///��ʼ���
function auditStart(){
		runClassMethod(
			"web.DHCPRESCAudit",
			"updScheState",
			{
				"userId":LgUserID,
				"state":"����",
			},
			function(ret){
				if(ret==1){
					$.messager.alert('��ʾ',"��δѡ����˿��ң�����������Դ����ҳ��ά����","warning");
					return;
				}else if(ret==0){
					$HUI.dialog('#onlinedialog').close();
					return;
				}else{
					$.messager.alert('��ʾ',"����ʧ�ܣ�"+ret,"error");
					return;
				}
			}
		,'text');
}
///Ӱ����ʾҳ������
function LoadButtons(){
	if(stateFlag == 0){
		$("#timelabel").show();
		$("#rematime").show();
		$("#QueEmr").show();
		$("#mody").show();
		$("#signpass").show();
		$("#pass").show();
		$("#audreslabel").hide();
		$("#audres").hide();
		
		
	}else{
		$("#timelabel").hide();
		$("#rematime").hide();
		$("#QueEmr").hide();
		$("#mody").hide();
		$("#signpass").hide();
		$("#pass").hide();
		$("#audreslabel").show();
		$("#audres").show();
	}
}

/*������Ϣ*/
/*��ѯ����*/
function initDateBox(){
	$HUI.datebox("#sel-stDate",{});
	$HUI.datebox("#sel-edDate",{});	
	$HUI.datebox("#sel-stDate").setValue(formatDate(0));
	$HUI.datebox("#sel-edDate").setValue(formatDate(0));
}

/*�����б�*/
function upLisDate(event,value){	
	if(value){
		switch ($(event.target).attr("id")){
			case "radio1":
				$HUI.datebox("#sel-stDate").setValue(formatDate(0));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio2":
				$HUI.datebox("#sel-stDate").setValue(formatDate(-30));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio3":
				$HUI.datebox("#sel-stDate").setValue(formatDate(-180));
				$HUI.datebox("#sel-edDate").setValue(formatDate(0));
				break;
			case "radio4":
				$HUI.datebox("#sel-stDate").setValue("");
				$HUI.datebox("#sel-edDate").setValue("");
				break;
		}
	}
}

/*���鱨��*/
function initLisDatagrid()
{
	///  ����columns
	var columns=[[
          { field: 'chkReportList', checkbox: true },
          { field: 'LabEpisode', title: '�����', width: 105, sortable: false, align: 'center' },
          { field: 'OrdItemName', title: 'ҽ������', width: 200, sortable: false, align: 'left' },
          { field: 'AuthDateTime', title: '��������', width: 150, sortable: false, align: 'center' },
          { field: 'PatName', title: '����', width: 80, sortable: false, align: 'center' },
          { field: 'Order', title: 'Ԥ����', width: 55, sortable: true, align: 'center'},
          { field: 'ResultStatus', title: '���״̬', width:100, sortable: false, align: 'center'},
		  { field: 'PrintFlag', title: '��ӡ', width: 40, sortable: false, align: 'left',
          	formatter: function (value, rowData, rowIndex) {
				if (rowData.ResultStatus != "3") return "";
				if(value=="Y"){
					return '<a href="#" title="��ӡ��¼"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-ok" title="�Ѵ�ӡ">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
				}else if(value=="N"){
					return '<a href="#" title="��ӡ��¼"  onclick="ShowPrintHistory(\''+rowData.VisitNumberReportDR+'\')"><span class="icon-undo" title="����δ��ӡ">&nbsp&nbsp&nbsp&nbsp&nbsp</span></a>';
				}
             }
          },
          { field: 'ReadFlag', title: '�Ķ�', width: 40, sortable: false, align: 'center',
          	formatter: function(value, rowData, rowIndex){
	          	if (rowData.ResultStatus != "3") return "";
	        	if (value == "1") {
		        	return "<span class='icon-book_open' color='red' title='���Ķ�')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}else {
		        	return "<span class='icon-book_go' color='red' title='δ�Ķ�')>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>";
	        	}  	
	        } 
          },
          { field: 'WarnComm', title: 'Σ����ʾ', width: 150, sortable: false, align: 'left'},
          { field: 'ReceiveNotes', title: '�걾��ע', width: 150, sortable: false, align: 'left' },
          { field: 'MajorConclusion', title: '��������', width: 150, sortable: false, align: 'left' },
          { field: 'ReqDateTime', title: '��������', width: 150, sortable: false, align: 'center' },
          { field: 'SpecDateTime', title: '�ɼ�����', width: 150, sortable: false, align: 'center' },
          { field: 'RecDateTime', title: '��������', width: 150, sortable: false, align: 'center' },
          { field: 'VisitNumberReportDR', title: '����ID', width: 100, sortable: false, align: 'center' },
        ]]
	
	///  ����datagrid
	var option = {
		//showHeader:false,
		toolbar:[],
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	        
			reloadOrdDetailTable(rowData.VisitNumberReportDR);
	    },
		onLoadSuccess:function(data){
			
		}
	};
	
	var params = admId +"^"+ patientId +"^"+ "" +"^"+ "" + "^^0^^^"+""+"^0^^^^Y"+"^"+""+"^"+""+"^"+""+"^"+"";
	var uniturl = $URL +"?ClassName=web.DHCPRESCQuery&MethodName=GetLisHisList&params="+params;
	
	new ListComponent('lisOrdTable', columns, uniturl, option).Init();
	
	var columns=[[
    	{ field: 'Synonym',align: 'center', title: '��д',width:45},
        { field: 'TestCodeName',align: 'center', title: '��Ŀ����',width:60},
        { field: 'Result',align: 'center', title: '���',width:45},
		{ field: 'ExtraRes',align: 'center', title: '�����ʾ'},
		{ field: 'AbFlag',align: 'center', title: '�쳣��ʾ',width:45},
		{ field: 'HelpDisInfo',align: 'center', title: '�������',width:65},
		{ field: 'Units',align: 'center', title: '��λ'},
		{ field: 'RefRanges',align: 'center', title: '�ο���Χ',width:49},
		{ field: 'PreResult',align: 'center', title: '����',width:35}, 
		{ field: 'PreAbFlag', align: 'center',title: 'ǰ���쳣��ʾ',hidden: true}
 	]];
 	
 	///  ����datagrid
	var option = {
		//showHeader:false,
		toolbar:[],
		rownumbers : false,
		singleSelect : true,
        onClickRow:function(rowIndex, rowData){
	    },
		onLoadSuccess:function(data){
			
		}
	};
	
	var uniturl = $URL +"?ClassName=web.DHCPRESCQuery&MethodName=GetLisDetList&reportId=";
	new ListComponent('lisOrdDetailTable', columns, uniturl, option).Init();
}

///��ʼ������б�
function initInsDatagrid()
{
	var Params=""
	var stDate = "";
	var edDate = "";
	Params= admId +"^"+ patientId +"^"+ stDate +"^"+ edDate +"^"+ LgUserID+"^"+""+"^"+""+"^"+""+"^"+"";  //##
	ReqNo = "",OEORIID="";
	var columns=[[
		{ field: 'lx',align: 'center', title: '����',formatter:formatterlx},
    	{ field: 'AdmLoc',align: 'center', title: '�������'},
    	{ field: 'ReqNo',align: 'center', title: '���뵥��'},
    	{ field: 'StudyNo',align: 'center', title: '����'},
    	{ field: 'strOrderName',align: 'center', title: '�������'},
    	{ field: 'strOrderDate',align: 'center', title: '��������'},
    	{ field: 'ItemStatus',align: 'center', title: '���״̬'},
    	{ field: 'recLocName',align: 'center', title: '������'},
    	{ field: 'IsCVR',align: 'center', title: 'Σ��ֵ����'},
    	{ field: 'IsIll',align: 'center', title: '�Ƿ�����',
    		formatter:function(value,row,index){ //hxy 2018-10-30
				if (value=='Y'){return '��';} 
				else {return '��';}
			}}, 
    	{ field: 'IshasImg',align: 'center', title: '�Ƿ���ͼ��',
    		formatter:function(value,row,index){ //hxy 2018-10-30
				if (value=='Y'){return '��';} 
				else {return '��';}
    		}
    	},
    	{ field: 'Grade',align: 'center', title: '����',hidden:true},
    	{ field: 'OEORIId',align: 'center', title: 'ҽ��ID'},
    	{ field: 'PortUrl',align: 'center', title: 'PortUrl',hidden:'true'}
 
 	]]; 

 	$HUI.datagrid('#inspectDetail',{
		url:$URL+"?ClassName=web.DHCPRESCQuery&MethodName=GetInspectOrd&Params="+Params,
		fit:true,
		rownumbers:true,
		columns:columns,
		fitColumns:false,
		pageSize:10,  
		pageList:[10,15,20], 
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		border:false,//hxy 2018-10-22
		rowStyler: function(index,row){
			
		},
		onLoadSuccess:function(data){
			if((data.rows.length=="1")&&(ReqNo!="")){
				
			}
		}
	});	
}
/*���ô�ӡ���*/
function ShowPrintHistory()
{
	
}

/// ����ȥ�ط���
function unique(arr) {
    if (!Array.isArray(arr)) {
        console.log('type error!')
        return
    }
    var array = [];
    for (var i = 0; i < arr.length; i++) {
        if (array .indexOf(arr[i]) === -1) {
            array .push(arr[i])
        }
    }
    return array;
}

///���ؼ����б�
function reaLoadLis()
{
	var params = admId +"^"+ patientId+"^"+ "" +"^"+ "";
	params = params + "^^0^^^"+""+"^0^^^^Y"+"^"+""+"^"+""+"^"+""+"^"+"";  //##
	$HUI.datagrid('#lisOrdTable').load({
		params:params
	})

}

function reloadOrdDetailTable(portId){
	
	$HUI.datagrid('#lisOrdDetailTable').load({
		reportId:portId
	})
}

function formatterlx(value,rowData){
	if(rowData.BLOrJC==0){
		return "���";
	}
	
	if(rowData.BLOrJC==1){
		return "����";
	}
}
//����������Ķ����
function setReadFlag(auditId)
{
	runClassMethod("web.DHCPRESCAudit","SetReadFlag",{"AuditId":auditId},
		function(jsonString){
		//���¼�ʱ ��ʱ�Զ�ͨ��
		//setTimeout("ReadOverTime()", OverTime*1000);   //18000��Ҫ��Ϊ����     �Ķ�18s��ʱ�Զ�ͨ��
	},'text',true);	
}
//shy �Ķ���ʱ�Զ�ͨ��
function ReadOverTime()
{
	runClassMethod("web.DHCPRESCAudit","OverPrescAuditStatus",{"auditId":auditId},
		function(jsonString){
		$.messager.popover({
				msg: '��˳�ʱ�Զ�ͨ����',
				timeout: 2000,
				type: 'alert'
			});
		reloadAuditList();
		$HUI.combobox("#inselitm").setValue("");
		$("#remark").val("��ʱ�Զ�ͨ��");
		//���ذ�ť
		$("#timelabel").hide();
		$("#rematime").hide();
		$("#QueEmr").hide();
		$("#mody").hide();
		$("#signpass").hide();
		$("#pass").hide();
		$("#audreslabel").hide();
		$("#audres").hide();
		
	},'text');	
}

///��ת��ȫ����ͼ
function panoview()
{
	var admId = $("#admId").val();
	var patientId = $("#patientId").val();
	var mradm = $("#mradm").val();
	if($('#winlode').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�
	$('body').append('<div id="winlode"></div>');
	$('#winlode').window({
		title:'��������б�',
		collapsible:true,
		border:false,
		closed:"true",
		width:document.body.offsetWidth-100,
		height:document.body.offsetHeight-100
	});
	if ('undefined'!==typeof websys_getMWToken){
		var link="websys.chartbook.hisui.csp?";
		link += "MWToken="+websys_getMWToken();
		link += "&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=&SwitchSysPat=N&ChartBookID=70&PatientID="+ patientId +"&EpisodeID="+ admId +"&mradm="+ mradm +"&WardID=";

	}else{
		var link="websys.chartbook.hisui.csp";
		link += "&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=&SwitchSysPat=N&ChartBookID=70&PatientID="+ patientId +"&EpisodeID="+ admId +"&mradm="+ mradm +"&WardID=";

	}
	

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+link+'"></iframe>';
	$('#winlode').html(iframe);
	$('#winlode').window('open'); 
}
function againFlushNumber(params)
{
	$cm({
			ClassName:"web.DHCPRESCAuditPopup",
			MethodName:"MainUnReadList",
			Params:params
		},function(data){
			var allMsgNum=data.AllMsgNum;
			$("#msgnum").html(allMsgNum);
		}
	)
}
function OpenEmr()
{	
	var admId = $("#admId").val();
	var patientId = $("#patientId").val();
	$HUI.dialog('#oeordWin').open();
	/**
	 * ����columns
	 */
	var columns=[[
		{field:'ID',title:'ID',width:100,hidden:true,align:'center'},
		{field:'ck',title:'����',checkbox:'true',width:80,align:'left'}, 
		{field:'Code',title:'ҽ������',width:250,align:'center'},
		{field:'Desc',title:'ҽ������',width:250,align:'center'}
	]];
	
	/**
	 * ����datagrid
	 */
	var option = {
		bordr:false,
		fit:true,
		fitColumns:true,
		//singleSelect:true,	
		nowrap: false,
		striped: true, 
		pagination:true,
		rownumbers:true,
		pageSize:30,
		pageList:[30,60,90]
	};
	var uniturl = $URL+"?ClassName=web.DHCPRESCQuery&MethodName=GetAdmOeordInfo&Adm="+admId;
	new ListComponent('oeordList', columns, uniturl, option).Init(); 
}
function DrawInfo()
{
	var selecItmStr=$("#oeordList").datagrid('getChecked');
	var resinfo = '';
	    for (var k = 0; k < selecItmStr.length; k++) {
	        if (resinfo != '')
	            resinfo += ',';
	        resinfo += selecItmStr[k].Desc;
	    }	
	    var remarkinfo = $("#remark").val()+""+resinfo;
	    $("#remark").val(remarkinfo)
	    $HUI.dialog('#oeordWin').close();
	    
}

///���ҳ����Ϣ
function clearInfo()
{
	$("#patName").html("");
	$("#sex").html("");
	$("#age").html("");
	$("#weight").html("");
	$("#patNo").html("");
	$("#admNo").html("");
	$("#loc").html("");
	$("#doc").html("");
	$("#diag").html("");
	$("#chndiag").html("");
	$("#audremark").html("");
	$("#locTelphone").html("");
	$("#docTelphone").html("");
	$("#rematime").html("");
	//$("#inselitm").combotree("setValue","");
	$("#remark").html("");
	$("#audres").html("");
	$("#docname").html("");
	$("#proInfo").html("");
	$("#prescInfo").html("");
	$("#msgnum").html("");
	
}

///��0���˵ǼǺ�
function GetWholePatNo(EmPatNo){

	///  �жϵǼǺ��Ƿ�Ϊ��
	var EmPatNo=$.trim(EmPatNo);
	if (EmPatNo == ""){
		return;
	}
	
	///  �ǼǺų���ֵ
	runClassMethod("web.DHCEMPatCheckLevCom","GetPatRegNoLen",{},function(jsonString){

		var patLen = jsonString;
		var plen = EmPatNo.length;
		if (EmPatNo.length > patLen){
			$.messager.alert('������ʾ',"�ǼǺ��������");
			return;
		}

		for (var i=1;i<=patLen-plen;i++){
			EmPatNo="0"+EmPatNo;  
		}
	},'',false)
	
	return EmPatNo;
}

function BindTips(diag,chndiag)
{
	var html='<div id="tip" style="border-radius:3px;display:none;border:1px solid #000;padding:10px;position:absolute;background-color:#000;color:#fff;"></div>'
	$('body').append(html);
	/// ����뿪
	$('#diag,#chndiag').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('#diag').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			/// tip ��ʾ��λ�ú������趨
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.6
			}).text(diag);    // .text()
		}
	})
	
	/// ����ƶ�
	$('#chndiag').on({
		'mousemove':function(){
			var tleft=(event.clientX + 20);
			/// tip ��ʾ��λ�ú������趨
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				'z-index' : 9999,
				opacity: 0.6
			}).text(chndiag);    // .text()
		}
	})
}
/// JQuery ��ʼ��ҳ��
$(function(){ initPageDefault(); })
