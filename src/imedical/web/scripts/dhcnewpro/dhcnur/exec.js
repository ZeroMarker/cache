var execHight=$(window.parent).height()-205;
var tabHeight=$(window.parent).height()-80;
var attachHight=0
var curIndex
var selectHtml;
var serverName=GetComputerName();
$(document).ready(function() {
	//����Ifram�ĸ߶�
	//var MyTabHeight = $(window.parent).height()-$('.content-tabs',parent.document).height()-$('.navbar-content',parent.document).height();
	//alert(MyTabHeight);

	$('#content-main',parent.document).css("height",tabHeight+"px")
	
	setPanel();
	
	//table������Ӧ 2017-02-09
	var rtime = new Date();
    var timeout = false;
    var delta = 66;
    $(window).resize(function(){
        rtime = new Date();
        if(timeout == false){
            timeout = true;
            setTimeout(resizeend, delta);
        }
    });
    function resizeend(){
        if(new Date() - rtime < delta){
            setTimeout(resizeend, delta);
        }else{
            timeout = false;
            $('#attachtable').dhccTableM("resetWidth");
        }
    }//hxy 2017-02-09
	
	if(parIsShowAttach==1){
		
		attachHight=execHight/2;
		execHight=execHight*1/2;
		$('#attachtable').dhccTable({
			//formatRecordsPerPage:function(pageNumber){return ''},
	    	//formatShowingRows:function(pageFrom, pageTo, totalRows){return ''},
		    height:attachHight,
	        url:'dhcapp.broker.csp?ClassName=web.DHCNurCom&MethodName=FindOrditemAttach&IsQuery=Y',
	        singleSelect:true,
	        columns:[
			{field: 'admDeptDesc',title: '�������'},
			{field: 'orcatDesc',title: 'ҽ������'},
			{field: 'arcimDesc',title: 'ҽ������'}, 
			{field: 'phOrdQtyUnit',title: '����'},
			{field: 'price',title: '����'},
			{field: 'totalAmount',title: '�ܼ�'},
			{field: 'ctcpDesc',title: '��ҽ����'},
			{field: 'reclocDesc',title: '���տ���'},
			{field: 'createDateTime',title: '��ҽ��ʱ��'},
			{field: 'sttDateTime',title: 'Ҫ��ִ��ʱ��'},
			{field: 'ordStatDesc',title: 'ҽ��״̬'},
			{field: 'phcduDesc1',title: '�Ƴ�'},
			{field: 'oeoriId',title: 'oeoriId'},
			{field: 'disposeStatCode',title: 'disposeStatCode'}
			]
	    });
	}
	
	/*window.onresize=resizeBannerImage;
	function resizeBannerImage(){
	$('#attachtable').dhccQuery({query:{regNo:$("#RegNo").val()+"^"+$("#EpisodeID").val(),userId:LgUserID,startDate:window.parent.exeStDate,endDate:window.parent.exeEdDate,admType:"OE",DetailFlag:"on",ordId:execordId}})
	} //huaxiaoying 2016-12-29 */
	
	//hxy add 2016-09-20 atart
	$("#topshow").on('click',function(){	
		window.parent.showTop(); 	//$("#showTop").show();	
	});	
	//hxy add 2016-09-20 end
	$("#queryTypeGrp > button").click(function(){	
  		$("#queryTypeGrp button").removeClass("htm-tab");  //hxy 2016-11-29 htm-tab(�ĸ�)
  		$(this).addClass("htm-tab");
  		$("#QueryTypeCode").val($(this).attr("id"));
  		search();
	});
	$("#QueryTypeCode").val($("#queryTypeGrp > .htm-tab").attr("id"));
	$("#switch").on('click',function(){
		if(!$("#c2").is(':visible')){
			$("#execTable").parents(".bootstrap-table").hide();
			$("#attachtable").parents(".bootstrap-table").hide();
			$("#c2").show();
		}else{
			$("#execTable").parents(".bootstrap-table").show();
			$("#attachtable").parents(".bootstrap-table").show();
			$("#c2").hide();
		}
	})
	
	$("#message").on('click',showCardColorHint);
		/*
	$('#execTable').on('click-row.bs.table', function (e, row, $element) {
		OnSelect($element.attr("data-index"),row);
	});

	$('#execTable').on('check.bs.table', function ( row, $element) {
		alert(33);
	});
	$('#execTable').on('uncheck.bs.table', function (row, $element) {
		
	});
	*/
    $('#daterange').dhccDateRange({
    	"startDate": window.parent.exeStDate,
    	"endDate": window.parent.exeEdDate
		}, function(start, end, label) {
			data=serverCall("web.DHCEMCommonUtil","DateFormat",{})  //hxy 2017-03-08 ���ڸ�ʽ������	
			if(data==3){
				window.parent.exeStDate=start.format('YYYY-MM-DD')
				window.parent.exeEdDate=end.format('YYYY-MM-DD') 
		    }else if(data==4){
			    window.parent.exeStDate=start.format('DD/MM/YYYY')
				window.parent.exeEdDate=end.format('DD/MM/YYYY')	
			}
				
			//window.parent.exeStDate=start.format('YYYY-MM-DD') //hxy 
			//window.parent.exeEdDate=end.format('YYYY-MM-DD') //hxy
	});	
	$("#queryBtn").on('click',function(){	
		search();
	})
	
	$("#exePrnBtn").on('click',function(){
		exeAction("F","Y");
	})
	$("#exeBtn").on('click',function(){
		exeAction("F");
	})
	$("#prnBtn").on('click',function(){
		prnAction();
	})
	$("#undoBtn").on('click',function(){
		exeAction("C");
	})
	$("#skinBtn").on('click',function(){
		skinTest();
	})
	$("#readCardNo").on('click',function(){
		readCardNo();
	})
	$("#treatQue").on('click',function(){
		treatQue();
	})

	search();

	$('#RegNo').on('keypress', function(e){   
		// �����س�����   
		e=e||event;
		if(e.keyCode=="13"){
			$('#cardNo').val("");
			 
			if($('#RegNo').val()==""){
				alert("�ǼǺ�Ϊ��");    
				return;
			}
			var regNo = $('#RegNo').val(); 
			var m_lenght = ""
			runClassMethod("web.DHCCLCom","GetPatConfig",{},
				function(data){
					m_lenght=data.split("^")[0];
					},"text",false
			) 
			///�ǼǺŲ�0
			for (i=regNo.length;i<m_lenght;i++){
				regNo = "0"+regNo;
			}	
			$('#RegNo').val(regNo);
			searchByRegNo(regNo);	
		}
	});
	
	
	
	$('#cardNo').on('keypress', function(e){   
		// �����س�����   
		e=e||event;
		if(e.keyCode=="13"){
			$('#RegNo').val("");
			if($('#cardNo').val()==""){
		 		alert("����Ϊ��");    
		 		return;
		 	}
			var CardNo = $('#cardNo').val(); 
			var m_lenght = $("#EmCardType").val().split("^")[17]
			for (i=CardNo.length;i<m_lenght;i++){
				CardNo = "0"+CardNo;
			}
			$('#cardNo').val(CardNo);
			runClassMethod("web.DHCEMPatCheckLevCom","GetPmiNoFrCardNo",{"cardno":CardNo},function(jsonString){
				if (jsonString ==-1){
					$.messager.alert("��ʾ:","��ǰ����Ч,�����ԣ�");
					return;
				}else{
					EmPatNo = jsonString;
					$("#RegNo").val(EmPatNo);
					searchByRegNo(EmPatNo)
				}
			},'text',false)
		}
	});
		
		initCardCombo();
		
	    loadClient();
	    //$('#cardNo').focus();   //ȡ�����Ź��λ��
});

function searchByRegNo(regNo){

	runClassMethod("web.DHCEMPatientSeat","GetCurrAdm",
	{'CardNo':'','RegNo':regNo},
	    function(data){
		    if(data.split("^").length=="1"){
			   dhccBox.alert("����û�м��������Ϣ","shxy");
			    $('#RegNo').val("");
			}else{
				 if(data.split("^")[0]==""){
					dhccBox.alert("����û�м��������Ϣ","shxy");
					$('#RegNo').val("");
				 }else{
					var EpisodeID =data.split("^")[0];
					$("#EpisodeID",parent.document).val(data.split("^")[0]);
					$("#EpisodeID").val(data.split("^")[0]);
					selectTest(EpisodeID);
				}
			}	
	},"text",false);
}
	

function opFormatter(value, rowData){
	
		if(rowData.skinTestFlag=="Y"){
			if(rowData.disposeStatCode=="UnPaid"){
				return "<button disabled='true' class='btn btn-xs btn-warning btn-labeled fa fa-stethoscope' type='button'  onclick='skinTest(this);' data-oeoreId='"+rowData.oeoreId+"' data-adm='"+rowData.adm+"' data-Regno='"+rowData.regNo+"' data-allergyflag='"+rowData.Allgryflag+"'>Ƥ��</button>" //2016-10-26 congyue
			}else{
				return "<button class='btn btn-xs btn-warning btn-labeled fa fa-stethoscope' type='button'  onclick='skinTest(this);' data-oeoreId='"+rowData.oeoreId+"' data-adm='"+rowData.adm+"' data-Regno='"+rowData.regNo+"' data-allergyflag='"+rowData.Allgryflag+"'>Ƥ��</button>" //2016-10-26 congyue	
			}
		}else{
			return "";	
		}
}
function placerNoFormatter(value, rowData){
	    if((value==undefined)||(value=="")){
		   		return "<input name='placerNo' style='background:#fff;color: #333' onkeydown='setPlacerNo(this);' data-labNo='"+rowData.labNo+"' data-oeoreId='"+rowData.oeoreId+"'></input>"
		}else{
				return value;	
		}
}
function arcimDescFormatter(value,rowData){
	
	
	var returnStr="";
	returnStr = "<b class='ordertitle' style='background-color:"+rowData.tubeColor;
	
	if(true){   ///����ж�˭����������ɫ��ǳ������ѡ�к��ɫ�Ƿ����ı�  ggm 2017-08-29 ������ɫ�޸�
		returnStr=returnStr+" !important'>";
	}
	
	
	returnStr=returnStr+"<span style='color:"
	
	if(rowData.tubeColor=="#000000"){   ///����ж�˭����������ɫ��ǳ�������������ɫ
		returnStr=returnStr+"#FFF";
	}else if(rowData.tubeColor=="#8e7cc3"){   ///����ж�˭����������ɫ��ǳ�������������ɫ
		returnStr=returnStr+"#FFF";
	}else if(rowData.tubeColor=="#0000ff"){   ///����ж�˭����������ɫ��ǳ�������������ɫ
		returnStr=returnStr+"#FFF";
	}else{
		returnStr=returnStr+"#000";
	}
	
	returnStr=returnStr+" !important'>"+value+"</span></b>"
	return returnStr ;
}
function arcimDescCellStyle(value, row, index, field){
	return {css: {"background-color":row.tubeColor}}
}
function prtFlagCellStyle(value, row, index, field){
	opt={};
	if(row.prtFlag=="P"){
		opt={classes: 'bg-warning'}	
	}
	return opt;
	
}
//����״̬��ʽ hxy 2016-12-01
function disposeStatDescCellStyle(value, row, index, field){
	//alert(td-needdo-order)
	opt={};
	if(row.disposeStatDesc=="�账������"){
		opt={classes: 'td-needdo-order'}	
	}
	if(row.disposeStatDesc=="�Ѵ���"){
		opt={classes: 'td-did-order'}	
	}
	if(row.disposeStatDesc=="δ�շ�"){
		opt={classes: 'td-nopay-order'}	
	}
	if(row.disposeStatDesc=="Ƥ��"){
		opt={classes: 'bg-danger'}	
	}
	return opt;
	
}
function skinTest(obj){
	
	option={
		title:'Ƥ��',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['950px','100%'],
  		content: 'dhcem.skinTest.csp?adm='+$(obj).attr("data-adm")+"&oeoreId="+$(obj).attr("data-oeoreId")+"&RegNo="+$(obj).attr("data-Regno")+"&Allgryflag="+Allgryflag    //iframe��url 2016-10-26 congyue  ' data-Allgryflag='"+Allgryflag+"
	}
	window.parent.layer.open(option);
	
		
}
function nurAddOrder(obj){ //2017-02-06 hxy  2017-03-16 QQA  ��Ϊ�������� 
	var rowsData = $("#execTable").dhccTableM("getSelections")	
	var Moeori="",adm="";
	if($("#c2").is(':visible')){	
		$('input[name="IfPrint"]:checked').each(function(){
			adm=serverCall("web.DHCEMOrdInfoVO","getAdm",{ord:$(this).attr('data-oeoreid')}) 
			return  false;
		})
	}		

	if(rowsData.length>0){
		Moeori = rowsData[0].oeoriId;
		adm=rowsData[0].adm;
	}
	if(adm==""){
		window.parent.dhccBox.message({message : '��ѡ��ҽ��',type: 'danger',})
		return;
	} 
	var TabType = $('#QueryTypeCode').val()
	var url = 'dhcem.nuraddorder.csp?EpisodeID='+adm+"&Moeori="+Moeori+"&TabType="+TabType;
	var openCss = 'width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+ ', top=0, left=0, location=no,toolbar=no, menubar=no, scrollbars=no, resizable=no,status=no'
	window.open(url,'newwindow',openCss) 
}

function Cardpay(obj){ //2017-02-06 hxy  2017-03-16 QQA  ��Ϊ�������� 
	var rowsData = $("#execTable").dhccTableM("getSelections")	
	var adm="";
	if($("#c2").is(':visible')){	
		$('input[name="IfPrint"]:checked').each(function(){
			adm=serverCall("web.DHCEMOrdInfoVO","getAdm",{ord:$(this).attr('data-oeoreid')}) 
			return  false;
		})
	}		

	if(rowsData.length>0){
		adm=rowsData[0].adm;
	}
	
	if(EpisodeID!=""){
		adm = EpisodeID;
	}
	if(adm==""){
		window.parent.dhccBox.message({message : '��ѡ��ҽ��',type: 'danger',})
		return;
	} 

	var patInfo = serverCall("web.DHCEMInComUseMethod","GetPatInfo",{EpisodeID:adm}) 
	
	var features = 'dialogWidth:'  + 1400  + 'px;' + 'dialogHeight:' + 700 + 'px;' + 'dialogLeft:'+ 10 + 'px;';
  	features += 'dialogTop:' + 10 + 'px;' +  'scrollbars:no' + 'resizeable=no';
    var lnk = "udhcopbillforadmif.csp?CardNo=" + patInfo.split("^")[1] + "&SelectAdmRowId=" + adm + "&SelectPatRowId=" + patInfo.split("^")[2];
 	window.showModalDialog(lnk, window, features);	
}

function arrangeSeat(){
	option={
		title:' ',
  		type: 2,
  		shadeClose: true,
  		shade: 0.8,
  		area: ['1350px','100%'],
  		content: 'dhcem.patientseat.csp'    
	}
	window.parent.layer.open(option);
}
function search(){	
		runClassMethod("web.DHCEMColumn","getColumn",
				{
					HospitalRowId:$("#hospId").val(),
					queryTypeCode:$("#QueryTypeCode").val()
					
				},function(ret){
					 $("#c2").css("height",window.parent.tabHeight-130);   //QQA ���ÿ�Ƭ����߶�
					 $('#execTable').dhccTableM('destroy')
			  		 //admType="OE";
			  		 //alert(JSON.stringify($('#execTable').dhccTableM('getOptions')))
			  		 //dhccBox.alert(JSON.stringify($('#execTable').dhccTableM('getOptions')))
					 //$('#execTable').dhccTableM('getOptions').columns=ret;
					 //alert(JSON.stringify(ret))
					 $('#execTable').dhccTable({
						height:execHight,
						pageSize:200,
						pageList:[50,100,200],
						clickToSelect:true,
					    url:'dhcapp.broker.csp?ClassName=web.DHCEMNurExe&MethodName=getExeOrders',
						columns:ret,
						queryParam:{
							RegNo: $("#RegNo").val(),    
				    		QueryType: $("#QueryTypeCode").val(),
				    		HospId:$("#hospId").val(),
				    		Exec:$("#exeRadio:checked").val()=="on"?true:false,
				    		UnExec:$("#exeRadio:checked").val()=="on"?false:true,
				    		StartDate:window.parent.exeStDate,
				    		EndDate:window.parent.exeEdDate
						},
						rowStyle:function(row, index){
							opt={classes:"text-nowrap"};
							if(row.disposeStatDesc=="Ƥ��"){
							//if(row.disposeStatDesc=="�账������"){
								//alert(row.disposeStatDesc)
								$.extend({},opt,{classes: 'color-red'})
							}
							if(row.disposeStatCode=='Immediate'){
								$.extend({},opt,{classes: 'bg-success'})
				    		}
							return opt
						},
						onLoadSuccess:function(data){
							$("#execTable").parent().css("overflow-y","scroll");
							if(!$("#execTable").parent().prev().hasClass("rightHeader")){
								$("#execTable").parent().prev().addClass("rightHeader");
							}
							$("#queryTypeGrp .label-success").each(function(){ //hxy 2016-11-29
				    			$(this).remove()	
				    		})
							$(data.info).each(function(index,item){ 
								$("#"+item.shet).append("<span class='label label-success pull-right'>"+item.num+"</span>")
							})
							if($("button:contains('��Һ��')").hasClass("htm-tab")){
								
								var rows = $("#execTable").dhccTableM('getData');
								$("#c2").empty();
								obj.initpage(rows,4);
								$("#switch")[0].style.display="block";
								$("#message")[0].style.display="block";
								$("#execTable").parents(".bootstrap-table").hide();
								$("#attachtable").parents(".bootstrap-table").hide();    //��Ƭ����Ĭ�ϲ���ʾ
								$("#c2").show();
							}else{
								$("#c2").empty();
								$("#execTable").parents(".bootstrap-table").show();
								$("#attachtable").parents(".bootstrap-table").show();	 //������Һ����ʾ
								$("#c2").hide();
								$("#switch")[0].style.display="none";
								$("#message")[0].style.display="none";
							}
							showBTN();
						},
						onClickRow:function(row, $element, field){
			                //execordId=row.oeoreId //hxy 2016-12-29 2017-02-09ע��
							try{
								$('.J_menuTab',parent.document).each(function(){
									$(this).attr("data-episodeid",row.adm);
								})
								var frm=window.parent.parent.document.forms["fEPRMENU"];	
								if(frm.EpisodeID){
									frm.EpisodeID.value=row.adm
								}
							}catch(e){
								//alert(e.message)
							}
			                exeStDate=serverCall("web.DHCEMCommonUtil","DateHtmlToLogical",{date:window.parent.exeStDate})
			                exeEdDate=serverCall("web.DHCEMCommonUtil","DateHtmlToLogical",{date:window.parent.exeEdDate})
						    $('#attachtable').dhccQuery({query:{regNo:$("#RegNo").val(),userId:LgUserID,startDate:exeStDate,endDate:exeEdDate,admType:"OE",DetailFlag:"on",ordId:row.oeoreId,queryTypeCode: $("#QueryTypeCode").val()}})
						},
						onCheck:function(row, $element){
								try{
									$('.J_menuTab',parent.document).each(function(){
										$(this).attr("data-episodeid",row.adm);
									})
									var frm=window.parent.parent.document.forms["fEPRMENU"];	
									if(frm.EpisodeID){
										frm.EpisodeID.value=row.adm
									}
								}catch(e){
									//alert(e.message)
								}
								curIndex=$element.attr("data-index");
								CheckLinkOrd(curIndex, row,0);

						},
						onUncheck:function(row, $element){
								curIndex=$element.attr("data-index");
								CheckLinkOrd(curIndex, row,1);
						}
					});	 
		 })
}
//ִ�У�����ҽ��
function exeAction(exeflag,prtflag){
	
	//ƿǩ�л�ǰ lvpeng 170306
	var oeoreIdStr="";
	if(!$("#c2").is(':visible')){
		data=$("#execTable").dhccTableM("getSelections");
		ids=[];
		for(var i=0;i<data.length;i++){
			ids.push(data[i].oeoreId)
		}
		
		if(ids.length==0){
			parent.dhccBox.message({
				type: 'danger',
			    message : '��ѡ��ҽ��!'
			})
			return;
		}
		oeoreIdStr = ids.join("^");		
	}else{//�л�֮�� 	
		if($('input[name="IfPrint"]:checked').length==0){
			parent.dhccBox.message({
				type: 'danger',
			    message : '��ѡ��ҽ��!'
			})
			return;
		}
		
		$('input[name="IfPrint"]:checked').each(function(){
			if(oeoreIdStr.length==0){
				oeoreIdStr=$(this).attr('data-oeoreid');
			}else{
				oeoreIdStr=oeoreIdStr+"^"+$(this).attr('data-oeoreid');
			}	
		})
	}	
			
	runClassMethod("web.DHCEMNurExe","UpdateOrdGroup",
		{
			HospitalRowId:LgHospID,
			queryTypeCode:$("#QueryTypeCode").val(),
			execStatusCode:exeflag,
			oeoreIdStr:oeoreIdStr,
			userId:LgUserID,
			userDeptId:LgCtLocID
		},function(ret){
			if(ret==0){
				parent.dhccBox.message({
					 message : '�����ɹ�!'
				})
				
				//��Ҫ��ӡ��ʱ����ô�ӡ����
				if(prtflag=="Y"){
					PrintClick();				
				}
				
				loadFrame();   //ˢ��table
			}else{
				retStr=ret.split("!"); //huaxiaoying 2017-01-18
				window.parent.dhccBox.alert(retStr[0]+"!");	 //ret hxy 2017-01-18
			}
	},"text",false);   
	//����ֻ�������ó�false����ִ�в���ӡ��ʱ����������
}

//����ҽ��ѡ��
function OnSelect(rowIndex, rowData){
	var check=0;
	//alert(rowData.oeoreId+"!!!"+rowData.seqNo)
	$.each($("#execTable").dhccTableM("getSelections"),function(i,n){
    	if(rowData.oeoreId==n.oeoreId){
	    	check=1;
	    }
	})
	CheckLinkOrd(rowIndex, rowData,check)
}
function CheckLinkOrd(rowIndex, rowData,check){
	//alert(rowData.placerNo)
	//alert(rowData.placerNo==undefined)
	//alert(curIndex)
	
	var rows = $("#execTable").dhccTableM('getData');
	for(var i=0;i<rows.length;i++)
	{
		if(i==rowIndex){
			continue;
		}
		if((rowData.mainOeoreId==rows[i].mainOeoreId)||((rowData.labNo==rows[i].labNo)&&(rowData.labNo!=undefined)&&(rowData.labNo!=""))){
			selects= $("#execTable").dhccTableM('getSelections');
			selectFlag=0;
			for(j=0;j<selects.length;j++){
				if(selects[j].oeoreId==rows[i].oeoreId){selectFlag=1}
			}
			if(check==1){
				if(selectFlag==1){
					$("#execTable").dhccTableM('uncheck',i);  //qx
				}
			}else{
				if(selectFlag==0){
					$("#execTable").dhccTableM('check',i);
				}
			}
		}
	}
}

function initCardCombo(){
	//var defCarType = MyRunClassMethod("web.DHCEMPatCheckLevCom","GetDefaultCardType",{});
		//alert(defCarType);
		runClassMethod("web.DHCEMPatCheckLevCom","CardTypeDefineListBroker",{},
		function (data){
			var carArr=[]; //�����ҵ�
			var objDefult  = new Object();
			for (var i=0;i<data.length;i++){
				var obj = new Object();
				if(data[i].value.split("^")[8]=="N"){
					obj.id=data[i].value;
					obj.text=data[i].text;
					carArr.push(obj);
				}else if(data[i].value.split("^")[8]=="Y"){
					objDefult.id=data[i].value;
					objDefult.text=data[i].text;
					CarTypeSetting(objDefult.id);
				}
			}
			carArr.unshift(objDefult);
	
			$("#EmCardType").dhccSelect({
	   			data:carArr,
	   			minimumResultsForSearch:-1
			});
			$('#EmCardType').on('select2:select', function (evt) {
	  			CarTypeSetting(this.value);
			});
		});
}

function CarTypeSetting(value){
	//alert("ִ��");
	m_SelectCardTypeDR = value.split("^")[0];
	var CardTypeDefArr = value.split("^");
    m_CardNoLength = CardTypeDefArr[17];

    if (CardTypeDefArr[16] == "Handle"){
    	$('#cardNo').attr("readOnly",false);
    }else{
		$('#cardNo').attr("readOnly",true);
	}
	$('#cardNo').val("");  /// �������
	$('#regNo').val("");  /// �������
}	

//����
function readCardNo(){
	var myEquipDR = $('#EmCardType').val();
	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myEquipDR);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
		case "0":
			//����Ч
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$('#cardNo').val(CardNo);
			$('#RegNo').val(PatientNo);
			searchByRegNo(PatientNo);
			break;
		case "-200":
			//����Ч
			dhccBox.alert("����Ч!","patient-one");
			break;
		case "-201":
			//�ֽ�
			var PatientID = myary[4];
			var PatientNo = myary[5];
			var CardNo = myary[1];
			var NewCardTypeRowId = myary[8];
			$('#cardNo').val(CardNo);     /// ����
			$('#RegNo').val(PatientNo);   /// �ǼǺ�
			searchByRegNo(PatientNo);
			break;
		default:
	}
}

function selectTest(EpisodeID){
		runClassMethod("web.DHCEMPat",
			"GetPatInfo",
			{'EpisodeID':EpisodeID},
			function(data){
				parent.setPatInfo(data);
				parent.loadFrame(data);
			},
			"json")	
	
}

function loadFrame(){
	$('#execTable').dhccQuery({
		query:{
			RegNo: $("#RegNo").val(),    
    		QueryType: $("#QueryTypeCode").val(),
    		HospId:$("#hospId").val(),
    		Exec:$("#exeRadio:checked").val()=="on"?true:false,
    		UnExec:$("#exeRadio:checked").val()=="on"?false:true,
    		StartDate:window.parent.exeStDate,
    		EndDate:window.parent.exeEdDate
	     }
	})		
} 

function prnAction(){
	// �л�֮ǰ lvpeng 170301
	if(!$("#c2").is(':visible')){
		data=$("#execTable").dhccTableM("getSelections");
		if(data.length==0){
			parent.dhccBox.message({
				type: 'danger',
			    message : '��ѡ��ҽ��!'
			})
			return;
		}
		PrintClick();
	}else{ //�л�֮��
		if($('input[name="IfPrint"]:checked').length==0){
			parent.dhccBox.message({
				type: 'danger',
			    message : '��ѡ��ҽ��!'
			})
			return;
		}

		PrintClick();

	}
}
 function GetComputerName() {
 	var computerName;
 	try {
 		var WshNetwork = new ActiveXObject("WScript.Network");
 		computerName = WshNetwork.ComputerName;
 		WshNetwork = null;
 	} catch (e) {
 		computerName = "";
 	}
 	return computerName;
 }
function setPanel(){
	$("#treatQue").hide();
	runClassMethod("web.DHCEMOrdInfoVO",
			"checkTreate",
			{coputerName:serverName},
			function(ret){
				if(ret==1){
				
					$("#treatQue").show();
				}
			});
} 
function loadClient(){
	runClassMethod("web.DHCEMNurTreatQueue",
			"GetClientStr",
			{serverIP:serverName},
			function(ret){
				if(ret!=""){
					retArr=ret.split("^")
					html="<select style='width:100%;margin-top: 20px;height: 30px' id='Client'>",carArr=[]
					for(i=0;i<retArr.length;i++){
						itmArr=retArr[i].split(String.fromCharCode(1))
						var obj=new Object();
						obj.id=itmArr[0];
						obj.text=itmArr[1];
						carArr.push(obj);
						html=html+"<option value="+itmArr[0]+">"+itmArr[1]+"</option>"
					}
					selectHtml=html+"</select>";
					
				}
			},
			"text")	

}

function treatQue(){
	    
		layer.open({
			title:'�Ŷӿͻ���',
  			type: 1,
  			area: ['200px', '150px'],
  			content: selectHtml,
  			btn: ['�Ŷ�', '����']
  			,yes: function(index, layero){
   				QueBTN(2);
   				layer.close(index)
  			}
		});
}
function QueBTN(QueueType){
		//var parr = "RegNo|" + $("#RegNo").val()+"^TreatLocDr|" + LgCtLocID + "^TreatRecUser|" + LgUserID + "^TreatAdmDr|" + $("#EpisodeID").val() + "^TreatQueState|Wait^TreatQuePrior|2^TreatQueDate|^TreatQueTime|" + "^TreatQueueCat|" + $("#Client").val() + "^TreatReportType|" +  $("#QueryTypeCode").val();
 		runClassMethod("web.DHCNurTreatQueue",
			"InsertQueue",
			{QueueUserLocDr:LgCtLocID,
			 QueueUserId:LgUserID,
			 TreatAdmDr:$("#EpisodeID").val(),
			 ClientID:$("#Client").val(),
			 TreatReportType:$("#QueryTypeCode").val(),
			 RegNo:$("#RegNo").val(),
			 QueueType:QueueType,
			 ServerName:serverName},
			function(ret){
				if (ret != 0) {
					//window.parent.dhccBox.alert(ret);
				}else{
					window.parent.dhccBox.message({message : '�Ŷӳɹ�!'})
					window.parent.searchPatTreat();
						
				}
			},
			"text")	
}
function PrintQueueNo(TreatAdmDr, locId, ClientId) {
 	return;
 	var PrintInfo = tkMakeServerCall("web.DHCVISTreatQueue", "GetPrintInfo", TreatAdmDr, locId, ClientId);
 	var InfoList = PrintInfo.split("^")
 	if (InfoList.length > 4) {
 		QueueType = InfoList[0]
 		WaitRoom = InfoList[1]
 		QueueNo = InfoList[2]
 		PatName = InfoList[3]
 		WaitSum = InfoList[4]
 	} else {
 		alert("��ȡ��ӡ��Ϣ����!")
 		return;
 	}
 	var PrintObj = new ActiveXObject("DHCVBPrinter.clsPrinter");
 	PrintObj.FontSize = 20;
 	PrintObj.FontBold = true;
 	PrintObj.PrintContents(18, 0, "�Ŷ�ȡ��ϵͳ");
 	PrintObj.FontSize = 12;
 	PrintObj.FontBold = true;
 	PrintObj.PrintContents(0, 10, "��������:" + QueueType);
 	if (WaitRoom != "") {
 		PrintObj.PrintContents(0, 17, "�Ⱥ�����:" + WaitRoom);
 		PrintObj.PrintContents(0, 24, "��������:" + PatName);
 		PrintObj.PrintContents(40, 24, "�ŶӺ�:" + QueueNo + "��");
 		PrintObj.PrintContents(0, 31, "��ǰ�Ⱥ�����:" + WaitSum + "��")
 		PrintObj.FontSize = 10;
 		PrintObj.FontBold = false;
 		PrintObj.PrintContents(0, 40, "ȡ�ź��벻ҪԶ��,����������ȡ��!");
 	} else {
 		PrintObj.PrintContents(0, 17, "��������:" + PatName);
 		PrintObj.PrintContents(40, 17, "�ŶӺ�:" + QueueNo + "��");
 		PrintObj.PrintContents(0, 24, "��ǰ�Ⱥ�����:" + WaitSum + "��")
 		PrintObj.FontSize = 10;
 		PrintObj.FontBold = false;
 		PrintObj.PrintContents(0, 32, "ȡ�ź��벻ҪԶ��,����������ȡ��!");
 	}
 	PrintObj.EndDoc()
 	PrintObj = null;
 }
//
function setPlacerNo(obj){
	if (window.event.keyCode == 13) {
		$input = $("input[name='placerNo']");
		placerNo=$.trim($(obj).val());
		oeoreId=$(obj).attr("data-oeoreId");
		var nextIndex = $input.index(obj)+1;
		if (placerNo.length > 9) {
          	ret=serverCall("web.DHCNurCom", "SetPlacerNo", { userId:LgUserID, oeoreId:oeoreId, placerNo:placerNo})
            if(ret==0){
	            releLabNo($(obj));
	        }else{
		        window.parent.dhccBox.message({type: 'danger',message : "��"+nextIndex+'������'+ret})
		        $input[nextIndex-1].focus();
		    }
            
		}else{
			window.parent.dhccBox.message({type: 'warning',message : "��"+nextIndex+'�����벻��С��10λ!'})
			$(obj).focus();
			
		}	
	}	
	
}

function releLabNo($obj){
	$input = $("input[name='placerNo']");
	var nextIndex = $input.index($obj)+1;
	var labNo = $obj.attr("data-labNo");
	var nextLabNo =  $($input[nextIndex]).attr("data-labNo");
	if(labNo===nextLabNo){
		$($input[nextIndex]).val($obj.val());	
	}else{
		$input[nextIndex+1].focus();
		return;	
	}
	releLabNo($input[nextIndex]);
}

setInterval ("setTable()", 500);
function setTable()
{	
     try{
    $('#execTable').dhccTableM('resetWidth')
     }catch(e){}
   
}

function showBTN(){
	hiddenAll();
	typeCode=$("#QueryTypeCode").val();
	switch (typeCode)
	{
	case "MZQBYZ":
	  isShowPrtBedCard();
	  $("#nurAddOrder").show();
	  break;
	case "ZSDO":
	  $("#exePrnBtn").show();
	  $("#exeBtn").show();
	  $("#prnBtn").show();
	  $("#undoBtn").show();
	  isShowPrtBedCard();
	  $("#nurAddOrder").show();
	  break;
	case "SYDO":
	  $("#exePrnBtn").show();
	  $("#exeBtn").show();
	  $("#prnBtn").show();
	  $("#undoBtn").show();
	  $("#tpqBtn").show();
	  isShowPrtBedCard();
	  $("#nurAddOrder").show();
	  $("#switch").show();
	  $("#message").show();
	  break;
	case "PSDO":
	  $("#prnBtn").show();
	  $("#undoBtn").show();
	  isShowPrtBedCard();
	  $("#nurAddOrder").show();
	  break;
	case "JYDO":
	  showCommon();
	  break;
	case "BLDO":
	  showCommon();
	  break;
	case "ZLDO":
	  showCommon();
	  break;
	default:
	  $("#exeBtn").show();
	  $("#undoBtn").show();
	  $("#prnBtn").show();
	  $("#exePrnBtn").show();
	  $("#nurAddOrder").show();
	  break;
	}
}
function hiddenAll(){
	$("#exePrnBtn").hide();
	$("#exeBtn").hide();
	$("#prnBtn").hide();
	$("#undoBtn").hide();
	$("#tpqBtn").hide();
	$("#prtbedcard").hide();
	$("#nurAddOrder").hide();
	$("#switch").hide();
	$("#message").hide();
}
function showCommon(){
	$("#exePrnBtn").show();
	$("#exeBtn").show();
	$("#prnBtn").show();
	$("#undoBtn").show();
	$("#nurAddOrder").show();
	isShowPrtBedCard();
}

function isShowPrtBedCard(){
	//��Һ��ʿ����Ҫ��ͷ����ӡ
	if(!$("button[class='lang-selector dropdown-toggle btn btn-primary ']",parent.document).is(":hidden")){
		$('#prtbedcard').show();
	}	
}

///��ʾ��ɫ��ʾ
function showCardColorHint(){
	$("#botColorHintDiv",parent.document).show();
}