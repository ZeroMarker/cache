var PageLogicObj = {
	version:"V8.0",
    m_AddItemToListMethod: "LookUp",
    IsARCOSFormula:0, //�Ƿ���Э������
    m_ARCOSRowId:"",
    m_selTabIndex:"",
    //defaultDataCache:GlobalObj.defaultDataCache,
    EntrySelRowFlag:0,
    OEORIRealTimeQuery:1,
    LookupPanelIsShow:0,
    PractiacRowStr:"",
    PrescDurFactor:1,
    PreCMPrescTypeCode:"", //��һ��ѡ��Ĵ�������
    CurCMPrescTypeCode:"", //��ǰ��������
    SYSDateFormat:tkMakeServerCall("websys.Conversions","DateFormat"),
    MainSreenFlag:websys_getAppScreenIndex()				//˫����ʶ
}
if (PageLogicObj.SYSDateFormat=="4"){
    DATE_FORMAT= new RegExp("(((0[1-9]|[12][0-9]|3[01])/((0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)/(0[469]|11))|(0[1-9]|[1][0-9]|2[0-8])/(02))/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(29/02/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))");
}else if(PageLogicObj.SYSDateFormat=="3"){
	DATE_FORMAT= new RegExp("(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)");
}
var PreCMPrescTypeDataObj={};//��һ��ѡ��Ĵ������Ͷ�Ӧѡ�����ҩƵ�Ρ�ʹ�÷�ʽ����ҩ��������ҩ��ʽ������
var PrescTypeDetailDelim="!"
var FocusRowIndex=0;
var FocusGroupIndex=0;
var UpdateFlag=false;
var dw=$(window).width()-166,dh=$(window).height()-80;
function Init(){
	PageLogicObj.defaultDataCache=GlobalObj.defaultDataCache;
    InitTempFrame();
    InitEvent();		//�ŵ���ť����ʼ���ɹ��¼���
	InitPrescNotes();
	InitDateFlatpickr();
	InitCMOrdEntryDataGrid();
    ShowSecondeWin("onOPenCMPresc");
}
window.onbeforeunload=DocumentUnloadHandler;
$(window).load(function() {
	if (websys_isIE==true) {
	     var script = document.createElement('script');
	     script.type = 'text/javaScript';
	     script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
	     document.getElementsByTagName('head')[0].appendChild(script);
	}
	InitPatOrderViewGlobalCM(GlobalObj.EpisPatInfo);
	InitCombox();
	InitCMPrescType(GlobalObj.CMPrescTypeStrStr);	
	if (GlobalObj.PAAdmType!="O") $("#layoutMainCenter").addClass("layoutMainCenter");
	//�������͸ı�ʱ��Ҫ�޸�����combobox��Ĭ��ֵ,�ʳ�ʼ��ʱ��������Ԫ�ؼ�����֮�����
	Init();
	setTimeout(function(){
		//�Ӳ����������ҽ��
		if ('undefined' !== typeof CopyOeoriDataArr){
			AddCopyItemToList(CopyOeoriDataArr);
			CopyOeoriDataArr=undefined;
		}
		if ( +GlobalObj.CMDrugAndQtySplitConfig == 0) {
		    $("#DrugAndQtyYQ").checkbox('check');
		}else{
			$("#DrugAndQtySplit").checkbox('check');
		}
		ResizePromptWidth();
	},500)
    $('#PrescriptTypeBillList').tabs({
	  onSelect: function(title,index){
		  PrescTypeBillChange(index);
	  }
   });
	if (GlobalObj.PracticeShowFlag>0){
    	ShowPracticeOrder();
    }
    $("#Prompt").on({
		mouseenter:function(){
			if ($("#Prompt")[0].innerHTML =="") return;
			var thisWidth = $(this).width(); // div �Ŀ��
			var wordWidth = $(this).scrollWidth; // ��תΪjs����; ���ֵĿ��
			if(wordWidth <= thisWidth){
				return;
			}
			$HUI.tooltip(this,{
				position:'bottom',
				content:function(){ 
					return $("#Prompt")[0].innerHTML
					},
				trigger:'hover',
				placement:(GlobalObj.layoutConfig=="2"?'top':'bottom'),
				}).show();
			/*$(this).webuiPopover({
				width:$("#Prompt").width(),
				content:function(){ 
					return $("#Prompt")[0].innerHTML
				},
				trigger:'hover',
				placement:(GlobalObj.layoutConfig=="2"?'top':'bottom'),
				cache:false
			});
			$(this).webuiPopover('show');*/
		}
	});
	//����ӿڳ�ʼ��
    Common_ControlObj.Init();
});
function InitButtonBar()
{
	$('#btnList').marybtnbar({
        queryParams:{ClassName:'DHCDoc.OPDoc.MainFrame',QueryName:'QueryBtnCfg',url:'opdoc.oeorder.cmlistcustom.csp'},
		onBeforeLoad:function(param){
	        param.EpisodeID=GlobalObj.EpisodeID;
        },
        onLoadSuccess:function(data){
			InitBtnDisplay();
			InitLayOut();
	    }
    });
}
function PrescTypeBillChange(index){
	  var tab = $('#PrescriptTypeBillList').tabs('getSelected');
	  var index = $('#PrescriptTypeBillList').tabs('getTabIndex',tab);
	  var PrescriptTypeTemp=GlobalObj.PrescriptTypes.split("||")[index];
	  var presctypebilltypeid=PrescriptTypeTemp.split(PrescTypeDetailDelim)[4];
	  if (presctypebilltypeid!=GlobalObj.OrderBillTypeRowid){
		  var HaveEntryItem=false;
		  var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
		  for (var i=1; i<=rows; i++){
				if (HaveEntryItem==true) break;
				for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
					var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
					if ((OrderARCIMRowid!="")&&(HaveEntryItem==false)){
						HaveEntryItem=true;
					}
				}
		   }
		   if (HaveEntryItem){
				$.messager.confirm('ȷ�϶Ի���', t['NO_SAVE'], function(r){
						if (r) {
							ClearClickHandler();
							$("#ScreenBillSum,#TotailBillSum,#ScreenQtySum").val(0);
							$("#PrescList").combobox('select','');
							PageLogicObj.IsARCOSFormula=0;
							GlobalObj.OrderBillTypeRowid=presctypebilltypeid;
							PageLogicObj.m_selTabIndex=index;
						}else{
							$('#PrescriptTypeBillList').tabs('unselect',index);
							$('#PrescriptTypeBillList').tabs('select',PageLogicObj.m_selTabIndex);
							return false;
						}
					});
			}else{
				GlobalObj.OrderBillTypeRowid=presctypebilltypeid;
				PageLogicObj.m_selTabIndex=index;
			}
	  }
}
function InitCMPrescType(CMPrescTypeStrStr){
	if (CMPrescTypeStrStr==""){
		$.messager.alert("����","δά����������,����ά���������ͣ�");
        return false;
	}
	var CMPrescTypeKWArr=new Array();
	var selectKWId="";
	var ArrData = CMPrescTypeStrStr.split(String.fromCharCode(2));
	for (var i = 0; i < ArrData.length; i++) {
		var ArrData1 = ArrData[i].split(String.fromCharCode(1))
		if(!ArrData1) continue;
		var value=ArrData1[0];
		var desc=ArrData1[1];
		var CMPrescTypeCode=mPiece(value,"#",0);
		var IPDefaultCMPrescType=mPiece(value,"#",13);
		var OPDefaultCMPrescType=mPiece(value,"#",14);
		if (i==0) {
			selectKWId=CMPrescTypeCode;
		}
		if ((GlobalObj.PAAdmType=="I")&&(IPDefaultCMPrescType=="1")){
			selectKWId=CMPrescTypeCode;
		}
		if ((GlobalObj.PAAdmType!="I")&&(OPDefaultCMPrescType=="1")){
			selectKWId=CMPrescTypeCode;
		}
		CMPrescTypeKWArr.push({"text":desc, "id":CMPrescTypeCode, "value":value});
	}
   $("#CMPrescTypeKW").keywords({
	    singleSelect:true,
	    labelCls:'red',
	    items:CMPrescTypeKWArr,
	    onClick:function(v){
		    PageLogicObj.PreCMPrescTypeCode=PageLogicObj.CurCMPrescTypeCode;
		    //��¼��һ�δ��������Ϣ,�����л���������ʧ��ʱ��ԭĬ��
		    GetPreCMPrescTypeDataObj();
		    PageLogicObj.CurCMPrescTypeCode=v.id;
		    CMPrescTypeChangeHandler();
		}
	});
	$("#CMPrescTypeKW").keywords('select',selectKWId);
	PageLogicObj.CurCMPrescTypeCode=selectKWId;
	setTimeout(function(){
	    if (GlobalObj.StoreUnSaveData=="1"){
			var FieldName="UserUnSaveDataCM"+GlobalObj.EpisodeID;
			var UserUnSaveData = $.cm({
				ClassName:"web.DHCDocOrderEntry",
				MethodName:"GetUserCMUnSaveData",
				dataType:"text",
				Name:FieldName
			},false);
			if (UserUnSaveData!=""){AddUnsaveDataToList(UserUnSaveData);}
		}
	},500)
}
function InitEvent(){
	$HUI.checkbox("#DrugAndQtyYQ,#DrugAndQtySplit",{
        onCheckChange:function(e,value){
	       DrugAndQtyEntryModeChange(e,value);
        }
    });
    $HUI.checkbox("#PrescCookDecoction",{
        onCheckChange:function(e,value){
	       PrescCookDecoctionClick(e,value);
        }
    });
    $HUI.checkbox("#CMOrderOpenForAllHosp",{
        onCheckChange:function(e,value){
	       CMOrderOpenForAllHospClick(e,value);
        }
    });
	$('#StopPrescBtn').click(StopPrescClickHandler);
	$('#ordEntryType_change_Btn').click(function(){
		DocumentUnloadHandler();
		window.parent.argobj.CONTEXT="WNewOrderEntry";
		window.parent.LoadOrdTemplTree(window.parent.GetOrdTempTypeTabSel(),0);
		window.parent.LoadOrdEntryiFrame("WNewOrderEntry");
	    
	});
	InitPrescriptTypeBillList();
	document.onkeydown = Doc_OnKeyDown;
	
	 $('body').click(function(e){
		 var activeId=document.activeElement.id;
        if ((activeId=="")&&(activeId.indexOf("OrderName")<0)&&(activeId.indexOf("OrderDoseQty")<0)&&(activeId.indexOf("OrderPhSpecInstr")<0)){
	        FocusRowIndex=0;
			FocusGroupIndex=0;
	    }
    })
}
function Doc_OnKeyDown(e){
	if (GlobalObj.warning != "") {
		$(".messager-button a").click(); //�Զ��ر���һ��alert����
        $.messager.alert("����",GlobalObj.warning);
        return false;
    }
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
        if (event.keyCode == 83){ //����ҽ��
            UpdateClickHandler();
        }
        return false;
    }
    var activeId=document.activeElement.id;
    if ((e.keyCode==13)&&(activeId.indexOf("OrderName")>=0)) return false;
}
function InitCombox(){
	//��ҩ����
	$HUI.combobox('#PrescDuration',{      
    	valueField:'PHCDURowid',   
    	textField:'PHCDUDesc',
    	editable:true,
    	data: JSON.parse(GlobalObj.PrescDurationJson),
    	//url:$URL+"?ClassName=DHCDoc.OPDoc.CMOrderEntry&QueryName=LookUpDuration&Desc=&ResultSetType=array",
    	onSelect:function(record){
	    	PageLogicObj.PrescDurFactor=record.PHCDUFactor;
			PrescDurationLookupSelect(record);
		}
	});
	//ʹ�÷�ʽ
	$HUI.combobox('#PrescInstruction',{      
    	valueField:'HIDDEN',   
    	textField:'Desc',
    	editable:false,
    	data: JSON.parse(GlobalObj.PrescInstructionJson),
    	//url:$URL+"?ClassName=DHCDoc.OPDoc.CMOrderEntry&QueryName=LookUpInstr&Desc=&ResultSetType=array",
    	onSelect:function(){
	    	PrescInstrLookUpSelect();
		}
	});
	//��ҩƵ��
	$HUI.combobox('#PrescFrequence',{      
    	valueField:'PHCFRRowid',   
    	textField:'PHCFRDesc',
    	editable:false,
    	data: JSON.parse(GlobalObj.PrescFrequenceJson),
    	//url:$URL+"?ClassName=DHCDoc.OPDoc.CMOrderEntry&QueryName=LookUpFrequence&Desc=&ResultSetType=array",
	});
	//ҽ������
	$HUI.combobox('#PrescPrior',{      
    	valueField:'HIDDEN',   
    	textField:'Desc',
    	editable:false,
    	data: JSON.parse(GlobalObj.PrescPriorJson),
    	//url:$URL+"?ClassName=DHCDoc.OPDoc.CMOrderEntry&QueryName=LookUpOrderPrior&EpisodeType="+GlobalObj.PAAdmType+"&ResultSetType=array",
    	onLoadSuccess:function(){
			var sbox = $HUI.combobox("#PrescPrior");
			var Data=sbox.getData();
			var DefSelPrior="";
			for (var i=0;i<Data.length;i++){
				if (GlobalObj.PAAdmType=="I"){
					if (Data[i].HIDDEN==GlobalObj.OneOrderPriorRowid){
						DefSelPrior=Data[i].HIDDEN;
						break;
					}
				}else{
					if (Data[i].HIDDEN==GlobalObj.ShortOrderPriorRowid){
						DefSelPrior=Data[i].HIDDEN
						break;
					}
				}
			}
			window.setTimeout(function(){
				//��Ҫ��select�����¼����ӳ���Ϊ�˵�����combobox�������
				sbox.select(DefSelPrior);
			},100)
		},
		onSelect:function(record){
			//ҽ�����ͷ�ȡҩҽ��,����ѡ����ҽ��
			if (record.HIDDEN!=GlobalObj.OneOrderPriorRowid){
				$("#AddLongOrderList").combobox('select','').combobox("disable");
			}else{
				if ((GlobalObj.CurrentDischargeStatus=="B")||(GlobalObj.VisitStatus=="P")||(GlobalObj.LoginAdmLocFlag!="Y")) {
					$("#AddLongOrderList").combobox('select','').combobox("disable");
				}else{
					$("#AddLongOrderList").combobox("enable");
					var AddLongOrderObj=JSON.parse(GlobalObj.AddLongOrderJson);
					if (AddLongOrderObj.length==1){
						$("#AddLongOrderList").combobox('select',AddLongOrderObj[0].value);
					}
				}
			}
			SetRecLoc();
			ChangePrescPrior(record.HIDDEN);
		}
	});
	//һ������
	var cbox = $HUI.combobox("#PrescOrderQty", {
		valueField: 'Code',
		textField: 'Desc'
    });
    //���տ���
    var cbox = $HUI.combobox("#RecLoc", {
		valueField: 'id',
		textField: 'desc'
    });
    //��ҩ��ʽ��
	$HUI.combobox('#CookModelist',{      
    	valueField:'RowID',   
    	textField:'Desc',
		editable:false,
    	//data: JSON.parse(GlobalObj.CookModeJson),
    	onSelect:function(record){
			if (record) {
				SetRecLoc();
			}
		},
		onLoadSuccess:function(data){
			var val=$(this).combobox('getValue');
			var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
			var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
			var DetailsArr=CMPrescTypeDetails.split("#");
			var DefVal=DetailsArr[18];
			var Find=false,FindDef=false;
			$.each(data,function(){
				if(this.RowID==val) Find=true;
				if(this.RowID==DefVal) FindDef=true;
			});
			if(!Find){
				if(FindDef){
					$(this).combobox('setValue',DefVal);
				}else{
					$(this).combobox('setValue','');
				}
			}
		}
	});
	//ȡҩ��ʽ
	if (GlobalObj.TakingMedicineShowFlag=="Y"){
		$HUI.combobox('#TakingMedicineMethod',{      
	    	valueField:'RowID',   
	    	textField:'Desc',
			editable:false,
	    	mode:'remote',
	    	url:"./dhcdoc.cure.query.combo.easyui.csp",
	    	onBeforeLoad:function(param){
		    	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
		    	if (CMPrescTypeKWSel.length>0){
					var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
					var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
		    	}else{
			    	var CMPrescTypeCode=PageLogicObj.PreCMPrescTypeCode
			    	}
					param.ClassName = 'DHCDoc.DHCDocConfig.CMDocConfig';
					param.QueryName = 'FindTakingMedicineMethod';
					param.Arg1 =CMPrescTypeCode;
					param.Arg2 =session['LOGON.HOSPID'];
					param.ArgCnt =2;
		    	
			}  
		});
	}
    var PrescListArr=new Array();
    var ArrData = GlobalObj.PrescList.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        if (ArrData1[0]=="") continue;
        var value=ArrData1[0]+"^"+ArrData1[2];
		PrescListArr.push({"value":value, "desc":ArrData1[1]});
    }
    var cbox=$HUI.combobox("#PrescList", {
		valueField: 'value',
		textField: 'desc',
		data:PrescListArr,
		onSelect:function(record){
			if (record!=undefined){
				PrescListChange(record.value);
			}
		},formatter: function(row){
            var opts = $(this).combobox('options');
            var Data=row[opts.valueField]
            var Flag=Data.split("^")[1];
            if(Flag=='1'){
                return row[opts.textField];
            }else if(Flag=="2"){
	            //�ѽɷ�
	        	return '<span class="payprescno" style="padding:5px 0 6px 0;">'+row[opts.textField]+'<\/span>';    
	        }else if(Flag=="3"){
		        //�Ǳ��ξ��ﴦ��
	        	return '<span class="notcuradmprescno" style="padding:5px 0 6px 0;">'+row[opts.textField]+'<\/span>';    
	        }else if(Flag=='4'){
		        //������ֹͣ
		    	return '<span class="stopprescno" style="padding:5px 0 6px 0;">'+row[opts.textField]+'<\/span>'; 
			}
		},
		onLoadSuccess:function(data){
			$(".payprescno").parent().addClass("payprescno");
			$(".notcuradmprescno").parent().addClass("notcuradmprescno");
			$(".stopprescno").parent().addClass("stopprescno");
		},
		onShowPanel:function(){
			$(this).combobox('panel').children('.combobox-item').each(function(){
				if($(this).hasClass('tooltip-f')) return true;
				$(this).tooltip({
					position: 'left',
					content:'',
					onShow:function(){
						var content=$(this).tooltip('options').content;
						if(content==""){
							var that=this;
							var SelTitleArr=$(this).text().split(" ");
							var PrescNo=SelTitleArr[1];
							if (PrescNo=="") PrescNo=SelTitleArr[0];
							$.cm({
								ClassName:"web.UDHCPrescript",
								MethodName:"GetItemByPrescNo",
								EpisodeID:GlobalObj.EpisodeID,
								PrescNo:PrescNo
							},function(PrescData){
								if (PrescData.length>=1){
									var $table=$('<table></table>').css({'color':'#fff','border-collapse':'separate','border-spacing':'15px 5px'});
									var $tr=$('<tr></tr>')
									for(var i=1;i<=PrescData.length;i++){
										$tr.append('<td>'+PrescData[i-1].ArcimDesc+"&nbsp;&nbsp;"+PrescData[i-1].DoseQty+"</td>");
										if((i&&!(i%3))||(i==PrescData.length)){
											$table.append($tr.clone());
											$tr.empty();
										}
									}
									$(that).tooltip('update',$table.prop('outerHTML')).tooltip('reposition').tooltip('reposition') //.tooltip('reposition');
								}else{
									$(that).tooltip("destroy")
									}
							});
						}
					}
				})
			});
		}
    });
    if (GlobalObj.PAAdmType=="I"){
		var cbox = $HUI.combobox("#AddLongOrderList", {
				valueField: 'value',
				textField: 'desc', 
				data: JSON.parse(GlobalObj.AddLongOrderJson)
		    });
		if ((GlobalObj.CurrentDischargeStatus=="B")||(GlobalObj.VisitStatus=="P")||(GlobalObj.LoginAdmLocFlag!="Y")) {
			$("#AddLongOrderList").combobox('select','').combobox("disable");
		}else{
			$("#AddLongOrderList").combobox("enable");
			var AddLongOrderObj=JSON.parse(GlobalObj.AddLongOrderJson);
			if (AddLongOrderObj.length==1){
				$("#AddLongOrderList").combobox('select',AddLongOrderObj[0].value);
			}
		}
	}
    
}
function InitCMOrdEntryDataGrid(){
	$("#CMOrdEntry_DataGrid").jqGrid({
		width:'100%',
        height:'100%',
        url:'opdoc.request.query.grid.csp',
		datatype: "json",
		//editurl:'oeorder.oplistcustom.new.request.csp?action=test',
		shrinkToFit: false,
		autoScroll: false,
		mtype:'POST',
		emptyrecords:'û������',
		viewrecords:true,
		loadtext:'���ݼ�����...',
		multiselect:false,//��ѡ
		multiboxonly:false,
		rowNum:10, //ÿҳ��ʾ��������
		loadonce:false, //����һ������  ���ط�ҳ
		viewrecords: true,
		rownumbers:false,
		loadui:'enable',//disable����ajaxִ����ʾ��enableĬ�ϣ���ִ��ajax����ʱ����ʾ�� block����Loading��ʾ��������ֹ��������
		loadError:function(xhr,status,error){
			alert("diagnosentry.js-err:"+status+","+error);
		},
		colNames:ListConfigObj.colNames,			
		colModel:ListConfigObj.colModel,
		jsonReader: {
                rows:"rows",
                records:"total",
                repeatitems: false,
                id: "Id"
        },
		prmNames:{
			page:"page",//��ʾ����ҳ��Ĳ�������
			rows:"rows",//��ʾ���������Ĳ�������
			sort:"sidx",//��ʾ��������������Ĳ�������
			order:"sord",//��ʾ���õ�����ʽ�Ĳ�������
			search:"_search",//��ʾ�Ƿ�����������Ĳ�������
			nd:"nd",//��ʾ�Ѿ���������Ĵ����Ĳ�������
			id:"id",//��ʾ���ڱ༭����ģ���з�������ʱ��ʹ�õ�id������
			oper:"oper",//operation�������ƣ�����ʱ��û�õ���
			editoper:"edit",//����editģʽ���ύ����ʱ������������request.getParameter("oper") �õ�edit
			addoper:"add",//����addģʽ���ύ����ʱ������������request.getParameter("oper") �õ�add
			deloper:"del",//����deleteģʽ���ύ����ʱ������������request.getParameter("oper") �õ�del
			subgridid:"id",//��������������ݵ��ӱ�ʱ�����ݵ���������
			npage:null,
			totalrows:"totalrows" //��ʾ���Server�õ��ܹ����������ݵĲ������ƣ��μ�jqGridѡ���е�rowTotal
		},
		ondblClickRow:function(rowid,iRow,iCol,e){
			EditRow(rowid)				
		},
		onCellSelect:function(rowid,iCol,cellcontent,e){
		},
		onClickRow:function(rowIndex, rowData){
		},
		onSelectRow:function(rowid,status){	
		},
		beforeSelectRow:function(){	
			return true;//false ��ֹѡ���в���
		},
		onRightClickRow:function(rowid,iRow,iCol,e){
		},
		formatCell: function (rowid, cellname, value, iRow, iCol){
		},
		gridComplete:function(){
			
		},
		loadComplete:function(){
			//˫����ͷ�¼�
			jQuery('#CMOrdEntry_DataGrid').closest('.ui-jqgrid-view').find('div.ui-jqgrid-hdiv').bind("dblclick",headerDblClick);
			$('#CMOrdEntry_DataGrid').bind("drop", function(event) {
				console.log("��ֹ��ק");return false;
			});
			//WangQingyong �ƶ���CSP���ж� �˴������лᵼ����ͷ�������� 20210615
			/*var hiscolArr=new Array();
			if(GlobalObj.ViewGroupSum<4){
				for (var i=4;i>GlobalObj.ViewGroupSum;i--){
					var OrderName="OrderName"+i+"";
					var OrderDoseQty="OrderDoseQty"+i+"";
					var OrderPhSpecInstr="OrderPhSpecInstr"+i+"";
					var OrderDoseUOM="OrderDoseUOM"+i+"";
					var OrderCoverMainIns="OrderCoverMainIns"+i+"";
					hiscolArr.push(OrderName);
					hiscolArr.push(OrderDoseQty);
					hiscolArr.push(OrderDoseUOM);
					hiscolArr.push(OrderPhSpecInstr);
					hiscolArr.push(OrderCoverMainIns);
				}
			}
			$('#CMOrdEntry_DataGrid').setGridParam().hideCol(hiscolArr).trigger("reloadGrid");*/
			//CDSS��дҽ��
			if(typeof CDSSObj=='object') CDSSObj.AddOrdToList(GlobalObj.copyCDSSData);
			GlobalObj.copyCDSSData=[];
			var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
			if(records==0){
				Add_CMOrdEntry_row();
			}
		}
    });
}
function Add_CMOrdEntry_row(){
	if ($("#Add_Order_btn").hasClass('l-btn-disabled')){
		return false;
	}
	var rowid="";
	rowid=GetNewrowid();
	if(rowid=="" || rowid==0){return;}	
	var DefaultData={};
	$('#CMOrdEntry_DataGrid').addRowData(rowid,DefaultData);
	$('#CMOrdEntry_DataGrid').editRow(rowid, false);
	InitOrderNameLookup(rowid);
	//���ý���
	SetFocusColumn("OrderName1",rowid);
	return rowid;
}
//��ȡ������ID
function GetNewrowid(){
	var rowid="";
	var rowids=$('#CMOrdEntry_DataGrid').getDataIDs();
	if(rowids.length>0){	
		var prerowid=rowids[rowids.length-1];	
		if(prerowid.indexOf(".") != -1){
			rowid=parseInt(prerowid.split(".")[0])+1;
		}else{
			rowid=parseInt(prerowid)+1;
		}		
	}else{
		rowid=1;
	}	
	return rowid;
}
var ItemzLookupGrid;
function xItem_lookuphandler(e){
	var type=websys_getType(e);
	var key=websys_getKey(e);
	var obj=websys_getSrcElement(e);
	var Id=obj.id;
	var Row=GetEventRow(e);
	FocusRowIndex=Row
	FocusGroupIndex=GetFocusGroupIndex(Id);
	if (MoveFouce(key,FocusRowIndex,FocusGroupIndex,"OrderName")){
		return websys_cancel();
	}
	var OrderHiddenPara=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderHiddenPara");
	if (OrderHiddenPara!=""){
        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
        PageLogicObj.IsARCOSFormula = $.cm({
			ClassName:"web.UDHCPrescript",
			MethodName:"IsARCOSFormula",
			dataType:"text",
			ARCOSRowid:ARCIMARCOSRowid
		},false);
        if (PageLogicObj.IsARCOSFormula=="1") return false;
    }else{
    	if ((PageLogicObj.IsARCOSFormula=="1")&& (GlobalObj.FormulaCanAppendItem=="0")) return false;
    }
    return true;
    var OrderName=$(obj).val();
    OrderName=$.trim(OrderName);
    //���¼������,�򽹵�����������ǰ�ESC�����Զ����ز�ѯ��
    if (ItemzLookupGrid && ((key == 27) || (OrderName == ""))) {
        ItemzLookupGrid.hide();
    }
    if(OrderName=="") return;
    //�س��¼�����,�����������λ��,�����ѡ���¼��(PageLogicObj.EntrySelRowFlag==1)�򲻵�����ѯ��
    if (key == 13) {
        if (PageLogicObj.EntrySelRowFlag==0) {
            xItem_lookuphandlerX(e,Id, OrderName);
        }else{
            PageLogicObj.EntrySelRowFlag=0;
        }
    }
    if ((type == 'dblclick')||((OrderName.length>1)&&(PageLogicObj.OEORIRealTimeQuery==1)&&(key>64 && key<91))) {
        xItem_lookuphandlerX(e,Id, OrderName);
    }
}
function xItem_lookuphandlerX(e,Id, OrderName){
	var obj=websys_getSrcElement(e);
	var CurLogonDep=session['LOGON.CTLOCID']; 
    var GroupID=session['LOGON.GROUPID'];
	var catID=""
	var subCatID="";
	var P5="0"; 
	var LogonDep=""
	var OrderPriorRowid="";
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
	var P6=CMPrescTypeCode; 
	var P7="";
	var P8=GlobalObj.EpisodeID;
    var P9="",P10="";
	var OrdCatGrp="";
	if (ItemzLookupGrid&&ItemzLookupGrid.store) {
		ItemzLookupGrid.searchAndShow([OrderName,GroupID,catID,subCatID,P5,P6,P7,GlobalObj.EpisodeID,P9,P10,'',OrdCatGrp]);
	}else {
		ItemzLookupGrid = new dhcc.icare.Lookup({
			lookupListComponetId: 1872,
			lookupPage: "ҽ����ѡ��",
			lookupName: Id,
			listClassName: 'web.DHCDocOrderEntryCM',	
			listQueryName: 'LookUpItem',
			resizeColumn:true,
			isCombo: true,
			listProperties: [function() { return $(obj).val(); },GroupID,catID,subCatID,P5,P6,P7,GlobalObj.EpisodeID,P9,P10,'',OrdCatGrp], 
			listeners:{'selectRow': OrderItemLookupSelect},
			pageSize: 20
		});
	}
	return websys_cancel();
}
function OrderItemLookupSelect(txt,callBackFun){
	//��ҽ����¼��ʱAddCopyItemToList��ҲҪ�ж����,�ʴ˴����ڵ���
	//¼��ҽ��ʱ��������ݣ���ֹ��һ��ҽ��¼����÷�Ӱ�쵱ǰҽ��¼��
	ClearGroupData(FocusRowIndex,FocusGroupIndex)
	var txt=txt;
	var adata=txt.split("^");
	var iordertype=adata[3];
	if (iordertype=="ARCOS") {
		var icode=adata[1];
		ClearGroupData(FocusRowIndex,FocusGroupIndex);
		setTimeout(eval("OSItemListOpen("+icode+",'"+adata[0]+"','YES','')"),100);
		callBackFun(true);
	}else{
		new Promise(function(resolve,rejected){
			//�ж��Ƿ�������
			var adata=txt.split("^");
			var isubcatcode=adata[5];
			CheckDiagnose(adata[1],resolve);
		}).then(function(rtn){
			return new Promise(function(resolve,rejected){
				if (!rtn) {
					$("#"+FocusRowIndex+"_OrderName"+FocusGroupIndex).lookup('setText',"");
			    	resolve(false);
				}else{
					PageLogicObj.EntrySelRowFlag=1;
					var adata=txt.split("^");
					var icode=adata[1];
					SetCellData(FocusRowIndex,FocusGroupIndex,"OrderARCIMID","");
				    var Para="";
				    var OrderPhSpecInstr=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderPhSpecInstr");
				    var OrdParamsArr=new Array();
					OrdParamsArr[OrdParamsArr.length]={
						OrderARCIMRowid:icode,
						ParamS:Para,
						OrderPhSpecInstr:OrderPhSpecInstr
					};
					AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve);
				}
			})
		}).then(function(returnValue){
			return new Promise(function(resolve,rejected){
				if (returnValue==false) {
					ClearGroupData(FocusRowIndex,FocusGroupIndex);
				}else{
					SetScreenSum();
					var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
					if (FocusGroupIndex==GlobalObj.ViewGroupSum){
						var cbox=$HUI.checkbox("#DrugAndQtyYQ");
						if (!cbox.getValue()){
							if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
							FocusGroupIndex=1;
							FocusRowIndex=eval(FocusRowIndex)+1;
							SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
						}
					}
				}
				resolve(returnValue);
			})
		}).then(function(rtn){
			callBackFun(rtn);
		})
	}
}
function OSItemListOpen(ARCOSRowid,OSdesc,del,itemtext,OrdRowIdString) {
	if (ARCOSRowid!="") {
		new Promise(function(resolve,rejected){
			//PageLogicObj.m_ARCOSRowId=ARCOSRowid;
		    PageLogicObj.IsARCOSFormula = $.cm({
				ClassName:"web.UDHCPrescript",
				MethodName:"IsARCOSFormula",
				dataType:"text",
				ARCOSRowid:ARCOSRowid
			},false);
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")){
				var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
				var GroupList=[];
				for(var i=1;i<=rows;i++){
					for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
					   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
					   if (OrderARCIMRowid!=""){
						   GroupList.push(i+"^"+j);
					   }
					}
				}
				if (GroupList.length>0){
		        	$.messager.alert("��ʾ","Э���������������ͨҩƷ�쿪!","info",function(){
		            	for (var i=0;i<GroupList.length;i++) {
		                	ClearGroupData(GroupList[i].split("^")[0],GroupList[i].split("^")[1]);
		                }
		                FocusRowIndex=1;
		                FocusGroupIndex=1;
		                resolve();
		            });
		        }else{
		            resolve();
		        }
			}else{
				resolve();
			}
		}).then(function(){
			return new Promise(function(resolve,rejected){
				if ((PageLogicObj.IsARCOSFormula=="1")||(GlobalObj.CMMedNotOpenARCOS=="1")){
					PageLogicObj.m_ARCOSRowId=ARCOSRowid;
					ARCOSChangePrescType(ARCOSRowid,(function(ARCOSRowid){
						return function(){
							$.cm({
								ClassName:"web.DHCDocOrderCommon",
								MethodName:"SetARCOSItemDirect",
								itmjs:"",
								ARCOSRowid:ARCOSRowid,
								HospitalId:session['LOGON.HOSPID'],
								EpisodeID:GlobalObj.EpisodeID,
								dataType:"text"
							},function(ret){
								AddCopyItemToList(ret.split("###"));
							})
						}
					})(ARCOSRowid));
					
				}else{
					//�Զ��л����������п����е����������ҽ���׵�����Ҫ�ûص�����-tanjishan202006
					ARCOSChangePrescType(ARCOSRowid,(function(ARCOSRowid){
						return function(){
							websys_showModal({
								url:"doc.arcositemlist.hui.csp?EpisodeID=" + GlobalObj.EpisodeID + "&ARCOSRowid=" + ARCOSRowid,
								//title:"<font color=yellow><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_group.png' style='vertical-align: sub;'></img>"+OSdesc+'</font> ��ҩҽ����¼��',
								title:"<font color='#FF1A00'>"+OSdesc+'</font>'+$g(" ��ҩҽ����¼��"),
								iconCls:'icon-w-list',
								width:1160,height:592,
								AddCopyItemToList:AddCopyItemToList
							});
						}
					})(ARCOSRowid));
				}
			})
		})
	}
}
function ClearGroupData(Rowindex,GroupNo){
	SetCellData(Rowindex,GroupNo,"OrderName",'');
	SetCellData(Rowindex,GroupNo,"OrderDoseQty",'');
	SetCellData(Rowindex,GroupNo,"OrderPhSpecInstr",'');
	SetCellData(Rowindex,GroupNo,"OrderPrice",'');
	SetCellData(Rowindex,GroupNo,"OrderARCIMID",'');
	SetCellData(Rowindex,GroupNo,"OrderItemID",'');
	SetCellData(Rowindex,GroupNo,"OrderSum",'');
	SetCellData(Rowindex,GroupNo,"OrderHiddenPara",'');
	SetCellData(Rowindex,GroupNo,"OrderDoseUOM",'');
	$("#"+Rowindex+"_OrderCoverMainIns"+GroupNo+"").prop("checked",false);
}	
function AddItemToList(RowIndex,GroupIndex,OrdParams,callBackFun) {
	SetTimeLog("AddItemToList","start");
	//�������¼����ȡ���տ���?�Ͱѵ�¼���Ҵ���ȥ
	var LogonDep="";
    if ($("#FindByLogDep").checkbox('getValue')){
	    FindRecLocByLogonLoc=1;
	    LogonDep=session['LOGON.CTLOCID']
	}else{
		FindRecLocByLogonLoc=0;
	}
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
	var CMPrescTypeCode=DetailsArr[0];
	var FocusObj=GetNewFocusIndex();
	RowIndex=FocusObj.FocusRowIndex;
   	GroupIndex=FocusObj.FocusGroupIndex;
   	TakingMedicineMethod=""
   	if (GlobalObj.TakingMedicineShowFlag=="Y"){
	   	TakingMedicineMethod=$("#TakingMedicineMethod").combobox('getValue')
	   	}
	var BaseParam = {
		///����ҽ����Ϣ-��̨�������ⲿ������
		OrderARCIMRowid:"",
		PrescTypeCode:CMPrescTypeCode,
		RelocRowID:$('#RecLoc').combobox('getValue'),
		PrescDurFactor:GetDurFactor(),
		OrderBillTypeRowid:GlobalObj.OrderBillTypeRowid,
		ITMRowId:"",
		rowid:RowIndex+"^"+GroupIndex,
		///ȫ�ֱ���
		Adm:GlobalObj.EpisodeID,
		LogonDep:LogonDep,
		OrderOpenForAllHosp:$("#CMOrderOpenForAllHosp").checkbox('getValue')?1:0, 
		SessionStr:GetSessionStr(),
		OrderARCOSRowid:"",
		RowIndex:RowIndex,
		GroupIndex:GroupIndex,
		OrderPriorRowid:$('#PrescPrior').combobox('getValue'),
		TakingMedicineMethod:TakingMedicineMethod
	}
	var ItemOrdsJson=GetItemOrds();
	//��Ҫ�󶨵����ϵ�ҽ��
	var UserOptionsArr=new Array();
	var NeedAddItemCongeriesArr=new Array();
	new Promise(function(resolve,rejected){
		SetTimeLog("GetItemCongeries","start");
		GetItemCongeries(OrdParams,BaseParam,ItemOrdsJson,UserOptionsArr,NeedAddItemCongeriesArr,resolve);
	}).then(function(NeedAddItemCongeriesObj){
		SetTimeLog("GetItemCongeries","end");
		FocusRowIndex=FocusObj.FocusRowIndex;
   		FocusGroupIndex=FocusObj.FocusGroupIndex;
		if (NeedAddItemCongeriesObj.length==0){
			SetFocusColumn("OrderName"+GroupIndex,RowIndex);
			if (callBackFun) callBackFun(false);
			return;
		}
		var ObjAdd=AddItemCongeriesToRow(NeedAddItemCongeriesObj);
		if (ObjAdd==true){
			var cbox=$HUI.checkbox("#DrugAndQtyYQ");
			if (cbox.getValue()){
				SetFocusColumn("OrderDoseQty"+GroupIndex,RowIndex);
			}else{
				if (GroupIndex==GlobalObj.ViewGroupSum){
					var NewRowIndex=eval(RowIndex)+1;
					var NewGroupIndex=1;
				}else{
					var NewRowIndex=RowIndex;
					var NewGroupIndex=eval(GroupIndex)+1;
				}
				SetFocusColumn("OrderName"+NewGroupIndex,NewRowIndex);
			}
		}
		if (callBackFun) callBackFun(ObjAdd);
	})
	//�����󼯺���ӵ�����
	function AddItemCongeriesToRow(NeedAddItemCongeriesObj){
		if (+FocusGroupIndex==0) FocusGroupIndex=1;
		if (+FocusRowIndex==0) FocusRowIndex=1;
		if (+RowIndex==0) RowIndex=FocusRowIndex;
   		if (+GroupIndex==0) GroupIndex=FocusGroupIndex;
		var ParamObj={};
		for (var i=0,Length=NeedAddItemCongeriesObj.length;i<Length;i++) {
			ParamObj={};
			ParamObj=NeedAddItemCongeriesObj[i];
			//����������
			var returnValue=AddItemDataToRow(RowIndex,GroupIndex,ParamObj);
			if (returnValue==true) {
				if (i<(Length-1)) {
					if (FocusGroupIndex==GlobalObj.ViewGroupSum){
						var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
						if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
						FocusGroupIndex=1;
						GroupIndex=1;
						FocusRowIndex=eval(FocusRowIndex)+1;
						RowIndex=FocusRowIndex;
					}else{
						FocusGroupIndex=eval(FocusGroupIndex)+1;
						GroupIndex=FocusGroupIndex;
					}
				}
			}
		}
		return true;
	}
	function GetItemCongeries(OrdCongeriesObj,BaseParamObj,ItemOrdsJson,UserOptionsArr,NeedAddItemCongeriesArr,callBackFun){
		var NeedAddItemCongeriesObj=new Array();
		if (NeedAddItemCongeriesArr.length==0) {
			var PreNeedAddItemCongeriesObj=new Array();
		}else{
			var PreNeedAddItemCongeriesObj=NeedAddItemCongeriesArr;
		}
		var OrdCongeriesJson=JSON.stringify(OrdCongeriesObj);
		var BaseParamJson=JSON.stringify(BaseParamObj);
		var UserOptionsJson=JSON.stringify(UserOptionsArr);
		var ItemCongeries = cspRunServerMethod(GlobalObj.GetItemCongeriesToListMethod, OrdCongeriesJson,BaseParamJson,ItemOrdsJson,UserOptionsJson);
		var ItemCongeriesObj=eval("("+ItemCongeries+")");
		var RecursionFlag=false,Sum=0;
		if (PreNeedAddItemCongeriesObj.length>0){
			//�ڶ��ν�������ֻ��Ҫ������Ҫ��ӵĴ�
			for (var i=0;i<ItemCongeriesObj.length;i++){
				var ItemToListDetailObj=ItemCongeriesObj[i];
				if (ItemToListDetailObj.ErrCode<0) continue;
				if ($.isEmptyObject(ItemToListDetailObj.OrdListInfo)==true) continue;
				var PreItemToListDetailObj=PreNeedAddItemCongeriesObj[i];
				if (PreItemToListDetailObj.PreSuccessFlag==false) continue;
				NeedAddItemCongeriesObj[NeedAddItemCongeriesObj.length]=ItemToListDetailObj.OrdListInfo;
			}
			callBackFun(NeedAddItemCongeriesObj);
		}else{
			new Promise(function(resolve,rejected){
				(function(callBackExecFun){
					function loop(i){
						new Promise(function(resolve,rejected){
							var ItemToListDetailObj=ItemCongeriesObj[i];
							if ($.isEmptyObject(ItemToListDetailObj)) {
								resolve();
							}
							///ע��:js�ж�����ָ����
							///У���̨��ȡ���������Ƿ���û��Ƿ���Ҫ�޸�
							$.extend(ItemToListDetailObj, {ItemCongeriesObj:ItemCongeriesObj,callBackFun:resolve});
							CheckItemCongeries(ItemToListDetailObj);
						}).then(function(CheckBeforeAddObj){
							var ItemToListDetailObj=ItemCongeriesObj[i];
							if (typeof CheckBeforeAddObj!="undefined"){
								if (CheckBeforeAddObj.UserOptionObj.length>0){
									var CellPos=ItemToListDetailObj.OrdListInfo.RowIndex+"^"+ItemToListDetailObj.OrdListInfo.GroupIndex;
									UserOptionsArr.push({rowid:CellPos,UserOption:CheckBeforeAddObj.UserOptionObj});
									RecursionFlag=true;
								}
								//Э������������¼�����������˳�ѭ��
								if ((CheckBeforeAddObj.SuccessFlag==false)&&(PageLogicObj.IsARCOSFormula==1)&&(ItemToListDetailObj.OrdListInfo.IsARCOSFormula==1)){
									$.messager.alert("��ʾ","���ڲ�����¼��������ҽ��,����ʹ�ô�Э������ҽ����¼��ҽ��!","info",function(){
										NeedAddItemCongeriesObj=[];
										PageLogicObj.m_ARCOSRowId="";
										callBackFun(NeedAddItemCongeriesObj);
									})
									return;
								}
								//���ÿ���
								var OrderPriorRowid = $('#PrescPrior').combobox('getValue');
								var OrderPrice=ItemToListDetailObj.OrdListInfo.OrderPrice;
								if ((OrderPriorRowid != GlobalObj.OMOrderPriorRowid) && (OrderPriorRowid != GlobalObj.OMSOrderPriorRowid) && (parseFloat(OrderPrice) != 0)) {
									Sum=parseFloat(Sum)+parseFloat(ItemToListDetailObj.OrdListInfo.OrderSum);
								}
								if ((CheckBeforeAddObj.SuccessFlag==true)&&($.isEmptyObject(ItemToListDetailObj.OrdListInfo)==false)){
									NeedAddItemCongeriesObj[NeedAddItemCongeriesObj.length]=ItemToListDetailObj.OrdListInfo;
								}
							}
							i++;
							if ( i < ItemCongeriesObj.length ) {
								 loop(i);
							}else{
								if (RecursionFlag==true){
									GetItemCongeries(OrdCongeriesObj,BaseParamObj,ItemOrdsJson,UserOptionsArr,NeedAddItemCongeriesObj,callBackFun);
									return;
								}else{
									callBackExecFun();
								}
							}
						})
					}
					loop(0);
				})(resolve); //�˴���resolve��ָcallBackFun(NeedAddItemCongeriesObj)
			}).then(function(){
				if (Sum>0) {
					if (!CheckDeposit(Sum, "")) {
						NeedAddItemCongeriesObj=[];
					}
				}
				SetTimeLog("AddItemToList", "GetItemCongeries over");
				callBackFun(NeedAddItemCongeriesObj);
			});
		}
	}
	function GetItemOrds(){
		var ItemOrdsObj={
			Length:0,
			ItemOrds:[]	//�ж��󼯺�
		}
		var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    	for (var i=1; i<=rows; i++){
			for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
				var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
				var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
				if ((OrderDoseQty=="")||(!isNumber(OrderDoseQty))){
					OrderDoseQty=0;
				}
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
				if (OrderARCIMRowid!=""){
					var ItemOrd={
						OrderARCIMRowid:OrderARCIMRowid,
						OrderDoseQty:OrderDoseQty,
						OrderHiddenPara:OrderHiddenPara,
						Row:i,
						Group:j
					}
					ItemOrdsObj.ItemOrds.push(ItemOrd);
					ItemOrdsObj.Length=ItemOrdsObj.Length+1;
				}
			}
		}
		var ItemOrdsJson=JSON.stringify(ItemOrdsObj);
		return ItemOrdsJson;
	}
}
function OrderDoseQtykeyuphandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {
		var obj=websys_getSrcElement(e);
		FocusGroupIndex=GetFocusGroupIndex(obj.id);
		var Row=GetEventRow(e);
		MoveFouce(keycode,Row,FocusGroupIndex,"OrderDoseQty")
		return websys_cancel();
	}catch(e) {};
}
function OrderDoseQtykeydownhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	try {
		// || ((keycode > 95) && (keycode < 106))
		if ((keycode == 8) || (keycode == 9) || (keycode == 46)|| (keycode == 110) || (keycode == 13) || ((keycode > 47) && (keycode < 58))) {
			var obj=websys_getSrcElement(e);
			var OrderDoseQty=obj.value;
			FocusGroupIndex=GetFocusGroupIndex(obj.id);
			var Row=GetEventRow(e);
			var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
			var OrderARCIMRowid=GetCellData(Row,FocusGroupIndex,"OrderARCIMID");
			var OrderHiddenPara=GetCellData(Row,FocusGroupIndex,"OrderHiddenPara");
  			var AllowEntryDecimalItemCat=mPiece(OrderHiddenPara,String.fromCharCode(3),13);
			if ((keycode == 46)|| (keycode == 110)){
		       if (OrderARCIMRowid!=""){
			       //var SubCatID = tkMakeServerCall("web.DHCDocOrderEntry","GetARCItemSubCatIDBroker",'','',OrderARCIMRowid);
			       //var AllowEntryDecimalItemCatStr = "^" + GlobalObj.AllowEntryDecimalItemCat + "^";
				   if (AllowEntryDecimalItemCat!="Y") {
					   return websys_cancel();
				   }
			    } 
		    } 
		    if ((keycode==13)||(keycode==9)){
			    SetScreenSum();
			    if ((OrderDoseQty!="")&&(OrderDoseQty!="0")&&(OrderARCIMRowid!="")){
					if (GlobalObj.HospitalCode=="SCDXHXYY"){
						if (FocusGroupIndex==GlobalObj.ViewGroupSum){
							if ((PageLogicObj.IsARCOSFormula==0)||(GlobalObj.FormulaCanAppendItem=="1")){
								var NextRow=parseInt(Row)+1;
								if (records==NextRow) {Add_CMOrdEntry_row();}
							}
						}
						SetFocusColumn("OrderPhSpecInstr"+FocusGroupIndex,Row);
					}else{
						if ((PageLogicObj.IsARCOSFormula==0)||(GlobalObj.FormulaCanAppendItem=="1")){
							if (FocusGroupIndex==GlobalObj.ViewGroupSum){
								if (records==Row) {Add_CMOrdEntry_row();}
								FocusGroupIndex=1;
								Row=eval(Row)+1;
							}else{
								FocusGroupIndex=eval(FocusGroupIndex)+1;
							}
							var cbox=$HUI.checkbox("#DrugAndQtyYQ");
							if (cbox.getValue()){
								SetFocusColumn("OrderName"+FocusGroupIndex,Row);
							}else{
								SetFocusColumn("OrderDoseQty"+FocusGroupIndex,Row);
							}
						}
					}
				}
				return websys_cancel();
		    }
		}else{
			return websys_cancel();	
		}
	}catch(e) {}
}
function OrderDoseQtychangehandler(e){
	try {
		var obj=websys_getSrcElement(e);
		var Sum=obj.value
		var Id=obj.id;
		FocusGroupIndex=GetFocusGroupIndex(Id);
		var OrderDoseQty=obj.value;
		if (!isNumber(OrderDoseQty)){
			OrderDoseQty=0;
		}
		var Row=GetEventRow(e);
		var OrderARCIMRowid=GetCellData(Row,FocusGroupIndex,"OrderARCIMID");
		new Promise(function(resolve,rejected){
			CheckProtocolPackSum(FocusGroupIndex,Row,resolve);
		}).then(function(Rtn){
			return new Promise(function(resolve,rejected){
				if (Rtn==false) return;
				CheckINCIPackSum(FocusGroupIndex,Row,0,resolve);
			})
		}).then(function(INCIPackCombStr){
			if (INCIPackCombStr == "") return; 
			var OrderSum=0;
		    if ((OrderDoseQty!="")&&(OrderARCIMRowid!="")){
				var PrescDurationFactor=1;
				var Price=$("#"+Row+"_OrderPrice"+FocusGroupIndex+"").val();
				OrderSum=parseFloat(OrderDoseQty)*PrescDurationFactor*parseFloat(Price);
		    }
			$("#"+Row+"_OrderSum"+FocusGroupIndex+"").val(OrderSum);
		    SetScreenSum();
		})
	}catch(e) {dhcsys_alert(e.message)}
}
function CheckProtocolPackSum(GroupIndex,Row,callBackFun) {
	var e=$("#"+Row+"_OrderDoseQty"+GroupIndex+"");
	if (!e) callBackFun(true);
	var Sum=GetCellData(Row,GroupIndex,"OrderDoseQty");
	var OrderARCIMRowid=GetCellData(Row,GroupIndex,"OrderARCIMID");
	if (!OrderARCIMRowid) {
		callBackFun(true);
		return;
	}
	if (Sum > 1000000) {
		$.messager.alert("��ʾ","��ζҩƷ����������Χ,����������!","info",function(){
			$("#"+Row+"_OrderDoseQty"+GroupIndex+"").val("").focus();
			SetScreenSum();
			callBackFun(false);
		})
		return;
	}
	var RecLoc=$('#RecLoc').combobox('getValue'); 
	//�ж��µ������ǲ�����ҩ��ϵ�����
	var rtn = $.cm({
		ClassName:"web.DHCOEOrdItem",
		MethodName:"CheckProtocolPackSum",
		dataType:"text",
		OrderARCIMRowid:OrderARCIMRowid, 
		SumQty:Sum,
		RecLocDr:RecLoc
	},false);
	var rtnArr=rtn.split("^");
	if (rtnArr[0]!="0"){
		$.messager.alert("��ʾ",rtnArr[1],"info",function(){
			$("#"+Row+"_OrderDoseQty"+GroupIndex+"").focus();
			callBackFun(false);
		});
		return false;
	}else{
		callBackFun(true);
	}
	
}
function OrderPhSpecInstrchangehandler(e){
}
function Columnfocushandler(e){
	var obj=websys_getSrcElement(e);
	var Id=obj.id;
	var Row=GetEventRow(e);
	if (Row==undefined) return;
	FocusRowIndex=Row
	FocusGroupIndex=GetFocusGroupIndex(Id);
}
function SetFocusColumn(ColName,Row){
	var obj=$("#"+Row+"_"+ColName+"");
	if(obj){
		websys_setfocus(Row+"_"+ColName);
	}
}
function SetScreenSum(){
	var ScreenQtySum=0;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
	new Promise(function(resolve,rejected){
	    (function(callBackFunExec){
			var DataArry=[],SumObj=[];
    		for (var i=1; i<=rows; i++){
				for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
					var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
					if (OrderARCIMRowid=="") continue;
					var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
					if (OrderDoseQty=="") continue;
					if (!isNumber(OrderDoseQty)) continue;
					DataArry.push({Row:i,Group:j})
				}
			}
			//û����Ч����,ֱ����Ϊ0
			if (DataArry.length==0) {
				callBackFunExec(SumObj);
			}
			var i=0;
		    function loop(Index){
				var Row=DataArry[Index].Row,Group=DataArry[Index].Group;
				new Promise(function(resolve,rejected){
					CheckINCIPackSum(Group,Row,"0",resolve)
				}).then(function(INCIPackCombStr){
					return new Promise(function(resolve,rejected){
						var OrderDoseQty=GetCellData(Row,Group,"OrderDoseQty");
						ScreenQtySum=ScreenQtySum+parseFloat(OrderDoseQty);
						var OrderHiddenPara=GetCellData(Row,Group,"OrderHiddenPara");
						var OrderItemSum=OrderHiddenPara.split(String.fromCharCode(3))[12];
						if (INCIPackCombStr!=""){
							OrderItemSum=tkMakeServerCall("web.DHCSTINTERFACE","GetInciListPrice",INCIPackCombStr,session['LOGON.HOSPID'])
						}
						if (OrderItemSum=="") OrderItemSum=0
							var OneSumObj={
								amount:parseFloat(OrderItemSum) //,*parseFloat(OrderDoseQty)
						};
						SumObj.push(OneSumObj);
						resolve();
					})
				}).then(function(){
					i++;
					if ( i < DataArry.length ) {
						 loop(i);
					}else{
						callBackFunExec(SumObj);
					}
				})
			}
			loop(0)
		})(resolve);
	}).then(function(SumObj){
		var amount=0;
		for (var i=0;i<SumObj.length;i++) {
			amount=amount+parseFloat(SumObj[i].amount);
		}
		var PrescDurationFactor=GetDurFactor();
		var TotalToBillSum=parseFloat(GlobalObj.ToBillSum)+parseFloat(amount);
		TotalToBillSum=TotalToBillSum.toFixed(2);
		$("#ScreenBillSum").val(amount.toFixed(2));
		$("#ScreenQtySum").val(ScreenQtySum.toFixed(2));
		if (PrescDurationFactor!=""){	
			var totalbill=(amount*100*PrescDurationFactor/100); //ע����js����ʱ��������ʾ��������ѭ����С����ֻ���ȳ���100�ٳ���100���Խ�������⡣
			totalbill=totalbill.toFixed(2);
			$("#TotailBillSum").val(totalbill);
		}else{
			$("#TotailBillSum").val(amount);
		}
	});
}
function GetEventRow(e){
	var obj=websys_getSrcElement(e);
	var Id=obj.id;
	if (!Id){return;}
	var arrId=Id.split("z");
	var Row=arrId[arrId.length-1].split("_")[0];
	var TDSrc=websys_getParentElement(obj);
	var TRSrc=websys_getParentElement(TDSrc);
	FocusRowIndex=TRSrc.rowIndex;
	return Row
}
function GetFocusGroupIndex(objId){
	if (!objId){return;}
	var arrId=objId.split("z");
	var ColName=arrId[0];
	var start=ColName.length-1;
	GroupIndex=+ColName.substring(start,start+1);
	if (GroupIndex==0) GroupIndex=1;
	return GroupIndex;
}
function CMPrescTypeChangeHandler(){
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
    var CMPrescTypeCode=DetailsArr[0];
    var FreqStr=DetailsArr[1];
    var FormFreqRowid=mPiece(FreqStr, "!", 0);
    var InstrStr=DetailsArr[2];
    var FormInstrRowid=mPiece(InstrStr, "!", 0);
    var DurStr=DetailsArr[3];
    var FormDurRowid=mPiece(DurStr, "!", 0);
    var DefaultQtyStr=DetailsArr[4];
    var DefaultQtyID=mPiece(DefaultQtyStr, "!", 1);
    var CMRecLocStr=DetailsArr[6];
    CMRecLocStr=CMRecLocStr.replace(/[!]/g, String.fromCharCode(2))
    CMRecLocStr=CMRecLocStr.replace(/[@]/g, String.fromCharCode(1))
    var CNMedCookReclocStr=DetailsArr[7];
    var CNMedCookModeFeeItem=DetailsArr[10];
    var NotAllowChangeCook=DetailsArr[12];
    var CheckChange=1;
	var sbox=$HUI.checkbox("#PrescCookDecoction") //����checkbox
	var PrescCookDVal=sbox.getValue();
	sbox.enable(); //�˴���������checkbox�Ƿǽ���״̬,�������״̬���޸�checkbox��ѡ��״̬�������onCheckChange�¼�
	///����ᴥ��PrescCookDecoctionClick�¼�,�ӳ��л����ܿ���,���Զ��л�ҽ������	
	if ((CNMedCookModeFeeItem!="")||(CNMedCookReclocStr!="")){
		if (!PrescCookDVal) sbox.setValue(true);
		else  CheckChange=0; 
	}else{
		if (PrescCookDVal) sbox.setValue(false);
		else  CheckChange=0; 
	}
	if (NotAllowChangeCook=="1"){
		sbox.disable();
	}else{
		sbox.enable();
	}
	/// ���жϴ����Ƿ��ǿɱ༭״̬�����ǲ��ɱ༭״̬�����ܴ���PrescCookDecoctionClick�¼�
	//var DisabledFlag=$("#PrescCookDecoction").prop("disabled");
	if (CheckChange==0){ //((DisabledFlag)||
		setTimeout(function(){
			SetPrescAppenItemQty();
		})
	}
	var sbox = $HUI.combobox("#PrescFrequence");
	if ($.hisui.indexOfArray(sbox.getData(),"PHCFRRowid",FormFreqRowid)<0) FormFreqRowid="";
		sbox.select(FormFreqRowid);
	var sbox = $HUI.combobox("#PrescInstruction");
	if ($.hisui.indexOfArray(sbox.getData(),"HIDDEN",FormInstrRowid)<0) FormInstrRowid="";
		sbox.select(FormInstrRowid);
	var sbox = $HUI.combobox("#PrescDuration");
		//sbox.select(FormDurRowid); //select�ᴥ��PrescCookDecoctionClick,��������AutoConvertPrescForm�¼�,����AutoConvertPrescForm�¼��ظ�����
	sbox.setValue(FormDurRowid); 
	setTimeout(function(){
		var sbox = $HUI.combobox("#CookModelist");
		sbox.select(DetailsArr[18]); 
	})
	var DurFactor = $.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"GetDurationFactor",
		dataType:"text",
		DurationRowid:FormDurRowid
	},false);
	PageLogicObj.PrescDurFactor=DurFactor; 
	$('#PrescOrderQty').combobox('select',DefaultQtyID);
	//�޸�ȡҩ��ʽ
	if (GlobalObj.TakingMedicineShowFlag=="Y"){
		$('#TakingMedicineMethod').combobox('select',"");
		$('#TakingMedicineMethod').combobox('reload')
	}
	//ChangePrescPrior($("#PrescPrior").combobox('getValue'))
    //CheckCNMedByPrescForm();
    return;
}

///�Ե�ǰ���ڵ�ҽ��������������ת��
function AutoConvertPrescForm(ConvertPrescObj){
	if (typeof ConvertPrescObj == "undefined") ConvertPrescObj={};
	var OrderItemStr="";
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
    var SelPrescTypeCode=DetailsArr[0];
    var CNItemCatStr=DetailsArr[5];
	var OrderItem="",FirstOrderItemCatRowId="";
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
	for(var i=1;i<=rows;i++){
		var Row=i;
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
		   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
		   if (OrderARCIMRowid!=""){
			    var OrderName=GetCellData(i,j,"OrderName");
				var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
				var OrderPhSpecInstr=GetCellData(i,j,"OrderPhSpecInstr");
				//var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text()
				OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderPhSpecInstr+"^"+i+"^"+j;
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
                var OtherItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 3);
                if (("^"+CNItemCatStr+"^").indexOf("^"+OtherItemCatRowid+"^")<0){
                	if (OrderItemStr==""){
	                	OrderItemStr=OrderItem
	                }else{
		            	OrderItemStr=OrderItemStr+String.fromCharCode(1)+OrderItem
		            }
                }
                if (FirstOrderItemCatRowId=="") FirstOrderItemCatRowId=OtherItemCatRowid;
		   }
	    }
	}
	if (OrderItemStr==""){
		SetScreenSum();
		return true;
	}
	var OrderRecDepRowid=$('#RecLoc').combobox("getValue");
	var ConvertInfo=$.cm({
		ClassName:"web.DHCDocOrderEntryCM",
		MethodName:"AutoConvertPrescForm",
		dataType:"text",
		EpisodeID:GlobalObj.EpisodeID,
		OrderItemStr:OrderItemStr,
		PrescTypeCode:SelPrescTypeCode,
		OrderRecDepRowid:OrderRecDepRowid
	},false);
	var ErrInfo=ConvertInfo.split(String.fromCharCode(2))[0];
	var ConvertOrderItemStr=ConvertInfo.split(String.fromCharCode(2))[1];
	if (ConvertOrderItemStr==""){
		CheckCNMedByPrescForm();
		return;
	}
	$.extend(ConvertPrescObj, { ConvertOrderItemStr: ConvertOrderItemStr});
	
	new Promise(function(resolve,rejected){
		if (ErrInfo!="") {
			$.messager.confirm('��ʾ', $g("��⵽ת���������ͳ����쳣:")+ErrInfo+$g(",�Ƿ�ȷ��ת��?"), function(r){
				if (!r) {
					var CMPrescTypeCode=PageLogicObj.PreCMPrescTypeCode;
					$("#CMPrescTypeKW").keywords('select',PageLogicObj.PreCMPrescTypeCode);
					setTimeout(function(){
						//��������δ�л�ǰ��Ĭ��ֵ
						SetPreCMPrescTypeData(CMPrescTypeCode);
					},1000)
					return;
				}
				resolve();
			});
		}else{
			resolve();
		}
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var ConvertOrderItemStr=ConvertPrescObj.ConvertOrderItemStr;
			if (ConvertOrderItemStr.indexOf(String.fromCharCode(3))>=0){
				var ConvertOrderItemStrarry=ConvertOrderItemStr.split(String.fromCharCode(3))
				var ConvertOrderitemlist=ConvertOrderItemStrarry[0];
				var JasoDataConvertOrder=ConvertOrderItemStrarry[1];
				if ($("#ConvertOrderItem").length>0){
					return false;
				}
				var $code ="<div id='kw'></div>" ;
				var buttons=[{
						text:"ȷ��",
						iconCls:'icon-w-save',
						handler:function(){
							ConvertCurrentorderhandle(ConvertOrderitemlist);
						}
					},{
						text:'�ر�',
						iconCls:'icon-w-close',
						handler:function(){
			   				destroyDialog("ConvertOrderItem");
			   				var CMPrescTypeCode=PageLogicObj.PreCMPrescTypeCode;
			   				$("#CMPrescTypeKW").keywords('select',CMPrescTypeCode);
			   				setTimeout(function(){
								//��������δ�л�ǰ��Ĭ��ֵ
								SetPreCMPrescTypeData(CMPrescTypeCode);
							},1000)
						}
					}]
				$("body").append("<div id='"+"ConvertOrderItem"+"' class='hisui-dialog' style='padding:10px'></div>");
				$("#ConvertOrderItem").dialog({
			        title: "��������ת��",
			        width: dw,
			        height: dh,
			        cache: false,
			        iconCls: "icon-w-edit",
			        collapsible: false,
			        minimizable:false,
			        maximizable: false,
			        resizable: false,
			        modal: true,
			        closed: false,
			        closable: false,
			        content:$code,
			        buttons:buttons
			    });
				 $("#kw").keywords({
					singleSelect:false,
		            onClick:function(v){
			            var id=v.id;
			            if (!$("#"+id).hasClass("selected")) return;
			            var row=id.split("-").slice(1,id.split("-").length).join("-");
			            var NewStr=$("#kw").keywords('getSelected')
			            for (i=0;i<NewStr.length;i++){
				            var newId=NewStr[i].id;
				            var newRow=newId.split("-").slice(1,newId.split("-").length).join("-");
				            if ((newRow == row)&&(newId!=id)) {
					            $("#kw").keywords('switchById',newId);
					        }
				        }
			        },
		        	items:eval("("+JasoDataConvertOrder+")")
				 })
			}else{
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			(function(callBackExecFun){
				FocusRowIndex=1,FocusGroupIndex=1;
				var Row="",ColName="";
				function loop(i){
					var ConvertOrderItemStr=ConvertPrescObj.ConvertOrderItemStr;
					var ConvertOrderItemArr=ConvertOrderItemStr.split(String.fromCharCode(1));
					new Promise(function(resolve,rejected){
						var OrdParamsArr=new Array();
						var ParmArr=ConvertOrderItemArr[i].split("^");
						var NewOrderARCIMRowid=ParmArr[0];
						var NewOrderDoseQty=ParmArr[1];
						var OrderPhSpecInstr=ParmArr[2];
						Row=ParmArr[3];
						ColName=ParmArr[4];
						if ((Row=="")||(ColName=="")){
							resolve(false);
						}else if (NewOrderARCIMRowid==""){
							//����ת��ʧ�ܵ�����£������ҽ���׼�¼
							PageLogicObj.m_ARCOSRowId="";
							ClearGroupData(Row,ColName);
							ChangeRowStyle1(Row,ColName,false);
							resolve(false);
						}else{
							//if ((Row!=FocusRowIndex)||(ColName!=FocusGroupIndex)){
								ClearGroupData(Row,ColName);
							//}
							var Para=NewOrderDoseQty+"^"+"^"+OrderPhSpecInstr+"^"+"";
							OrdParamsArr[OrdParamsArr.length]={
								OrderARCIMRowid:NewOrderARCIMRowid,
								ParamS:Para
							};
							AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve);
						}
					}).then(function(rtnValue){
						if (rtnValue==false){
							PageLogicObj.m_ARCOSRowId="";
							ClearGroupData(Row,ColName);
						}else{
							FocusGroupIndex=FocusGroupIndex+1
							if (FocusGroupIndex>GlobalObj.ViewGroupSum){
								FocusRowIndex=FocusRowIndex+1
								FocusGroupIndex=1
							}
						}
						i++;
						if ( i < ConvertOrderItemArr.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		})
	}).then(function(){
		if((PageLogicObj.IsARCOSFormula=="1")&&(PageLogicObj.m_ARCOSRowId!="")){
			PageLogicObj.IsARCOSFormula= $.cm({
				ClassName:"web.UDHCPrescript",
				MethodName:"IsARCOSFormula",
				dataType:"text",
				ARCOSRowid:PageLogicObj.m_ARCOSRowId
			},false);
		}else{
			PageLogicObj.IsARCOSFormula="0";
		}
		PageLogicObj.m_AddItemToListMethod = "LookUp";
		SetScreenSum();
	})
}

function ConvertCurrentorderhandle(ConvertOrderItemStr){
	var NewStr=$("#kw").keywords('getSelected');
	var NewCovertCurrent=""
	for (i=0;i<NewStr.length;i++){
		var Convertorder=NewStr[i].value;
		if (NewCovertCurrent==""){ 
			NewCovertCurrent=Convertorder;
		}else{ 
			NewCovertCurrent=NewCovertCurrent+String.fromCharCode(1)+Convertorder ;
		}
	}
	if (NewCovertCurrent==""){
		$.messager.alert("��ʾ","������ѡ��һ����¼!");  
		return false;
	}else{
		if ($(".kw-section").length>NewCovertCurrent.split(String.fromCharCode(1)).length){
			$.messager.alert("��ʾ","ÿ��ҽ��������ѡ��һ��ת����¼!");  
			return false;
		}
	}
	if (ConvertOrderItemStr!=""){
		ConvertOrderItemStr=ConvertOrderItemStr+String.fromCharCode(1)+NewCovertCurrent;
	}else{
		ConvertOrderItemStr=NewCovertCurrent;
	}
	var ConvertOrderItemArr=ConvertOrderItemStr.split(String.fromCharCode(1));
	FocusRowIndex=1,FocusGroupIndex=1
	var OrdParamsArr=new Array();
	for (var i=0,Length=ConvertOrderItemArr.length;i<Length;i++){
		var ParmArr=ConvertOrderItemArr[i].split("^");
		var NewOrderARCIMRowid=ParmArr[0];
		var NewOrderDoseQty=ParmArr[1];
		var OrderPhSpecInstr=ParmArr[2];
		var Row=ParmArr[3];
		var ColName=ParmArr[4];
		if ((Row=="")||(ColName=="")){
			continue;
		}
		//if ((Row!=FocusRowIndex)||(ColName!=FocusGroupIndex)){
			ClearGroupData(Row,ColName);
		//}
		///ת��ʧ�ܣ�����������Ԫ��
		if (NewOrderARCIMRowid==""){
			//����ת��ʧ�ܵ�����£������ҽ���׼�¼
			PageLogicObj.m_ARCOSRowId="";
			ClearGroupData(Row,ColName);
			ChangeRowStyle1(Row,ColName,false);
			continue;
		}
		var Para=NewOrderDoseQty+"^"+"^"+OrderPhSpecInstr+"^"+"";
		OrdParamsArr[OrdParamsArr.length]={
			OrderARCIMRowid:NewOrderARCIMRowid,
			ParamS:Para
		};
	}
	new Promise(function(resolve,rejected){
		AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve); 
	}).then(function(rtnValue){
		if (rtnValue==false) {
			ClearGroupData(FocusRowIndex,FocusGroupIndex);
		}else{
			if((PageLogicObj.IsARCOSFormula=="1")&&(PageLogicObj.m_ARCOSRowId!="")){
				PageLogicObj.IsARCOSFormula= $.cm({
					ClassName:"web.UDHCPrescript",
					MethodName:"IsARCOSFormula",
					dataType:"text",
					ARCOSRowid:PageLogicObj.m_ARCOSRowId
				},false);
			}else{
				PageLogicObj.IsARCOSFormula="0";
			}
			PageLogicObj.m_AddItemToListMethod = "LookUp";
			SetScreenSum();
		}
		destroyDialog("ConvertOrderItem");
	})
}
///�жϵ�ǰ�������ͺ��б��е�ҩƷ�����Ƿ�һ��
function CheckCNMedByPrescForm(){
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
    var SelPrescTypeCode=DetailsArr[0];
    var CNItemCatStr=DetailsArr[5];
    new Promise(function(resolve,rejected){
		CheckCNMedSameDrugForm(CNItemCatStr,"Y","","Y",resolve);
	}).then(function(Paramsobj){
		 if (!Paramsobj.ret) {
		    //Э������Ӧ��Ҫά�������Ĵ������ͲŶ԰�
	        if (dhcsys_confirm(t['IsNeedNewPresc'])) {
	            if (PageLogicObj.m_AddItemToListMethod ==""){
	                ClearList();
	                 FocusRowIndex = 1;
	                 FocusGroupIndex = 1;
	                 PageLogicObj.m_AddItemToListMethod = "LookUp";
	                 SetScreenSum();
	            }else{
	                ClearList();
	            }
	            $("#PrescList").combobox('select','');
	            
	            var SessionFieldName = "UserUnSaveDataCM" + GlobalObj.EpisodeID;
	            $.cm({
					ClassName:"web.DHCDocOrderEntry",
					MethodName:"SetUserCMUnSaveData",
					dataType:"text",
					wantreturnval:0,
					Name:SessionFieldName, 
					Value:""
				},false);
				PageLogicObj.m_ARCOSRowId="";
				PageLogicObj.IsARCOSFormula=0;
	            ClearClickHandler();
	        } else {
	            var ItemCatRowid=Paramsobj.ItemCatRowid;
	            var PrescTypeIndex=GetCNMedPrescTypeIndex(ItemCatRowid);
	            $("#CMPrescTypeKW").keywords('select',PrescTypeIndex);
	            resolve(false);
	        }
		}else{
			resolve(true);
		}
	}).then(function(){
		
	})
}
function CheckCNMedSameDrugForm(CNItemCatStr,CheckAllFlag,idesc,AlertFlag,callBackFun) {
	var ReturnObj={ ret: true,ItemCatRowid:""};
	new Promise(function(resolve,rejected){
		if (CNItemCatStr == ""){
			resolve();
		}else{
			var CurrCellPos = FocusRowIndex + "^" + FocusGroupIndex;
			var rows=$('#CMOrdEntry_DataGrid').getGridParam("records"); 
			(function(callBackExecFun){
				function loop(i){
					var Row=i;
					new Promise(function(resolve,rejected){
						(function(callBackExecFunExc){
							function loopCol(j){
								new Promise(function(resolve,rejected){
									var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
								    var OrderName=GetCellData(i,j,"OrderName");
								    var CellPos = i + "^" + j;
								    if ((OrderARCIMRowid != "") && ((CellPos != CurrCellPos) || (CheckAllFlag == "Y"))) {
									    var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
                						var OtherItemCatRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 3);
                						if (("^"+CNItemCatStr+"^").indexOf("^"+OtherItemCatRowid+"^")<0){
	                						if (AlertFlag=="Y"){
								                if (idesc == "") {
									                var AlertMag=OrderName + ",��ͬ�������Ͳ���ͬʱ��";
							                    } else {
								                    var AlertMag=OrderName + "," + "��¼��ҩƷ(" + idesc + ")" + "�Ĵ������Ͳ�һ��!";
							                    }
							                    $.messager.alert("��ʾ",AlertMag,"info",function(){
							                        $.extend(ReturnObj, { ret: false,ItemCatRowid:OtherItemCatRowid});
							                        resolve();
							                    });
							                    return;
							                }
	                					}
									}
									resolve();
								}).then(function(){
									j++;
									if ( j <= GlobalObj.ViewGroupSum ) {
										 loopCol(j);
									}else{
										callBackExecFunExc();
									}
								})
							}
							loopCol(0);
						})(resolve);
					}).then(function(){
						i++;
						if ( i <= rows ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		}
	}).then(function(){
		callBackFun(ReturnObj);
	})
}
function SetPrescAppenItemQty(){
	var PrescCookDecoctionFlag = 0;
	var sbox=$HUI.checkbox("#PrescCookDecoction"); //����checkbox
	if (sbox.getValue()){ 
		PrescCookDecoctionFlag = 1;
	}
	if ($("#CMOrderOpenForAllHosp").length==1){
		var CMOrderOpenForAllHospFlag=$("#CMOrderOpenForAllHosp").checkbox('getValue')?1:0;
	}else{
		var CMOrderOpenForAllHospFlag=0;
	}
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");    
    var CMRecLocStr=DetailsArr[6];
    var CNMedCookReclocStr=DetailsArr[7];
    var OpenHospCMRecLocStr=DetailsArr[15];
    var OpenHospCNMedCookReclocStr=DetailsArr[16];
    /*var RecLocStr="";
    if (CMOrderOpenForAllHospFlag==1) {
	    if ((PrescCookDecoctionFlag==1)&&(OpenHospCNMedCookReclocStr!="")){
	        RecLocStr=OpenHospCNMedCookReclocStr;
	    }else{
	        RecLocStr=OpenHospCMRecLocStr;
	    }
	}else{
	    if ((PrescCookDecoctionFlag==1)&&(CNMedCookReclocStr!="")){
	        RecLocStr=CNMedCookReclocStr;
	    }else{
	        RecLocStr=CMRecLocStr;
	    }
    }
    var CookMode=$('#CookModelist').combobox('getValue'); 
    var CookModelist=$('#CookModelist').combobox('getData'); 
    var CookIndex=$.hisui.indexOfArray(CookModelist,"RowID",CookMode);
    if (CookIndex>=0) {
	    var OpenHospCookModeReclocStr=CookModelist[CookIndex].OpenHospCookModeReclocStr;
	    var CookModeReclocStr=CookModelist[CookIndex].CookModeReclocStr;
	    if (CMOrderOpenForAllHospFlag==1) {
		    if (OpenHospCookModeReclocStr!="") RecLocStr=RecLocStr+"!"+OpenHospCookModeReclocStr;
		}else{
			if (CookModeReclocStr!="") RecLocStr=RecLocStr+"!"+CookModeReclocStr;
		}
	}
    RecLocStr=RecLocStr.replace(/[!]/g, String.fromCharCode(2))
    RecLocStr=RecLocStr.replace(/[@]/g, String.fromCharCode(1))
    SetRecLoc(RecLocStr);*/
    SetRecLoc();
    
    ///�л��������ͻᴥ��SetPrescAppenItemQty��
    ///��������д�������ת������֤��ȡ����ȷ�Ľ��ܿ���
    AutoConvertPrescForm();
    var CNMedAppendItemQtyCalcu=DetailsArr[8];
    var CNMedAppendItem=DetailsArr[11];
    if ((CNMedAppendItem == "")||(PrescCookDecoctionFlag==0)) {
	     $("#PrescAppenItemQty,#CPrescAppenItemQty").hide();
	     $("#PrescAppenItemQty").val(0);
	}else{
	    $("#PrescAppenItemQty,#CPrescAppenItemQty").show();
		var PrescDurationFactor = 0;
		if (CNMedAppendItemQtyCalcu == 1) {
			PrescDurationFactor=1;
		}
		$("#PrescAppenItemQty").val(PrescDurationFactor);
	}
}
function mPiece(s1,sep,n) {
    delimArray = s1.split(sep);
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}
function ResetPrescOrderQty(OrderQtyTextOrValue){
    var OrderInstrRowid = $HUI.combobox("#PrescInstruction").getValue();
    var jsonData=$.cm({
	    ClassName:"DHCDoc.DHCDocConfig.CMDocConfig",
	    QueryName:"FindInstrLinkOrderQty",
	    InstrucRowId:OrderInstrRowid,
	    page:1,  
		rows:200
	},false);
	$HUI.combobox("#PrescOrderQty",{
		data:jsonData.rows,
		onLoadSuccess:function(){
			var sbox = $HUI.combobox("#PrescOrderQty");
			if (OrderQtyTextOrValue==""){
				if (jsonData.rows[0]) sbox.select(jsonData.rows[0].Code);
			}else{
				//sbox.select(OrderQtyTextOrValue);
				var find=0
				for(var i=0;i<jsonData.rows.length;i++){
					if(jsonData.rows[i].Code==OrderQtyTextOrValue){
						find=1
						sbox.select(OrderQtyTextOrValue);
						break;	
					}
				}
				if(find==0){
					sbox.select(''); //jsonData.rows[0].Code	
				}
			}
		}
	})
}
function SetRecLoc(CMRecLocStr) {
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
	var CMPrescTypeCode=DetailsArr[0];
	var OrdParamObj={
	    EpisodeID:GlobalObj.EpisodeID,
	    CMPrescTypeCode:CMPrescTypeCode,
	    OrderOpenForAllHosp:$("#CMOrderOpenForAllHosp").checkbox('getValue')?1:0,
	    CNMedCookModeRowId:$("#CookModelist").combobox('getValue'), 
	    OrderPriorRowid:$('#PrescPrior').combobox('getValue'), 
	    LogonHospID:session['LOGON.HOSPID'],
	    OrderDateStr:$("#PrescStartDate").val(),
	}
	var OrdParamJson=JSON.stringify(OrdParamObj);
    var CalRecLocStrJson = tkMakeServerCall("web.DHCDocOrderCommon","GetCMRecLocStr", OrdParamJson)
    var CalRecLocStrObj=eval("(" + CalRecLocStrJson + ")");
    var CMRecLocStr=CalRecLocStrObj.CMRecLocStr;
    
	var defLocId="";
	var RecLocStrArr=new Array();
	var ArrData = CMRecLocStr.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        var id=ArrData1[0];
		var desc=ArrData1[1];
		if ((ArrData1[2] == "Y")&&(defLocId=="")) { defLocId=id;}
		if ($.hisui.indexOfArray(RecLocStrArr,"id",id)<0) {
			RecLocStrArr.push({"id":id, "desc":desc});
		}
    }
    $HUI.combobox("#RecLoc",{
		data:RecLocStrArr,
		onLoadSuccess:function(){
			var sbox = $HUI.combobox("#RecLoc");
			if (defLocId==""){
				defLocId=RecLocStrArr[0].id;
			}
			sbox.select(defLocId);
		}
	});
}
function PrescDurationLookupSelect(value){
	//SetPrescAppenItemQty();
    SetScreenSum();
}
function PrescListChange(value,copyFlag){
	//PrescList_changehandler
	ClearClickHandler();
	var selPrescNo=value.split("^")[0];
	$.m({
	    ClassName:"web.UDHCPrescript",
	    MethodName:"GetPrescListDate",
	    PrescNo:selPrescNo
	},function(PrescListDate){
		if (PrescListDate=="") return false;
		var PrescListArr=PrescListDate.split(String.fromCharCode(12));
		var PrescListArr1=PrescListArr[1].split("^");
		var Data=$("#CMPrescTypeKW").keywords('options').items;
		for (var i=0;i<Data.length;i++){
			var CMPrescTypeCode=Data[i].id;
			if (CMPrescTypeCode==PrescListArr1[14]){
				$("#CMPrescTypeKW").keywords('select',CMPrescTypeCode);
				break;
			}
		}
		var TempArr = PrescListArr1[0].split(String.fromCharCode(2)); 
		SetComboValue('PrescDuration',TempArr[1]);
		var TempArr = PrescListArr1[1].split(String.fromCharCode(2));
		SetComboValue('PrescInstruction',TempArr[1]);
		ResetPrescOrderQty(PrescListArr1[5]);
		var TempArr = PrescListArr1[4].split(String.fromCharCode(2));
		SetComboValue('PrescFrequence',TempArr[1]);
		var cbox=$HUI.checkbox("#PrescCookDecoction") //����checkbox
		if ((PrescListArr1[2]=="02")||(PrescListArr1[2]=="����")){
			cbox.setValue(true);
		}else{
			cbox.setValue(false);
		}
		var sbox = $HUI.combobox("#RecLoc");
			sbox.select(PrescListArr1[3]);
		if (selPrescNo.indexOf("I")<0){
			var sbox = $HUI.combobox("#PrescPrior");
				sbox.select(PrescListArr1[6]);
		}
		$('#PrescOrderQty').combobox('setText',PrescListArr1[5]);
		$("#PrescAppenItemQty").val(PrescListArr1[8]);
		$("#PrescNotes").val(PrescListArr1[9]);
		$("#PrescEmergency").val(PrescListArr1[10]);
		if (PrescListArr1[10]=="Y"){
			$("#PrescUrgent").checkbox('setValue',true);
		}else{
			$("#PrescUrgent").checkbox('setValue',false);	
		}
		if(!copyFlag){
			$("#PrescStartDate").val(PrescListArr1[11]);
			//$("#StartDate").val(PrescListArr1[11]);
			$("#EndDate").val(PrescListArr1[12]);
		}
		PageLogicObj.m_ARCOSRowId=PrescListArr1[13];
		$("#ARCOSRowId").val(PrescListArr1[13]);
		SetPrescAppenItemQty();
		setTimeout(function(){
			SetComboValue('CookModelist',PrescListArr1[2]);
		})
		if (PrescListArr[0] != "") {
			var ARCIMARCOSRowid=PrescListArr1[13];
		    var ParaArr = PrescListArr[0].split(String.fromCharCode(2));
            AddCopyItemToList(ParaArr);
		}
		if (GlobalObj.TakingMedicineShowFlag=="Y"){
			SetComboValue('TakingMedicineMethod',PrescListArr1[15]);
		}
		var AddLongOrderID=PrescListArr1[16];
		SetComboValue('AddLongOrderList',AddLongOrderID);
		var PrescPriorRowid=PrescListArr1[17];
		SetComboValue('PrescPrior',PrescPriorRowid);
	});
}
function PrescCookDecoctionClick(e,value){
	setTimeout(function(){
		SetPrescAppenItemQty();
	})
}
function DrugAndQtyEntryModeChange(e,value){
   var DrugAndQtySplit = 0;
   var id=e.target.id;
   if (id=="DrugAndQtyYQ"){
       if (value){
           $HUI.checkbox("#DrugAndQtySplit").setValue(false);
       }else{
	       $HUI.checkbox("#DrugAndQtySplit").setValue(true);
	       DrugAndQtySplit=1;
	   }
   }else{
       if (value){
           $HUI.checkbox("#DrugAndQtyYQ").setValue(false);
           DrugAndQtySplit=1;
       }else{
	       $HUI.checkbox("#DrugAndQtyYQ").setValue(true);
	   }
   }
   $.m({
	    ClassName:"web.DHCDocConfig",
	    MethodName:"SaveConfig1",
	    Node:"CMDrugAndQtySplit",
	    Node1:session['LOGON.USERID'], 
	    NodeValue:DrugAndQtySplit
	},function(val){
	});
}
function ClearClickHandler(){
	
	deleteallrow()
	Add_CMOrdEntry_row();
	/*
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for (var i=1;i<=rows;i++){
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
			ClearGroupData(i,j);
			ChangeRowStyle1(i,j,false);
		}
	}
	*/
	PageLogicObj.IsARCOSFormula=0;
	PageLogicObj.m_ARCOSRowId="";
	SetFocusColumn("OrderName1",1);
	var SessionFieldName="UserUnSaveDataCM"+GlobalObj.EpisodeID;
	$.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"SetUserCMUnSaveData",
		dataType:'text',
		wantreturnval:0,
		Name:SessionFieldName, 
		Value:""
	},false);
	PageLogicObj.PractiacRowStr=""
	SetScreenSum();
}


function deleteallrow(){
	var rowids = $('#CMOrdEntry_DataGrid').getDataIDs();
    for (var i = 0; i < rowids.length; i++) {
      var rowid=rowids[i]
      $('#CMOrdEntry_DataGrid').delRowData(rowid);
    }
}
function checkIsExistOtherOrd(){
	var Count=0;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for (var i=1;i<=rows;i++){
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
			var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
			if (OrderARCIMRowid!=""){
				Count++;
			}
			ChangeRowStyle1(i,j,true);
		}
	}
	return Count;
}
function ChangeRowStyle1(Row,Col,disabled){
    if(disabled){
		if (GlobalObj.FormulaCanAppendItem=="0"){
			$("input[id*='_OrderName']").attr("readonly","readonly");
			if (GlobalObj.FormulaCanChangeDose=="0") {
				$("input[id*='_OrderDoseQty']").attr("readonly","readonly");
			}
		}else{
			$("#"+Row+"_OrderName"+Col).attr("readonly","readonly")
	        if (GlobalObj.FormulaCanChangeDose=="0") {
				$("#"+Row+"_OrderDoseQty"+Col).attr("readonly","readonly")
			}
		}
    }else{
	    if (GlobalObj.FormulaCanAppendItem=="0"){
			$("input[id*='_OrderName']").removeAttr("readonly");
			$("input[id*='_OrderDoseQty']").removeAttr("readonly");
		}else{
	        $("#"+Row+"_OrderName"+Col).removeAttr("readonly");
	        $("#"+Row+"_OrderDoseQty"+Col).removeAttr("readonly");
		}
    }
    
    
}
function DisableDeleteButton(Disable){
    var delObj = document.getElementById("Delete");
    if ((delObj) && (Disable == "1")) {
        delObj.disabled = true;
        delObj.onclick = "";
        if (tsc['Update']) { websys_sckeys[tsc['Delete']] = ""; }
    }
    if ((delObj) && (Disable == "0")) {
        delObj.disabled = false;
        delObj.onclick = DeleteClickHandler;
        if (tsc['Delete']) { websys_sckeys[tsc['Delete']] = DeleteClickHandler; }
    }
}
function AddCopyItemToList(ParaArr){
	SetTimeLog("AddCopyItemToList","start");
	var OrderARCOSRowid="";
	var ARCOSFormulaExistFlag=0,NotARCOSFormulaFlag=0;
	var OrdParamsArr=new Array();
	new Promise(function(resolve,rejected){
		//������ҽ����Ϣ�ϲ���һ����������
		(function(callBackExecFun){
			function loop(i){
				new Promise(function(resolve,rejected){
					var Para1Str=ParaArr[i];
					var para1Arr = Para1Str.split("!")
					var Para = para1Arr[2];
					OrderARCOSRowid = Para.split("^")[6];
					if ((typeof OrderARCOSRowid == "undefined") || (OrderARCOSRowid == "undefined")) {
						OrderARCOSRowid="";
					}
					CheckFormulaCanAppendItem(OrderARCOSRowid,resolve);
				}).then(function(rtn){
					return new Promise(function(resolve,rejected){
						if (rtn) {
							Para1Str=ParaArr[i];
							para1Arr = Para1Str.split("!")
							icode = para1Arr[0];
							CheckDiagnose(icode,resolve);
						}else if(OrdParamsArr.length>0){
							callBackExecFun();
						}
					})
				}).then(function(rtn){
					return new Promise(function(resolve,rejected){
						if (rtn) {
							Para1Str=ParaArr[i];
							para1Arr = Para1Str.split("!")
							icode = para1Arr[0];
							seqno = para1Arr[1];
							Para = para1Arr[2];
							var ItemOrderType = para1Arr[3];
							OrderARCOSRowid = Para.split("^")[6]; //para1Arr[8];
							if ((typeof OrderARCOSRowid == "undefined") || (OrderARCOSRowid == "undefined")) {
								OrderARCOSRowid="";
							}
							if (OrderARCOSRowid!=""){
								PageLogicObj.IsARCOSFormula = $.cm({
									ClassName:"web.UDHCPrescript",
									MethodName:"IsARCOSFormula",
									dataType:"text",
									ARCOSRowid:OrderARCOSRowid
								},false);
								PageLogicObj.m_ARCOSRowId=OrderARCOSRowid;
								if (PageLogicObj.IsARCOSFormula=="1") ARCOSFormulaExistFlag=1;
								else NotARCOSFormulaFlag=1;
							}else{
								NotARCOSFormulaFlag=1;
							}
							var ITMRowId=mPiece(Para, "^", 13);
							OrdParamsArr[OrdParamsArr.length]={
								OrderARCIMRowid:icode,
								ParamS:Para,
								OrderBillTypeRowid:GlobalObj.OrderBillTypeRowid,
								ITMRowId:ITMRowId
							};
							resolve();
						}else if(OrdParamsArr.length>0){
							callBackExecFun();
						}
					})
				}).then(function(){
					i++;
					if ( i < ParaArr.length ) {
						 loop(i);
					}else{
						callBackExecFun();
					}
				})
			}
			loop(0);
		})(resolve);
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if ((ARCOSFormulaExistFlag=="1")&&(NotARCOSFormulaFlag=="1")&&(GlobalObj.FormulaCanAppendItem=="0")){
				$.messager.alert("��ʾ","Э����������������ҽ��һ����!");
				PageLogicObj.IsARCOSFormula=0;
				return false;
			}
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")){
					var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
					var GroupList=[];
					for(var i=1;i<=rows;i++){
						for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
						   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
						   if (OrderARCIMRowid!=""){
							   GroupList.push(i+"^"+j);
						   }
						}
					}
					if (GroupList.length>0){
			        	$.messager.alert("��ʾ","Э���������������ͨҩƷ�쿪!","info",function(){
			            	for (var i=0;i<GroupList.length;i++) {
			                	ClearGroupData(GroupList[i].split("^")[0],GroupList[i].split("^")[1]);
			                }
			                FocusRowIndex=1;
			                FocusGroupIndex=1;
			                resolve();
			            });
			        }else{
			            resolve();
			        }
			}else{
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve);
		})
	}).then(function(RtnObj){
		if (RtnObj==true){
			setTimeout(function(){ 
				SetScreenSum();
		     }, 100); 
		}else{
			PageLogicObj.IsARCOSFormula=0;
		}
	})
}
function FindNullCell(){
	var amount=0;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for (var i=1; i<=rows; i++){
		var Row=i;
		for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
			var OrderItemRowid=$("#"+i+"_OrderItemID"+j+"").val(); 
			if ((OrderARCIMRowid=="")&&(OrderItemRowid=="")){
				var FocusCellName="OrderName"+j+"z"+i;
				FocusRowIndex=i;
				FocusGroupIndex=j;
  			    return true;
			}
		}
	}
	FocusRowIndex=Add_CMOrdEntry_row()
	FocusGroupIndex=1;
	return true;
}
function NewClickHandler(){
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for (var i=1;i<=rows;i++){
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
			ClearGroupData(i,j);
			ChangeRowStyle1(i,j,false); 
		}
	}
	var SessionFieldName="UserUnSaveDataCM"+GlobalObj.EpisodeID;
	$.cm({
		ClassName:"web.DHCDocOrderEntry",
		MethodName:"SetUserCMUnSaveData",
		dataType:'text',
		wantreturnval:0,
		Name:SessionFieldName, 
		Value:""
	},false);
	//ReloadFrame();
	ReloadFrameData();
	SetScreenSum();
	InitDateFlatpickr();
}
function ReloadFrame() {
	window.location.reload();
}
function headerDblClick(){
	if(GlobalObj.lookupListComponetId != ""){	
		$.m({
		    ClassName:"web.SSGroup",
		    MethodName:"GetAllowWebColumnManager",
		    Id:session['LOGON.GROUPID']
		},function(flag){
			if (flag==1) websys_lu('../csp/websys.component.customiselayout.csp?ID='+GlobalObj.lookupListComponetId+'&CONTEXT=K'+GlobalObj.ListColSetCls+'.'+GlobalObj.ListColSetMth+'.'+GlobalObj.XCONTEXT+"&GETCONFIG=1"+"&DHCICARE=2",false);
		});
	}
}
function Delete_CMOrdEntry_row(Confirm){
	if ($("#Delete_Order_btn").hasClass('l-btn-disabled')){
		return false;
	}
	if ((FocusGroupIndex==0)||(FocusRowIndex==0)){
		$.messager.alert("��ʾ","��ѡ��Ҫɾ���ļ�¼");  
		return false;
	}
	var OrderHiddenPara=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderHiddenPara");
	if (OrderHiddenPara!=""){
        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
        PageLogicObj.IsARCOSFormula = $.cm({
			ClassName:"web.UDHCPrescript",
			MethodName:"IsARCOSFormula",
			dataType:"text",
			ARCOSRowid:ARCIMARCOSRowid
		},false);
        if (PageLogicObj.IsARCOSFormula=="1"){
	        var OrderName = $("#"+FocusRowIndex+"_OrderName"+FocusGroupIndex+"").val(); 
	        $.messager.alert("��ʾ",OrderName+$g("����Э�������ڵ�ҽ��,�������!"));
	        return false;
	    }
    }
    if (Confirm=="N"){
		DeleteEntryRow();
	}else{
		$.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ��ѡ�еļ�¼��', function(r){
			if (r){
			   DeleteEntryRow();
			}
		});	
	}
   
	function DeleteEntryRow(){
		 if((FocusGroupIndex!=0)&&(FocusRowIndex!=0)){
			ClearGroupData(FocusRowIndex,FocusGroupIndex);
		}
		setTimeout(function(){ 
				SetScreenSum(); //ɾ����ͬ��������
		     }, 100); 
		//SetScreenSum(); //ɾ����ͬ��������
		return websys_cancel();	
	}
}

///����Ϊҽ����
var ARCOSArcIMRowIdStr="";
function SaveToArcos_Click(){
	ARCOSArcIMRowIdStr=GetArcimStr()
	if (ARCOSArcIMRowIdStr==""){
		$.messager.alert("��ʾ", "û����Ҫ����Ϊҽ���׵�ҽ��!");
		return false;
	}
	UDHCOEOrderDescSetLink();
}
function SaveItemToARCOS(RtnStr){
	CloseDialog("CMARCOSMan");
	if (RtnStr=="") return false;
	var ArcosRowid=RtnStr.split("^")[0];
	if (ArcosRowid!=""){
		AddTOArcosARCIM(ArcosRowid,ARCOSArcIMRowIdStr);
	}else{
		$.messager.alert("��ʾ", "����ʧ��!");
		return false;
	}
}
function GetArcimStr(){
	var ArcimStr="",OrderItem="";
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for(var i=1;i<=rows;i++){
		var Row=i;
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
		   var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val(); 
		   if (OrderARCIMRowid!=""){
				var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();
				var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text();
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
                var PHCDoseUOMRowid=OrderHiddenPara.split(String.fromCharCode(3))[10];
			    OrderItem=OrderARCIMRowid+String.fromCharCode(1)+OrderDoseQty+String.fromCharCode(1)+OrderPhSpecInstr+String.fromCharCode(1)+PHCDoseUOMRowid;
				if (ArcimStr==""){
					ArcimStr=OrderItem
				}else{
					ArcimStr=ArcimStr+"^"+OrderItem
				}
		   }
	    }
	}
	return ArcimStr;
}
///����ҽ��������
function UDHCOEOrderDescSetLink(){
	websys_showModal({
		url:"udhcfavitem.edit.hui.csp?TDis=1&CMFlag=Y&PreCMPrescTypeCode="+PageLogicObj.CurCMPrescTypeCode, //&HospARCOSAuthority=1", //udhcfavitem.edit.new.csp
		title:'ҽ����ά�� <font color="#FF1A00">��ʾ��������ҽ�������Ҽ������������;�豣�浽�Ѵ��ڵ�ҽ������,��˫����Ӧ��</font>',
		width:760,height:screen.availHeight-200,
		iconCls:'icon-w-list',
		SaveItemToARCOS:SaveItemToARCOS
	});
}
///��Ӧ��ҽ����ҽ������
function AddTOArcosARCIM(Arcosrowid,ArcimStr){
     if(Arcosrowid==""){return false;}
     var ArcimStrArray=ArcimStr.split("^");
     for (var i=0;i<ArcimStrArray.length;i++){
	     var OrderARCIMRowid=mPiece(ArcimStrArray[i],String.fromCharCode(1),0);
	     var OrderDoseQty=mPiece(ArcimStrArray[i],String.fromCharCode(1),1);
	     var OrderPhSpecInstr=mPiece(ArcimStrArray[i],String.fromCharCode(1),2);
	     var PHCDoseUOMRowid=mPiece(ArcimStrArray[i],String.fromCharCode(1),3);
	     var ret = $.cm({
			ClassName:"web.DHCARCOrdSets",
			MethodName:"InsertItem",
			dataType:"text",
			ARCOSRowid:Arcosrowid, ARCIMRowid:OrderARCIMRowid, 
			ItemQty:"", ItemDoseQty:OrderDoseQty, 
			ItemDoseUOMID:PHCDoseUOMRowid, ItemFrequenceID:"", 
			ItemDurationID:"", ItemInstructionID:"", 
			ItmLinkDoctor:"", remark:OrderPhSpecInstr, DHCDocOrderTypeID:"", 
			SampleId:"", ARCOSItemNO:"", OrderPriorRemarksDR:"", DHCDocOrderRecLoc:"", ExpStr:""
		},false);
	 }
	 $.messager.popover({msg: '����ɹ���',type:'success'});
	 return false;	
}
function UpdateClickHandler() {
	if ($("#Update").hasClass('l-btn-disabled')){
		return false;
	}
	DisableBtn("Update",true);
	var warning=tkMakeServerCall("web.DHCDocOrderCommon","OrderLock",GlobalObj.orderrow,GetSessionStr(),"User.OEOrder","");
	if (warning!=""){
		$.messager.alert("��ʾ", warning,"info",function(){
			UpdateClickHandlerFinish();
		});
		return;
	}
	if (typeof UpdateObj == "undefined") UpdateObj={};
	$.extend(UpdateObj, { UpdateFlag: false});
	new Promise(function(resolve,rejected){
		//����ǩ��
		var CAInputObj={
			callType:"OrderSave",
			isHeaderMenuOpen:true
		}
		Common_ControlObj.BeforeUpdate("CASignCheck",CAInputObj,resolve);
	}).then(function(RtnObj){
		return new Promise(function(resolve,rejected){
	    	if (RtnObj == false || RtnObj.PassFlag == false) {
		    	UpdateClickHandlerFinish();
	    		return websys_cancel();
	    	}
	    	$.extend(UpdateObj, RtnObj.CAObj);
	    	resolve(true);
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			GetOrderDataOnAdd(resolve);
		})
	}).then(function(OrderItemStr){
		return new Promise(function(resolve,rejected){
			if (OrderItemStr=="") {
				$.messager.alert("��ʾ", t['NO_NewOrders']);
				UpdateClickHandlerFinish();
				return false;
			}
			$.extend(UpdateObj, { OrderItemStr: OrderItemStr});
			resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			//����ǰ�ĺ�̨���,����ҽ��¼��Ǳ���ǰ�˴�����ж��߼������ڴ˴���
			CheckBeforeSaveToServer(UpdateObj.OrderItemStr,resolve);
		})
	}).then(function(ret){
		return new Promise(function(resolve,rejected){
			if (ret.SuccessFlag == false) {
		        UpdateClickHandlerFinish();
		        return websys_cancel();
		    }
		    if (ret.isAfterCheckLoadDataFlag== true){
				return new Promise(function(resolve,rejected){
					GetOrderDataOnAdd(resolve);
				}).then(function(OrderItemStr){
					if (OrderItemStr == "") {
					    $.messager.alert("��ʾ", t['NO_NewOrders']);
					    UpdateClickHandlerFinish();
					    return websys_cancel();
				    }
					$.extend(UpdateObj, { OrderItemStr: OrderItemStr});
					resolve();
				})
			}else{
				resolve();
			}
		})
	}).then(function(){
		//��ǰ���ɴ����š�����ţ����Ե��ú�����ҩ
		return new Promise(function(resolve,rejected){
			 (function(callBackFunExec){
				var SessionStr = GetSessionStr();
				$.cm({
				    ClassName:"web.DHCDocPrescript",
				    MethodName:"CreatOrdNo",
				    EpisodeID:GlobalObj.EpisodeID,
				    OrdItemStr:UpdateObj.OrderItemStr,
				    SessionStr:SessionStr,
				    LabEpisArray:"",
				    PrescType:"CM",
				    dataType:"text"
				},function(NewOrderItemStr){
					if (NewOrderItemStr==""){
						$.messager.alert("��ʾ", "Ԥ���ɴ���ʧ��","info",function(){
						    UpdateClickHandlerFinish();
						});
					    return websys_cancel();
					}
					$.extend(UpdateObj, { OrderItemStr: NewOrderItemStr});
					callBackFunExec();
				});
			})(resolve)
		 })
	}).then(function(){
		return new Promise(function(resolve,rejected){
			/*if (GlobalObj.HLYYInterface==1){
				try{
					GlobalObj.DHCHLYYInfo="";
					HYLLUpdateClick_HLYY(resolve,UpdateObj.OrderItemStr,"Check");
				}catch(e){
					$.messager.confirm('ȷ�϶Ի���', "������ҩϵͳ�쳣:"+e.message+"<br/>����ϵ��Ϣ��!��ȷ�����ҽ��������ȷ����", function(r){
						if (r) {
							resolve(true);
						}else{
							UpdateClickHandlerFinish();
						}
					})
				}
			}else{
				resolve(true);
			}*/
			var myInputObj={
				EpisodeID:GlobalObj.EpisodeID,
				OrderItemStr:UpdateObj.OrderItemStr,
				CallBackFunc:resolve
			}
			Common_ControlObj.BeforeUpdate("Interface",myInputObj,resolve);
		})
	}).then(function(ret){
		return new Promise(function(resolve,rejected){
			if (ret==false || ret.SuccessFlag==false) {
				UpdateClickHandlerFinish();
		        return websys_cancel();
			}else{
				if(ret.UpdateFlag){
					$.extend(UpdateObj, { OrderItemStr: ret.UpdateOrderItemStr});	
				}
			}
			//��Ҫǩ������
			if (GlobalObj.CMOrdDirectSave=="1"){ 
				ShowInputPinNum(resolve);
			}else{
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			// ʵϰ�����ҽ��
		    if (GlobalObj.practiceFlag=="1"){
			    var UpdatePracticeRtn=InsertPriceAdd();
				if (UpdatePracticeRtn){
				    UpdateClickHandlerFinish();
				    NewClickHandler();
				    AfterUpdate();
		    		return true;
				}else{
					UpdateClickHandlerFinish();
				    return false
				}
			    return;
			}
			var OEOrdItemIDs=SaveOrderItems(UpdateObj.OrderItemStr);
			if (OEOrdItemIDs=="100") {
				$.messager.alert("��ʾ",t['Fail_SaveOrder'],"info",function(){
					UpdateClickHandlerFinish();
				});
				return false;
			}
			$.extend(UpdateObj, { OEOrdItemIDs: OEOrdItemIDs});
			//��˺����
			$.extend(UpdateObj,{
				EpisodeID:GlobalObj.EpisodeID,
				DHCHLYYInfo:GlobalObj.DHCHLYYInfo
			})
			Common_ControlObj.AfterUpdate("SynData",UpdateObj);		//����ͬ����CA��
			Common_ControlObj.AfterUpdate("Interface",UpdateObj);	//�������ӿڵ���
			//���ڱ���ҽ��ʱ��̨����,�˴������ظ�����
			//¼��ҽ����ʱ���жϵ���״̬;��δ��������Ϊ����
			$.extend(UpdateObj, { ExistFlag: 0,StopPrescNo:"",UpdateFlag:true});
			if (GlobalObj.PAAdmType!="I"){
				////���ʱ��ʾ���Ƿ�Ҫɾ��ԭ����
				var selVal=$('#PrescList').combobox("getValue");
				if (selVal!=""){
					var PrescNo=selVal.split("^")[0];
					if (PrescNo!=""){
						var rtn = $.cm({
							ClassName:"web.UDHCPrescript",
							MethodName:"CheckStopPrescNo",
							dataType:"text",
							PrescNo:PrescNo, UserID:session['LOGON.USERID'],EpisodeID:GlobalObj.EpisodeID
						},false);
						var rtnArr=rtn.split("^")
						if (rtnArr[0]==0){
							$.extend(UpdateObj, { StopPrescNo: PrescNo});
						}
					}
				}
			}
			resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if (UpdateObj.StopPrescNo!=""){
				$.messager.confirm('��ʾ', UpdateObj.StopPrescNo+$g("-�Ƿ�ֹͣԭ�����ţ�"), function(r){
					if (r){
					    StopPrescList(UpdateObj.StopPrescNo,function(){
								$.extend(UpdateObj, { ExistFlag: 1});
								resolve();
						});
					}else{
						resolve();
					}
				});
			}else{
				resolve();
			}
		})
	}).then(function(){
		UpdateClickHandlerFinish();
		//ѡ����ϴ���������Ϣ
		Common_ControlObj.AfterUpdate("OpenSelectDia",UpdateObj);
		if (UpdateObj.ExistFlag==0) {
			if (GlobalObj.StoreUnSaveData==1) NewClickHandler();
			SaveOrderToEMR();
		}
	})
	function ShowInputPinNum(callBackFun){
		$.messager.prompt('��ʾ', '����������', function(PinNumber){
			if ((PinNumber!="")&&(PinNumber!=undefined)){
				var ret = $.cm({
					ClassName:"web.DHCOEOrdItem",
					MethodName:"PinNumberValid",
					dataType:"text",
					UserID:session['LOGON.USERID'], PinNumber:PinNumber
				},false);
				if (ret == "-4") {
					$.messager.alert("��ʾ",t['Wrong_PinNumber'],"info",function(){
						ShowInputPinNum(callBackFun);
					});
	                return false;
	            }else{
		            callBackFun();
		        }
			}
			if (PinNumber==""){
				$.messager.alert("��ʾ","����������!","info",function(){
					ShowInputPinNum(callBackFun);
				});
				return false;
			}
			if (PinNumber==undefined){
				UpdateClickHandlerFinish();
				return false;
			}
	    });
	    $(".messager-input").focus();
	    $(".messager-input")[0].type="password";
	}
}
function UpdateClickHandlerFinish() {
	DisableBtn("Update",false);
	tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock",GetSessionStr(),"User.OEOrder");
}
function StopPrescList(StopPrescNo,callBackFun){
	UpdateObj={};
	new Promise(function(resolve,rejected){
	   	//����ǩ��
		CASignObj.CASignLogin(resolve,"OrderStop",true)
	}).then(function(CAObj){
    	return new Promise(function(resolve,rejected){
	    	if (CAObj == false) {
		    	UpdateClickHandlerFinish();
	    		return websys_cancel();
	    	} else{
	    	$.extend(UpdateObj, CAObj);
	    	resolve(true);
	    	}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var rtn = $.cm({
				ClassName:"web.UDHCPrescript",
				MethodName:"StopPrescNo",
				dataType:"text",
				PrescNo:StopPrescNo,UserID:session['LOGON.USERID'],LocID:session['LOGON.CTLOCID']
			},false);
			var rtnArr=rtn.split("^")
			if (rtnArr[0]!=0){
				$.messager.alert("��ʾ","ֹͣʧ�ܣ�"+rtnArr[1],"info",function(){
					if (callBackFun) callBackFun();
				})
			}else{
				var StopOrdList=rtnArr[1];
				$.messager.popover({msg: 'ֹͣ�ɹ�!',type:'success'});
				if (UpdateObj.caIsPass == 1) var ret = CASignObj.SaveCASign(UpdateObj.CAObj, StopOrdList, "S");
				if (callBackFun) callBackFun();
				NewClickHandler();
				SaveOrderToEMR();
			}
		})
	})
}
function SaveCASign(ContainerName,OrdList,OperationType) {    
    try{
	  if (ContainerName=="") return false;
	  //1.������֤
		var CASignOrdStr="";
		var TempIDs=OrdList.split("^");
			var IDsLen=TempIDs.length;
			for (var k=0;k<IDsLen;k++) {
				if (OperationType=="A") {
					var TempNewOrdDR = TempIDs[k].split("*");
					if (TempNewOrdDR.length < 2) continue;
				    var newOrdIdDR = TempNewOrdDR[1];
				}
				if (OperationType=="S") {
					var TempNewOrdDR=TempIDs[k].split("&");
					if (TempNewOrdDR.length <=0) continue;
					var newOrdIdDR=TempNewOrdDR[0];
				}
				if(CASignOrdStr=="")CASignOrdStr=newOrdIdDR;
				else CASignOrdStr=CASignOrdStr+"^"+newOrdIdDR;		
		  }
		var SignOrdHashStr="",SignedOrdStr="",CASignOrdValStr="";
		var CASignOrdArr=CASignOrdStr.split("^");
		for (var count=0;count<CASignOrdArr.length;count++) {
		    var CASignOrdId=CASignOrdArr[count];
			var OEORIItemXML = $.cm({
				ClassName:"web.DHCDocSignVerify",
				MethodName:"GetOEORIItemXML",
				dataType:"text",
				newOrdIdDR:CASignOrdId,
				OperationType:OperationType
			},false);
			var OEORIItemXMLArr=OEORIItemXML.split(String.fromCharCode(2));
			for (var ordcount=0;ordcount<OEORIItemXMLArr.length;ordcount++) {
				if (OEORIItemXMLArr[ordcount]=="")continue;
			var OEORIItemXML=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[1];
			var OEORIOperationType=OEORIItemXMLArr[ordcount].split(String.fromCharCode(1))[0];
				var OEORIItemXMLHash=HashData(OEORIItemXML);
				if(SignOrdHashStr=="") SignOrdHashStr=OEORIItemXMLHash;
				else SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&"+OEORIItemXMLHash;
				var SignedData=SignedOrdData(OEORIItemXMLHash,ContainerName);
				if(SignedOrdStr=="") SignedOrdStr=SignedData;
				else SignedOrdStr=SignedOrdStr+"&&&&&&&&&&"+SignedData;
				if(CASignOrdValStr=="") CASignOrdValStr=OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
				else CASignOrdValStr=CASignOrdValStr+"^"+OEORIOperationType+String.fromCharCode(1)+CASignOrdId;
			} 
		}
		if (SignOrdHashStr!="")SignOrdHashStr=SignOrdHashStr+"&&&&&&&&&&";
		if (SignedOrdStr!="")SignedOrdStr=SignedOrdStr+"&&&&&&&&&&";
		//��ȡ�ͻ���֤��
	    var varCert = GetSignCert(ContainerName);
	    var varCertCode=GetUniqueID(varCert);
	    if ((CASignOrdValStr!="")&&(SignOrdHashStr!="")&&(varCert!="")&&(SignedOrdStr!="")){
	    	var ret = $.cm({
				ClassName:"web.DHCDocSignVerify",
				MethodName:"InsertBatchSignRecord",
				dataType:"text",
				CurrOrderItemStr:CASignOrdValStr,
				UserID:session['LOGON.USERID'],
				OperationType:OperationType,
				OrdItemsHashVal:SignOrdHashStr,
				MainSignCertCode:varCertCode,
				MainSignValue:SignedOrdStr,
				ExpStr:""
			},false);
			if (ret!="0") {$.messager.alert("��ʾ","����ǩ��û�ɹ�!");return false;}
		}else{
		   $.messager.alert("��ʾ","����ǩ������");
		   return false;
	    } 
		return true;
	}catch(e){alert(e.message);return false;}
}
function SaveOrderItems(OrderItemStr){
	var DoctorRowid=GlobalObj.LogonDoctorID;
    var UserAddRowid=session['LOGON.USERID'];
    var UserAddDepRowid=session['LOGON.CTLOCID']; 
    var ret = $.m({
		ClassName:"web.DHCOEOrdItem",
		MethodName:"SaveOrderItemsCM",
		Adm:GlobalObj.EpisodeID,
		OrdItemStr:OrderItemStr,
		User:UserAddRowid,
		Loc:UserAddDepRowid,
		Doc:DoctorRowid,
		SessionStr:GetSessionStr()
	},false);
	return ret;
}
function GetOrderDataOnAdd(CallBackFun){
	var OrderItemStr="",OrderItemArr=new Array();
	var PrescDurFactor=GetDurFactor();
	var ColArr=[];
	var ColArrIndex=0;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
	new Promise(function(resolve,rejected){
	    (function(callBackFunExec){
			var OrderItemObj=[];
			var DataArry=[]
			for(var i=1;i<=rows;i++){
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
					var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
					if (OrderARCIMRowid==""){
						continue
					}
					DataArry.push({Row:i,Group:j})
				}
			}
			if (DataArry.length==0){
				resolve();
				return false;
				}
			var i=0;
		    function loop(Index){
				var Row=DataArry[Index].Row,Group=DataArry[Index].Group;
				new Promise(function(resolve,rejected){
					CheckINCIPackSum(Group,Row,"0",resolve)
				}).then(function(INCIPackCombStr){
					return new Promise(function(resolve,rejected){
						var OrderARCIMRowid=GetCellData(Row,Group,"OrderARCIMID"); 
						var OrderName=GetCellData(Row,Group,"OrderName");
						var OrderDoseQty=GetCellData(Row,Group,"OrderDoseQty");
						var OrderPhSpecInstr=$("#"+Row+"_OrderPhSpecInstr"+Group+"").find("option:selected").text(); //GetCellData(Row,Group,"OrderPhSpecInstr");
						var OrderPrice=GetCellData(Row,Group,"OrderPrice");
						var OrderItemSum=GetCellData(Row,Group,"OrderSum");
						var OrderHiddenPara=GetCellData(Row,Group,"OrderHiddenPara");
						var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
						var PHCDoseUOMRowid=OrderHiddenPara.split(String.fromCharCode(3))[10];
						var OrderSerialNum=OrderHiddenPara.split(String.fromCharCode(3))[14];
						var OrderDoseUOMRowid=PHCDoseUOMRowid;
						if (OrderDoseQty==""){OrderDoseUOMRowid=""};
						var cellPosi=Row+";"+Group; //��Ԫ��λ��
						var OrderCoverMainIns=GetCellData(Row,Group,"OrderCoverMainIns");
						var CalPrescNo="",CalPrescSeqNo="";
						var OrderMedHLYYInfo=""; //ҽΪ������ҩ����Ϣ,����ҽΪ������ҩ�����
						var PrescAuditFlag=""; //����˱��,������ϵͳ�����
						//1-10
						var OrderItem=OrderARCIMRowid+"^"+OrderDoseQty+"^"+OrderDoseUOMRowid+"^"+OrderPhSpecInstr +"^"+""+"^"+ARCIMARCOSRowid+"^"+INCIPackCombStr+"^"+cellPosi+"^"+OrderHiddenPara+"^"+OrderCoverMainIns
						//11-19
						var OrderItem=OrderItem+"^^^^^"+OrderSerialNum+"^"+CalPrescNo+"^"+CalPrescSeqNo+"^"+OrderMedHLYYInfo+"^"+PrescAuditFlag;
						OrderItemObj.push(OrderItem);
						resolve();
					})
				}).then(function(){
					i++;
					if ( i < DataArry.length ) {
						 loop(i);
					}else{
						callBackFunExec(OrderItemObj);
					}
				})
			}
			loop(0)
		})(resolve);
	}).then(function(OrderItemObj){
		//������Ϣ���
		var OrderRecDepRowid=$('#RecLoc').combobox("getValue");
		var PrescDurRowid=$('#PrescDuration').combobox("getValue");
		var PrescDurFactor=GetDurFactor();
		var PrescInstrRowid=$('#PrescInstruction').combobox("getValue");
		var PrescFreqRowid=$('#PrescFrequence').combobox("getValue");
		var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
		var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
		var PrescCookDecoction="N";
		//var cbox=$HUI.checkbox("#PrescCookDecoction");
		//if (cbox.getValue()) PrescCookDecoction="Y"; //�Ƿ����
		var PrescNotes=$('#PrescNotes').val();
		var PrescEmergency=$("#PrescUrgent").checkbox('getValue')?"Y":"N"; //�Ƿ�Ӽ�
		var PrescStartDate="",PrescStartTime="",ARCOSRowId="";
		//��ʼ����,����ǳ�Ժ/��������õ���,��ʼ���ڱ����ǳ�Ժ����ʱ��
		if (GlobalObj.CurrentDischargeStatus=="B") {
			PrescStartDate=GlobalObj.DischargeDate;
			PrescStartTime=GlobalObj.DischargeTime;
		}else{
			var PrescStartDateStr=$("#PrescStartDate").val();
			if (PrescStartDateStr!="") {
				PrescStartDate=PrescStartDateStr.split(" ")[0];
				PrescStartTime=PrescStartDateStr.split(" ")[1];
				if (PageLogicObj.SYSDateFormat=="4"){
					var tmpPrescStartDate=PrescStartDate.split("/")[2]+"-"+PrescStartDate.split("/")[1]+"-"+PrescStartDate.split("/")[0]
					var tmpPrescStartDate = new Date(tmpPrescStartDate.replace("-", "/").replace("-", "/"));
				}else{
					var tmpPrescStartDate = new Date(PrescStartDate.replace("-", "/").replace("-", "/"));
				}
				var CurDate=new Date();
				var end=new Date(CurDate.getFullYear()+"/"+(CurDate.getMonth()+1)+'/'+ CurDate.getDate());
				if (!DATE_FORMAT.test(PrescStartDate)){
					$.messager.alert('��ʾ',"��ʼ���ڸ�ʽ����ȷ!","info",function(){
						DisableBtn("Update",false);
						$("#PrescStartDate").focus();
					});
					return false;
				}else if(tmpPrescStartDate<end){
					$.messager.alert('��ʾ',"��ʼ���ڲ���С�ڵ���!","info",function(){
						DisableBtn("Update",false);
						$("#PrescStartDate").focus();
					});
					return false;
				}
			}
		}
		var AddLongOrder="";
		if (GlobalObj.PAAdmType=="I"){
			AddLongOrder=$('#AddLongOrderList').combobox('getValue');
			if (!AddLongOrder) AddLongOrder="";
		}
		var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
		var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
		var DetailsArr=CMPrescTypeDetails.split("#");
		var CMPrescTypeCode=DetailsArr[0];		
		var IPCookModeFeeNoAutoAdd=DetailsArr[9];
		var CNMedCookModeFeeItemRowid=DetailsArr[10];
		var CNMedAppendItem=DetailsArr[11];
		var CMPrescTypeLinkFeeStr=DetailsArr[17];
		var PrescAppenItemQty=$('#PrescAppenItemQty').val();
		var PrescCookDecoction=$('#CookModelist').combobox('getValue');
		var EmConsultItm=GlobalObj.EmConsultItm;	///�����ӱ�ID
		var TakingMedicineMethod=""
		if (GlobalObj.TakingMedicineShowFlag=="Y"){
			var TakingMedicineMethod=$('#TakingMedicineMethod').combobox('getValue');
		}
		var PrescStr=OrderPriorRowid+"^"+PrescDurRowid+"^"+PrescInstrRowid+"^"+PrescFreqRowid+"^"+PrescCookDecoction+"^"+PrescOrderQty+"^"+OrderRecDepRowid+"^"+GlobalObj.OrderBillTypeRowid+"^"+PrescNotes+"^"+PrescEmergency+"^"+PrescStartDate+"^"+PrescStartTime+"^"+PageLogicObj.m_ARCOSRowId;					
		var PrescWeight=GetPrescWeight();
		var PrescStr=PrescStr+"^"+PrescWeight+"^"+AddLongOrder+"^"+CMPrescTypeCode+"^"+PageLogicObj.PractiacRowStr+"^"+PrescAppenItemQty+"^"+GlobalObj.AntCVID+"^"+EmConsultItm+"^"+TakingMedicineMethod;
		//����ҽ����ϸ
		var OrderItemStr="";
		if (OrderItemObj){
			for (var i=0;i<OrderItemObj.length;i++) {
				if (OrderItemObj[i]=="") continue;
				if (OrderItemStr=="") {
					OrderItemStr=OrderItemObj[i];
				}else{
					OrderItemStr=OrderItemStr+String.fromCharCode(1)+OrderItemObj[i];
				}
			}
		}
		if (OrderItemStr=="") {
			CallBackFun("");
			return;
		}
		if (OrderItemStr!=""){OrderItemStr=PrescStr+String.fromCharCode(2)+OrderItemStr};
		/// ׷�Ӱ�ҽ������
		$.cm({
			ClassName:"web.DHCOEOrdAppendItem",
			MethodName:"GetAppendOrdItemCMArr",
			Adm:GlobalObj.EpisodeID,
			OrdItemStr:OrderItemStr,
			OrdAddCongeriesArr:"[]",
			SessionStr:GetSessionStr(),
			dataType:"text"
		},function(OrderItemStr){
			CallBackFun(OrderItemStr);
		})
	})
}
function CheckBeforeUpdate(){
	if (GlobalObj.PAAdmType=="E"){
 		var warning=tkMakeServerCall("web.DHCDocViewDataInit","GetOrdEntryWarning",GlobalObj.EpisodeID)
 		if (warning!="") {
	 		$.messager.alert("��ʾ",warning);
	 		return false;
	 	}
	}	
	var XYPrescCount=0;
	var ZCYPrescCount=0;
	var CYPrescCount=0;
	var NewRows=0;
	var CNOrderDur="";
	var FindCNMedCl=false;
	var NeedCheckDeposit=false;         //���Ѻ�����
	var Amount=0;
	var FindSelfCookPHSpecInstr=false;  //�ҵ�ֻ���Լ���÷�
    try{
		var OrderRecDepRowid=$('#RecLoc').combobox('getValue');
		if (!CheckComboValue("RecLoc","id")) return false;
				
		var PrescDurRowid=$("#PrescInstruction").combobox('getValue');
		if (!CheckComboValue("PrescInstruction","HIDDEN")) return false;
			
		var PrescFrequenceRowid=$("#PrescFrequence").combobox('getValue');
		if (!CheckComboValue("PrescFrequence","PHCFRRowid")) return false;
		
		var PrescDurationRowid=$("#PrescDuration").combobox('getValue');
		if (!CheckComboValue("PrescDuration","PHCDURowid")) return false;
		var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
		if (PrescOrderQty==""){
			dhcsys_alert("һ������Ϊ��");
			return false;
		}
		var OrderPriorRowid=$('#PrescPrior').combobox('getValue');
		var PrescAppenItemQty=$('#PrescAppenItemQty').val();
		if (PrescAppenItemQty!=""){
			if (!isNumber(PrescAppenItemQty)){
				dhcsys_alert(PrescAppenItemDesc+t['Not_Number']);
				return false;
			}
			if(+PrescAppenItemQty<0){
	            dhcsys_alert("ҩ����������Ϊ��!");
                return false;
            }
		}else{
			PrescAppenItemQty=0;
	    }
	    var PrescDurFactor=GetDurFactor();
		//�ӹ���ʽ�޶�����(��Ŀ��)
		var myrtn=CheckPrescBound();
		if (!myrtn) return false;
		//ֻ���Լ���÷��ַ���,��Ϊ��ʱ������ͨ����(������ҽԺ����),ֻ��message����,��"^"Ϊ����
		var SelfCookPHSpecInstr=t['SelfCookPHSpecInstr'];
		
		var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
		var TakingMedicineMethod=""
		if (GlobalObj.TakingMedicineShowFlag=="Y"){
			var TakingMedicineMethod=$('#TakingMedicineMethod').combobox('getValue');
		}
        for (var i=1; i<=rows; i++){
	        var Row=i;
			for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
				var OrderARCIMRowid=$("#"+i+"_OrderARCIMID"+j+"").val();
				if (OrderARCIMRowid!=""){
					var OrderName=$("#"+i+"_OrderName"+j+"").val(); 
					var OrderDoseQty=$("#"+i+"_OrderDoseQty"+j+"").val();  
					var OrderPrice=$("#"+i+"_OrderPrice"+j+"").val(); 
					var OrderItemSum=$("#"+i+"_OrderSum"+j+"").val(); 
					var OrderPhSpecInstr=$("#"+i+"_OrderPhSpecInstr"+j+"").val(); 
					var OrderHiddenPara=$("#"+i+"_OrderHiddenPara"+j+"").val();
  					var AllowEntryDecimalItemCat=mPiece(OrderHiddenPara,String.fromCharCode(3),13);
					Amount=Amount+parseFloat(OrderItemSum);
					if (OrderDoseQty==""){
						dhcsys_alert(OrderName+t['NO_DoseQty']);
						FocusRowIndex=i;
						FocusGroupIndex=j;
						SetFocusColumn("OrderDoseQty"+j,Row);
						return false;
					}
					if ((!isNumber(OrderDoseQty))||(parseFloat(OrderDoseQty)==0)){
						dhcsys_alert(OrderName+t['Not_Number']);
						FocusRowIndex=i;
						FocusGroupIndex=j;
						SetFocusColumn("OrderDoseQty"+j,Row);
						return false;
					}
					if (OrderDoseQty < 0) {
						dhcsys_alert(OrderName + "��������Ϊ��!");
						FocusRowIndex=i;
						FocusGroupIndex=j;
						SetFocusColumn("OrderDoseQty"+j,Row);
                        return false;
                    }
                    if (+OrderDoseQty > 9999) {
	                    dhcsys_alert(OrderName + "�������ܳ���9999!");
						FocusRowIndex=i;
						FocusGroupIndex=j;
						SetFocusColumn("OrderDoseQty"+j,Row);
                        return false;
	                }
                    //var SubCatID = tkMakeServerCall("web.DHCDocOrderEntry","GetARCItemSubCatIDBroker",'','',OrderARCIMRowid);
				    if ((AllowEntryDecimalItemCat=="Y")&&(OrderDoseQty.indexOf(".")>=0)) {
					    dhcsys_alert(OrderName + "����������С��!");
                        return false;
				    }
                    if ((OrderPrice == "") || (OrderPrice < 0)) {
	                    dhcsys_alert(OrderName + "�۸���Ч,���������");
                        return false;
                    }
                    var CheckforlocStr=$.cm({
						ClassName:"web.DHCSTINTERFACE",
						MethodName:"GetIncilQtyList",
						dataType:"text",
						ArcID:OrderARCIMRowid,
						recLoc:OrderRecDepRowid
					},false);
					var OrderRecDep=$("#RecLoc").combobox('getText'); 
					if (CheckforlocStr==""){dhcsys_alert(OrderName+"��"+OrderRecDep+"û�п��ÿ��");return false;}
                   var INCIPackCombStr =CheckINCIPackSum(j, Row,"0");
					if (INCIPackCombStr==""){dhcsys_alert("��ѡ����ʵ������");return false;}
					var Check = $.cm({
						ClassName:"web.DHCDocOrderCommon",
						MethodName:"CheckStockEnoughByInc",
						dataType:"text",
						INCIPackCombStr:INCIPackCombStr,
						RecLoc:OrderRecDepRowid,
						EpisodeType:"",ExpStr:"",DurFactor:PrescDurFactor,TakingMedicineMethod:TakingMedicineMethod
					},false);
					if (Check=='0') {
						dhcsys_alert(OrderName+t['QTY_NOTENOUGH']);
						FocusRowIndex=i;
						FocusGroupIndex=j;
						SetFocusColumn("OrderDoseQty"+j,Row);
						return false;
					}
					/*Qty=parseFloat(OrderDoseQty)*parseFloat(PrescDurFactor);
					var Check = $.cm({
						ClassName:"web.DHCDocOrderCommon",
						MethodName:"CheckStockEnough",
						dataType:"text",
						arcim:OrderARCIMRowid,
						Qty:Qty,
						RecLoc:OrderRecDepRowid,
						EpisodeType:"",ExpStr:""
					},false);
					if (Check=='0') {
						$.messager.alert("��ʾ",OrderName+t['QTY_NOTENOUGH'],"info",function(){
							FocusRowIndex=i;
							FocusGroupIndex=j;
							SetFocusColumn("OrderDoseQty"+j,Row);
						});
						return false;
					}*/
					if (CheckDurationPackQty(j,Row)==false){
						SetFocusColumn("OrderDoseQty"+j,Row);
						FocusRowIndex=i;
						FocusGroupIndex=j;
						return false;
					}
					//�ж�ҽ�����е��ż�������
					var CheckArcimTypeStr = $.cm({
						ClassName:"web.DHCDocOrderCommon",
						MethodName:"CheckArcimType",
						dataType:"text",
						ArcimRowid:OrderARCIMRowid, AdmID:GlobalObj.EpisodeID, AdmTypeIN:""
					},false);
  					if (CheckArcimTypeStr!=""){dhcsys_alert(OrderName+CheckArcimTypeStr);return false;}
					if ((SelfCookPHSpecInstr!="")&&(OrderPhSpecInstr!="")){
						SelfCookPHSpecInstr="!"+SelfCookPHSpecInstr+"!";
						OrderPhSpecInstr="!"+OrderPhSpecInstr+"!";
						if (SelfCookPHSpecInstr.indexOf(OrderPhSpecInstr)!=-1) {FindSelfCookPHSpecInstr=true;}
					}
					if (CheckProtocolPackSum(j,Row)==false) {
						SetFocusColumn("OrderDoseQty"+j,Row);
						FocusRowIndex=i;
						FocusGroupIndex=j;
						return false;
					}
					NewRows=NewRows+1;
					//���ֻ�����Ա�ҩҽ������۸�ҽ�������ж�Ƿ��
					if ((OrderPriorRowid!=GlobalObj.OMOrderPriorRowid)&&(OrderPriorRowid!=GlobalObj.OMSOrderPriorRowid)&&(parseFloat(OrderPrice)!=0)) {NeedCheckDeposit=true}
				}
			}
		}
		if (NeedCheckDeposit){
			var amount=$("#ScreenBillSum").val();
			if (!CheckDeposit(amount,"")){
				return false;
			}
	    }
		Amount=Amount.toFixed(2);
		if (!CheckBillTypeSum(Amount)){
			var PrescCheck=dhcsys_confirm(t['EXCEED_ADMAMOUNT'],true);
			if (PrescCheck==false){return false;}
		}
		//����ҵ����Լ���÷�,�ͽ�������Ϊ�Լ崦��  ��Ŀ��
		if (FindSelfCookPHSpecInstr){
			var CookModeCode=$('#CookMode').val();
			if ((CookModeCode!="01") &&(GlobalObj.PAAdmType!="I")){
				dhcsys_alert(t['FindSelfCookPHSpecInstr']);
				return false;
			}
		}
		if (NewRows==0){
			dhcsys_alert(t['NO_NewOrders']);
			return false;
		}
		///ҽ����ҩ���� TODO ҽ���ط��Ƿ���Ҫ����
		//var ret=CheckInsuCostControl()
		//if (!ret){return false;}
		return true;
	}catch(e){dhcsys_alert(e.message);return false;}
}
function CheckPrescBound(){
	var PrescWeight = GetPrescWeight();
    if (PrescWeight==""){
        dhcsys_alert("û���¿�����!")
        return false;
    }
    var PrescCookDecoction=$("#PrescCookDecoction").checkbox('getValue')?'Y':'';
	//var CMPrescTypeDetails = $("#CMPrescType").combobox('getValue');
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
	var PrescCookModeDesc=CMPrescTypeKWSel[0].text; //$("#CMPrescType").combobox('getText');
	// �ӹ���ʽ�޶�����
	if (PrescCookDecoction=="Y"){
		var CookModePrescBound = $.cm({
			ClassName:"web.DHCDocOrderEntryCM",
			MethodName:"GetPrescBound",
			dataType:"text",
			PrescTypeCode:CMPrescTypeCode
		},false);
		if (CookModePrescBound!=""){
			var PrescBoundArray=CookModePrescBound.split("^");
			var UomDesc=PrescBoundArray[0];
			var PrescQtyStt=PrescBoundArray[1];
			var PrescQtyEnd=PrescBoundArray[2];
			if (UomDesc=="100G") {
				PrescQtyStt=PrescQtyStt*100;
				PrescQtyEnd=PrescQtyEnd*100;
				if (parseFloat(PrescWeight)<parseFloat(PrescQtyStt)){
					dhcsys_alert(t['LessThan']+PrescQtyStt+t['Gram']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}else if ((parseFloat(PrescWeight)>=parseFloat(PrescQtyEnd))&&(PrescQtyEnd!="")){
					dhcsys_alert(t['MoreThan']+t['Equal']+PrescQtyEnd+t['Gram']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}
			}else if(UomDesc=="G") {
				if (parseFloat(PrescWeight)<parseFloat(PrescQtyStt)){
					dhcsys_alert(t['LessThan']+PrescQtyStt+t['Gram']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}else if ((parseFloat(PrescWeight)>=parseFloat(PrescQtyEnd))&&(PrescQtyEnd!="")){
					dhcsys_alert(t['MoreThan']+t['Equal']+PrescQtyEnd+t['Gram']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}
			}else if (UomDesc==t['Dose']){
				if (parseInt(PrescDurFactor)<parseInt(PrescQtyStt)){
					dhcsys_alert(t['LessThan']+PrescQtyStt+t['Dose']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}else if ((parseFloat(PrescDurFactor)>=parseFloat(PrescQtyEnd))&&(PrescQtyEnd!="")){
					dhcsys_alert(t['MoreThan']+t['Equal']+PrescQtyEnd+t['Dose']+t['CanNotUseCookMode']+PrescCookModeDesc);
					return false;
				}
			}
		}	
	}
	return true;
}
function CheckBillTypeSum(Amount){
	if ((GlobalObj.PAAdmType!="O")||(Amount===0)) {return true}	
	//ֻ��������ʱ�Ŵ���PrescBillType TABҳ
	//�ɰ�һֱ�ǿ�?
	var PrescLimitSum="" //GetPrescLimitSum();
	if (GlobalObj.CheckBillTypeSumMethod!=""){
		var retDetail = $.cm({
			ClassName:"web.DHCDocOrderCommon",
			MethodName:"CheckBillTypeSum",
			dataType:"text",
			PAADMRowid:GlobalObj.EpisodeID,
			InsType:GlobalObj.OrderBillTypeRowid,
			PrescLimitSum:PrescLimitSum,
			Amount:Amount,
			PrescLimitType:""
		},false);
		if (retDetail==1) {return false}
	}
	return true
}
function CheckDeposit(amount,arcim){
	if (+amount==0) return true;
    if (GlobalObj.VisitStatus=="P") return true;
    if (GlobalObj.NotDoCheckDeposit==1) return true;
    if (GlobalObj.SupplementMode==1){return true;}
    if ((GlobalObj.PAAdmType != "I") && (GlobalObj.GetStayStatusFlag != 1) && (GlobalObj.GetStayStatusFlag != 2)) { return true }
    
	//CheckIPDeposit �Ƿ����Ƿ�ѿ���  1���� 0 ������
	//CheckIPLocDeposit �����Ƿ����Ƿ�ѿ���  1 ������ 0����
	if ((GlobalObj.CheckIPDeposit=="1")&&(GlobalObj.CheckIPLocDeposit=="0")){
		var retDetail = $.cm({
			ClassName:"web.UDHCJFARREARSMANAGE",
			MethodName:"CheckArrears",
			dataType:"text",
			adm:GlobalObj.EpisodeID, str:amount, flag:"OE", loginLocId:""
		},false);
		if (retDetail!=0) {
			var retArray=retDetail.split("^");
			if (retArray[4]=='C'){
				var AlertAmount=retArray[0];
				if (AlertAmount<0) {
					AlertAmount="-"+FormateNumber(AlertAmount.split("-")[1]);
				}else{
					AlertAmount=FormateNumber(AlertAmount);
				}
				if (retArray[5]=='N'){
					$.messager.alert("��ʾ", $g(t['ExceedDeposit'])+AlertAmount); 
					return false;
				}else{
					if (arcim!=""){
						var retDetail = $.cm({
							ClassName:"web.UDHCJFARREARSMANAGE",
							MethodName:"CheckOrderE",
							dataType:"text",
							rowid:retArray[2], arcim:arcim, ExecFlag:""
						},false);
						if (retDetail==0){
							//dhcsys_alert(t['ExceedDeposit']+AlertAmount);
							$.messager.alert("��ʾ", $g(t['ExceedDeposit'])+AlertAmount); 
							return false;
						}
					}
				}
			}
		}
	}
	return true;
}
function CheckDurationPackQty(Column,Row) {
  //if (GlobalObj.PAAdmType!="O") return true;
  var OrderName=GetCellData(Row,Column,"OrderName");
  var OrderHiddenPara=GetCellData(Row,Column,"OrderHiddenPara");
  var OrderMaxQty=mPiece(OrderHiddenPara,String.fromCharCode(3),1);
  var OrderMaxDurFactor=mPiece(OrderHiddenPara,String.fromCharCode(3),0);
  var WarningUseQty=mPiece(OrderHiddenPara,String.fromCharCode(3),8);
  var OrderDoseQty=GetCellData(Row,Column,"OrderDoseQty");
  if ((WarningUseQty>0)&&(parseFloat(OrderDoseQty)>parseFloat(WarningUseQty))) {
	dhcsys_alert(OrderName+"����ҩƷ�ļ��������޶�:"+WarningUseQty);
	return false;
  }
  if ((OrderMaxQty>0)&&(parseFloat(OrderDoseQty)>parseFloat(OrderMaxQty))) {
  	var ret=dhcsys_confirm(OrderName+t['MedMaxQty']+OrderMaxQty,false);
  	if (ret==false) {return false;}
  }
  if (OrderMaxDurFactor==0) {return true;}
  return true;
}
//��ֱ�ƶ�
function OrdVerticalMove(id){
	if ($("#"+id).hasClass('l-btn-disabled')){
		return false;
	}
	if ((FocusGroupIndex==0)||(FocusRowIndex==0)){
		return false;
		}
	DisableBtn(id,true);
	if(id=="MoveUp_btn"){
		var ListGroupTo=FocusGroupIndex;
		var FocusRowIndexTo=parseInt(FocusRowIndex)-1;
		if(FocusRowIndexTo==0){
			$.messager.alert("��ʾ","���������ƶ�!","info",function(){
				DisableBtn(id,false);
			});
			return false;
		}
	}else{
		var ListGroupTo=FocusGroupIndex;
		var FocusRowIndexTo=parseInt(FocusRowIndex)+1;
		var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
		if(FocusRowIndex==rows){
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")) { 
				DisableBtn(id,false);
				return false;
			}
			Add_CMOrdEntry_row();
		}
		
	}
	ChangeCellData(FocusRowIndexTo,ListGroupTo,FocusGroupIndex,FocusRowIndex);
	DisableBtn(id,false);
}
//ˮƽ�ƶ�
function OrdHorizontalMove(id){
	if ($("#"+id).hasClass('l-btn-disabled')){
		return false;
	}
	if ((FocusGroupIndex==0)||(FocusRowIndex==0)){
		return false;
		}
	DisableBtn(id,true);
	if(id=="MoveLeft_btn"){
		var ListGroupTo=parseInt(FocusGroupIndex)-1;
		if(ListGroupTo==0){
			$.messager.alert("��ʾ","���������ƶ�!","info",function(){
				DisableBtn(id,false);
			});
			return false;
		}
		var FocusRowIndexTo=FocusRowIndex;
	}else{
		var ListGroupTo=parseInt(FocusGroupIndex)+1;
		if(ListGroupTo>GlobalObj.ViewGroupSum){
			$.messager.alert("��ʾ","���������ƶ�!","info",function(){
				DisableBtn(id,false);
			});
			return false;
		}
		var FocusRowIndexTo=FocusRowIndex;
	}
	ChangeCellData(FocusRowIndexTo,ListGroupTo,FocusGroupIndex,FocusRowIndex);
	DisableBtn(id,false);
}
function ChangeCellData(FocusRowIndexTo,ListGroupTo,TFocusGroupIndex,TFocusRowIndex){
	//������Ϣ 
	var ListToOrderName=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderName");
	var ListToOrderDoseQty=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderDoseQty");
	var ListToOrderPrice=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderPrice");
	var ListToOrderARCIMID=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderARCIMID");
	var ListToOrderPhSpecInstr=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderPhSpecInstr");
	var ListToOrderHiddenPara=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderHiddenPara");
	var ListToOrderSum=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderSum");
	var ListToOrderDoseUOM=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderDoseUOM");
	var ListToOrderCoverMainIns=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderCoverMainIns");
	//��������Ϣ
	
	var ListFromOrderName=GetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderName");
	var ListFromOrderDoseQty=GetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderDoseQty");
	var ListFromOrderPrice=GetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderPrice");
	var ListFromOrderARCIMID=GetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderARCIMID");
	var ListFromOrderPhSpecInstr=GetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderPhSpecInstr");
	var ListFromOrderHiddenPara=GetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderHiddenPara");
	var ListFromOrderSum=GetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderSum");
	var ListFromOrderDoseUOM=GetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderDoseUOM");
	var ListFromOrderCoverMainIns=GetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderCoverMainIns");
	//setTimeout(function(){ 
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderName",ListFromOrderName);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderDoseQty",ListFromOrderDoseQty);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderPrice",ListFromOrderPrice);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderARCIMID",ListFromOrderARCIMID);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderPhSpecInstr",ListFromOrderPhSpecInstr);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderHiddenPara",ListFromOrderHiddenPara);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderSum",ListFromOrderSum);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderDoseUOM",ListFromOrderDoseUOM);
	SetCellData(FocusRowIndexTo,ListGroupTo,"OrderCoverMainIns",ListFromOrderCoverMainIns);
	/*
	var select_id=FocusRowIndexTo+"_OrderPhSpecInstr"+ListGroupTo;
	if (ListFromOrderPhSpecInstr!=""){
		$("#"+select_id).val(ListFromOrderPhSpecInstr);
	}*/

	SetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderName",ListToOrderName);
	SetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderDoseQty",ListToOrderDoseQty);
	SetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderPrice",ListToOrderPrice);
	SetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderARCIMID",ListToOrderARCIMID);
	SetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderPhSpecInstr",ListToOrderPhSpecInstr);
	SetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderHiddenPara",ListToOrderHiddenPara);
	SetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderSum",ListToOrderSum);
	SetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderDoseUOM",ListToOrderDoseUOM);
	SetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderCoverMainIns",ListToOrderCoverMainIns);
	/*var select_id=FocusRowIndex+"_OrderPhSpecInstr"+GroupIndex;
	if (ListToOrderPhSpecInstr!=""){
		$("#"+select_id+" option[value='"+ListToOrderPhSpecInstr+"']").attr("selected", "selected");
	}*/
	
	var OrderHiddenPara=GetCellData(TFocusRowIndex,TFocusGroupIndex,"OrderHiddenPara");
	if (OrderHiddenPara!=""){
        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
        var IsARCOSFormula = $.cm({
			ClassName:"web.UDHCPrescript",
			MethodName:"IsARCOSFormula",
			dataType:"text",
			ARCOSRowid:ARCIMARCOSRowid
		},false);
        if (IsARCOSFormula=="1"){
	        ChangeRowStyle1(TFocusRowIndex,TFocusGroupIndex,true);
	    }else{
		    ChangeRowStyle1(TFocusRowIndex,TFocusGroupIndex,false);
		}
    }else{
	    ChangeRowStyle1(TFocusRowIndex,TFocusGroupIndex,false);
	}
	var OrderHiddenPara=GetCellData(FocusRowIndexTo,ListGroupTo,"OrderHiddenPara");
	if (OrderHiddenPara!=""){
        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
        var  IsARCOSFormula= $.cm({
			ClassName:"web.UDHCPrescript",
			MethodName:"IsARCOSFormula",
			dataType:"text",
			ARCOSRowid:ARCIMARCOSRowid
		},false);
        if (IsARCOSFormula=="1"){
	        ChangeRowStyle1(FocusRowIndexTo,ListGroupTo,true);
	    }else{
		    ChangeRowStyle1(FocusRowIndexTo,ListGroupTo,false);
		}
    }else{
	    ChangeRowStyle1(TFocusRowIndex,TFocusGroupIndex,false);
	}
    
	FocusRowIndex=FocusRowIndexTo;
	FocusGroupIndex=ListGroupTo;
	SetFocusColumn("OrderName"+ListGroupTo,FocusRowIndexTo);
	//},500)
}
function OrdercopyClick(){
	websys_showModal({
		url:'opdoc.oeorder.cmpresclist.csp?EpisodeID='+GlobalObj.EpisodeID,
		title:$g('��ҩҽ������'),
		iconCls:'icon-w-list',
		width:"96%",height:592,
		AddCopyItemToListFromQuery:AddCopyItemToListFromQuery,
		PrescListChange:PrescListChange
	});
}
//��ҩ��������
function AddCopyItemToListFromQuery(ParaArr){
	var OrdParamsArr=new Array();
    new Promise(function(resolve,rejected){
		//������ҽ����Ϣ�ϲ���һ����������
		(function(callBackExecFun){
			function loop(i){
				new Promise(function(resolve,rejected){
					var Para1Str=ParaArr[i];
					var para1Arr = Para1Str.split("!")
					var ArcimARCOSRowId=para1Arr[5];
					if ((typeof ArcimARCOSRowId == "undefined") || (ArcimARCOSRowId == "undefined")) {
						ArcimARCOSRowId="";
					}
					CheckFormulaCanAppendItem(ArcimARCOSRowId,resolve);
				}).then(function(rtn){
					return new Promise(function(resolve,rejected){
						if (rtn) {
							var Para1Str=ParaArr[i];
							var para1Arr = Para1Str.split("!")
							var icode = para1Arr[0];
							CheckDiagnose(icode,resolve);
						}else if(OrdParamsArr.length>0){
							callBackExecFun();
						}
					})
				}).then(function(rtn){
					return new Promise(function(resolve,rejected){
						if (rtn) {
							var Para1Str=ParaArr[i];
							var para1Arr = Para1Str.split("!")
							var icode = para1Arr[0];
							var doseqty = para1Arr[1];
							var doseuomrowid=para1Arr[2];
							var PhSpecInstr=para1Arr[3];
							var ARCOSRowId=para1Arr[4];
							var ArcimARCOSRowId=para1Arr[5];
							if ((typeof ArcimARCOSRowId == "undefined") || (ArcimARCOSRowId == "undefined")) {
								ArcimARCOSRowId="";
							}
							if ((ARCOSRowId=="")&&(ArcimARCOSRowId!="")) ArcimARCOSRowId="";
							if (ArcimARCOSRowId!=""){
								PageLogicObj.IsARCOSFormula = $.cm({
									ClassName:"web.UDHCPrescript",
									MethodName:"IsARCOSFormula",
									dataType:"text",
									ARCOSRowid:ArcimARCOSRowId
								},false);
								PageLogicObj.m_ARCOSRowId=ArcimARCOSRowId;
							}
							var Para=doseqty+String.fromCharCode(1)+""+String.fromCharCode(1)+doseuomrowid;
							Para=Para+"^^^^^^"+ArcimARCOSRowId+"^^^"+PhSpecInstr+"^^^^";
							OrdParamsArr[OrdParamsArr.length]={
								OrderARCIMRowid:icode,
								ParamS:Para,
								OrderBillTypeRowid:GlobalObj.OrderBillTypeRowid,
								ITMRowId:""
							};
							resolve();
						}else if(OrdParamsArr.length>0){
							callBackExecFun();
						}
					})
				}).then(function(){
					i++;
					if ( i < ParaArr.length ) {
						 loop(i);
					}else{
						callBackExecFun();
					}
				})
			}
			loop(0);
		})(resolve);
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")){
					var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
					var GroupList=[];
					for(var i=1;i<=rows;i++){
						for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
						   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
						   if (OrderARCIMRowid!=""){
							   GroupList.push(i+"^"+j);
						   }
						}
					}
					if (GroupList.length>0){
			        	$.messager.alert("��ʾ","Э���������������ͨҩƷ�쿪!","info",function(){
			            	for (var i=0;i<GroupList.length;i++) {
			                	ClearGroupData(GroupList[i].split("^")[0],GroupList[i].split("^")[1]);
			                }
			                FocusRowIndex=1;
			                FocusGroupIndex=1;
			                resolve();
			            });
			        }else{
			            resolve();
			        }
			}else{
				FocusRowIndex=0,FocusGroupIndex=0;
				var FocusObj=GetNewFocusIndex();
				FocusRowIndex=FocusObj.FocusRowIndex;
			   	FocusGroupIndex=FocusObj.FocusGroupIndex;
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve);
		})
	}).then(function(RtnObj){
		if (RtnObj==true){
			setTimeout(function(){ 
				SetScreenSum();
		     }, 100); 
		}else{
			PageLogicObj.IsARCOSFormula=0;
		}
	})
}
function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;

    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}
function destroyDialog(id){
	$("body").remove("#"+id); //�Ƴ����ڵ�Dialog
	$("#"+id).dialog('destroy');
}
function CloseDialog(id){
	$('#'+id).dialog('close');
}
function AddUnsaveDataToList(UnsaveData){
	if (UnsaveData=="") return;
	var UnsaveArr=UnsaveData.split(String.fromCharCode(12));
	var UnsaveArr1=UnsaveArr[1].split("^");
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
	if (CMPrescTypeCode!=UnsaveArr1[12]) {
		var Data=$("#CMPrescTypeKW").keywords('options').items;
		for (var i=0;i<Data.length;i++){
			var CMPrescTypeCode=Data[i].id;
			if (CMPrescTypeCode==UnsaveArr1[12]){
				$("#CMPrescTypeKW").keywords('select',CMPrescTypeCode);
				break;
			}
		}
	}
	
		
	var sbox = $HUI.combobox("#PrescDuration");
		sbox.select(UnsaveArr1[0]);
		
	var sbox = $HUI.combobox("#PrescInstruction");
		sbox.select(UnsaveArr1[1]);
	
	var sbox = $HUI.combobox("#RecLoc");
		sbox.select(UnsaveArr1[2]);
		
	var sbox = $HUI.combobox("#PrescFrequence");
		sbox.select(UnsaveArr1[3]);
	/*
	var sbox = $HUI.combobox("#PrescOrderQty");
		sbox.select(UnsaveArr1[4]);
	*/
	var sbox = $HUI.combobox("#PrescPrior");
		sbox.select(UnsaveArr1[5]);
	$('#PrescOrderQty').combobox('setText',UnsaveArr1[4]);
	$("#PrescAppenItemQty").val(UnsaveArr1[6]);
	$("#PrescNotes").val(UnsaveArr1[7]);
	$("#PrescEmergency").val(UnsaveArr1[8]);
	$("#StartDate").val(UnsaveArr1[9]);
	$("#EndDate").val(UnsaveArr1[10]);
	PageLogicObj.m_ARCOSRowId=UnsaveArr1[11];
	//$("#ARCOSRowId").val(UnsaveArr1[11]);
	PageLogicObj.IsARCOSFormula=UnsaveArr1[13];
	if (PageLogicObj.IsARCOSFormula==1){
        checkIsExistOtherOrd();
        DisableDeleteButton(1);
    }
    $("#CookModelist").combobox('select',UnsaveArr1[15]);
    $("#PrescUrgent").checkbox('setValue',UnsaveArr1[14]=="Y"?true:false);
    if (GlobalObj.TakingMedicineShowFlag=="Y"){
    	$("#TakingMedicineMethod").combobox('select',UnsaveArr1[16]);
    }
	var Count=0;
	var UnsaveArr=UnsaveArr[0].split(String.fromCharCode(2));
	for (var j=0;j<UnsaveArr.length;j++) {
		FindNullCell();
	    if (UnsaveArr[j]=="") continue;
		Count=Count+1;
		var OrderARCIMID=mPiece(UnsaveArr[j],"^",0);
		var OrderName=mPiece(UnsaveArr[j],"^",1);
		var OrderDoseQty=mPiece(UnsaveArr[j],"^",2);
		var OrderPhSpecInstr=mPiece(UnsaveArr[j],"^",3);
		var OrderPrice=mPiece(UnsaveArr[j],"^",4); 
		var OrderSum=mPiece(UnsaveArr[j],"^",5); 
		var OrderHiddenPara=mPiece(UnsaveArr[j],"^",6);
		var PHCDoseUOMDesc=mPiece(OrderHiddenPara,String.fromCharCode(3),9);
		var OrderCoverMainIns=mPiece(UnsaveArr[j],"^",7);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderName",OrderName);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderDoseQty",OrderDoseQty);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderARCIMID",OrderARCIMID);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderPrice",OrderPrice);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderHiddenPara",OrderHiddenPara);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderSum",OrderSum);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderDoseUOM",PHCDoseUOMDesc);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderPhSpecInstr",OrderPhSpecInstr);
		SetCellData(FocusRowIndex,FocusGroupIndex,"OrderCoverMainIns",OrderCoverMainIns);
		if (OrderHiddenPara!=""){
	        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
	        var  IsARCOSFormula= $.cm({
				ClassName:"web.UDHCPrescript",
				MethodName:"IsARCOSFormula",
				dataType:"text",
				ARCOSRowid:ARCIMARCOSRowid
			},false);
	        if (IsARCOSFormula=="1"){
		        ChangeRowStyle1(FocusRowIndex,FocusGroupIndex,true);
		    }else{
			    ChangeRowStyle1(FocusRowIndex,FocusGroupIndex,false);
			}
	    }else{
		    ChangeRowStyle1(FocusRowIndex,FocusGroupIndex,false);
		}
		//var select_id=FocusRowIndex+"_OrderPhSpecInstr"+FocusGroupIndex
		//$("#"+select_id+" option[value='"+OrderPhSpecInstr+"']").attr("selected", "selected");
	}
	SetScreenSum();
	
	if (Count>0){
		var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
		if ((records==FocusRowIndex)&&(FocusGroupIndex==GlobalObj.ViewGroupSum)) {
			Add_CMOrdEntry_row();
		}else{
			FocusGroupIndex=eval(FocusGroupIndex)+1;	
			SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
		}
	}
}
function CardBillClick(){
	var EpisodeID = GlobalObj.EpisodeID;
    var PatientID = GlobalObj.PatientID;
    if (EpisodeID == "") { $.messager.alert("��ʾ", "ȱ�ٻ�����Ϣ!"); return; }
    DHCACC_GetCardBillInfo(PatientID,function(CardInfo){
		var CardNo=CardInfo.split("^")[0];
		var CardTypeRowId=CardInfo.split("^")[1];
		if (CardNo==""){
			$.messager.alert("��ʾ", "��Ч�Ŀ���Ϣ!"); return; 
		}
		if (GlobalObj.CheckOutMode == 1) {
		    $.messager.confirm('��ʾ', '�Ƿ�ȷ�Ͽ۷�?', function(r){
				if (r){
					var CardTypeDefine = tkMakeServerCall("web.UDHCOPOtherLB","ReadCardTypeDefineListBroker1",CardTypeRowId);
					$("#CardBillCardTypeValue").val(CardTypeDefine);
				    var insType = GlobalObj.OrderBillTypeRowid;
			        var oeoriIDStr = "";
			        var guser = session['LOGON.USERID'];
			        var groupDR = session['LOGON.GROUPID'];
			        var locDR = session['LOGON.CTLOCID'];
			        var hospDR = session['LOGON.HOSPID'];
			        var rtn = checkOut(CardNo, PatientID, EpisodeID, insType, oeoriIDStr, guser, groupDR, locDR, hospDR,CardBillAfterReload);
			        //CardBillAfterReload();
				}
			});
	    }else{
		 	var url = "dhcbill.opbill.charge.main.csp?ReloadFlag=3&CardNo=" + CardNo + "&SelectAdmRowId=" +  GlobalObj.EpisodeID + "&SelectPatRowId=" + GlobalObj.PatientID + "&CardTypeRowId=" + CardTypeRowId;
			websys_showModal({
				url: url,
				title: 'Ԥ�۷�',
				iconCls: 'icon-w-inv',
				width: '97%',
				height: '85%',
				onClose: function() {
					CardBillAfterReload();
				}
			});
		}
	});
    return;
}
function CardBillAfterReload(){
    if (GlobalObj.PAAdmType!="I"){
	    if (parent.refreshBar){
        	parent.refreshBar();
        }else if(parent.parent.refreshBar){
	        parent.parent.refreshBar();
	    }else{
        	parent.parent.opdoc.patinfobar.view.InitPatInfo(GlobalObj.EpisodeID);
        }
    }
}
function DocumentUnloadHandler(e){
  if (GlobalObj.StoreUnSaveData!="1"){return}
  try{
	var Str="";
		var UnsaveData="";
		if (!UpdateFlag) {
			var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
					var OrderARCIMID=GetCellData(i,j,"OrderARCIMID");
				    if (OrderARCIMID!=""){
					    var OrderName=GetCellData(i,j,"OrderName");
					    var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
					    var OrderPhSpecInstr=GetCellData(i,j,"OrderPhSpecInstr");
					    var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
					    var OrderPrice=GetCellData(i,j,"OrderPrice");
					    var OrderOrderSum=GetCellData(i,j,"OrderSum");
					    var OrderCoverMainIns=GetCellData(i,j,"OrderCoverMainIns");
						Str=OrderARCIMID+"^"+OrderName+"^"+OrderDoseQty+"^"+OrderPhSpecInstr+"^"+OrderPrice+"^"+OrderOrderSum+"^"+OrderHiddenPara+"^"+OrderCoverMainIns;
						if (UnsaveData==""){UnsaveData=Str}else{UnsaveData=UnsaveData+String.fromCharCode(2)+Str;}
				    }
				}
			}
			//if (UnsaveData=="") return ;
			var PrescDurationID=$("#PrescDuration").combobox('getValue');
			var PrescInstructionID=$("#PrescInstruction").combobox('getValue');
			var PrescFrequenceID=$('#PrescFrequence').combobox('getValue');
			var RecLoc=$('#RecLoc').combobox('getValue');
			var PrescOrderQty=$('#PrescOrderQty').combobox('getText');
			var PrescPrior=$('#PrescPrior').combobox('getValue');
			var PrescAppenItemQty=$('#PrescAppenItemQty').val();
			var PrescNotes=$('#PrescNotes').val();
			//var CMPrescTypeSel=$("#CMPrescType").combobox('getValue');
			//var CMPrescTypeDetails = $("#CMPrescType").combobox('getValue');
			var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
			var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
			var CMPrescTypeSel=CMPrescTypeDetails;
		    var DetailsArr=CMPrescTypeDetails.split("#");
		    var SelPrescTypeCode=DetailsArr[0];
			var PrescEmergency="N";
			var StartDate="";
			var EndDate="";
			var ARCOSRowId=PageLogicObj.m_ARCOSRowId; //$('#ARCOSRowId').val();
			var PrescUrgent=$("#PrescUrgent").checkbox('getValue')?"Y":"N"; //�Ƿ�Ӽ�	
			var CookMode=$('#CookModelist').combobox('getValue');
			var TakingMedicineMethod=""
			if (GlobalObj.TakingMedicineShowFlag=="Y"){
				var TakingMedicineMethod=$('#TakingMedicineMethod').combobox('getValue');
			 }					
			Str = PrescDurationID + "^" + PrescInstructionID + "^" + RecLoc + "^" + PrescFrequenceID + "^" + PrescOrderQty + "^" + PrescPrior + "^" + PrescAppenItemQty + "^" + PrescNotes + "^" + PrescEmergency + "^" + StartDate + "^" + EndDate + "^" + ARCOSRowId + "^" + SelPrescTypeCode + "^"+ PageLogicObj.IsARCOSFormula+"^"+PrescUrgent+"^"+CookMode+"^"+TakingMedicineMethod;
			if (UnsaveData!="") UnsaveData=UnsaveData+String.fromCharCode(12)+Str;
		}           
		var UserID=session['LOGON.USERID'];
		var SessionFieldName="UserUnSaveDataCM"+GlobalObj.EpisodeID;
		/*var rtn=$.cm({
			ClassName:"web.DHCDocOrderEntry",
			MethodName:"SetUserCMUnSaveData",
			dataType:'text',
			Name:SessionFieldName, 
			Value:UnsaveData
		},false);*/
		/*$cm({
			ClassName:"web.DHCDocOrderEntry",
			MethodName:"SetUserCMUnSaveData",
			Name:SessionFieldName, 
			Value:UnsaveData
		},function(jsonData){
			alert(jsonData)
		});*/
		$.cm({
			ClassName:'web.DHCDocOrderEntry',
			MethodName:'SetUserCMUnSaveData',
			Name:SessionFieldName, Value:UnsaveData,
			type:'BEACON'
		});
	} catch(e) {dhcsys_alert(e.message);}
}
function onBeforeCloseTab(){
	DocumentUnloadHandler();
	return true;
}
function isNumber(objStr){
	 strRef = "-1234567890.";
	 for (i=0;i<objStr.length;i++) {
	  tempChar= objStr.substring(i,i+1);
	  if (strRef.indexOf(tempChar,0)==-1) {return false;}
	 }
	 return true;
}
function ServerObj() {
	var PrescDoseQty=0;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    for (var i=1; i<=rows; i++){
		for (var j=1; j<5; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			if (OrderARCIMRowid!=""){
				var OrderName=GetCellData(i,j,"OrderName");
				var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
				PrescDoseQty=parseFloat(PrescDoseQty)+parseFloat(OrderDoseQty);
			}
		}
	}
	var PrescDur=$('#PrescDuration').val();
	var PrescDurFactor=mPiece(PrescDur,"^",1)
	var PrescSumQty=PrescDoseQty*PrescDurFactor;
	return PrescSumQty;
}
function CheckPrescItemAndCount(ItemDesc,ArcimRowid,ARCIMDetail){
	var BillGrpDesc=mPiece(ARCIMDetail,"^",0);
	var FormDesc=mPiece(ARCIMDetail,"^",1);
	var ItemCatRowid=mPiece(ARCIMDetail,"^",2);
	var GenericName=mPiece(ARCIMDetail,"^",3);
	var PrescCheck=CheckDupOrderItem(ArcimRowid,GenericName);
	if (PrescCheck=="1"){
		dhcsys_alert(ItemDesc+t['SAME_PrescORDERITEM']);
	    return false;
	}else if((PrescCheck=="2")&&(GlobalObj.CheckPrescItemAndCount=="1")){
		dhcsys_alert(GenericName+"�Ѵ�����ͬͨ������"+GenericName+"����ҽ��,һ�Ŵ����������ظ�!");
	    return false;
	}
	//�˴��ɰ�δ������,�밴����Ŀ������������Ӧ�޸�
	/*var PrescCheck=CheckPrescriptItem(ItemCatRowid);
	if (PrescCheck==false){
		$.messager.alert("��ʾ",ItemDesc+t['LIMIT_PRESCITEM']);
		return false;
	}*/
	return true;
}
function CheckDupOrderItem(ARCIMRowid,GenericName){
	var CurrCellPos=FocusRowIndex+"^"+FocusGroupIndex;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    for (var i=1; i<=rows; i++){
		for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			var CellPos=i+"^"+j;
			if (OrderARCIMRowid!=""){
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
				var OrderGenericName=OrderHiddenPara.split(String.fromCharCode(3))[11];
				if ((ARCIMRowid==OrderARCIMRowid)&&(CellPos!=CurrCellPos)){return 1;}
				if ((GenericName==OrderGenericName)&&(CellPos!=CurrCellPos)){return 2;}
			}
		}
	}	
	/*��ҩӦ�ò����ж���ʷҽ�� �˴��ɰ�������� ���°���Ҫ�ж������޸�
	var CheckSameOrderItem=document.getElementById('FindSameOrderItem');
	if (CheckSameOrderItem) {
		var encmeth=CheckSameOrderItem.value;
		var obj=document.getElementById('EpisodeID');
	var PAADMRowid=obj.value;
	//$.messager.alert("��ʾ","PAADMRowid"+PAADMRowid+"ARCIMRowid:"+ARCIMRowid);
		var retDetail=cspRunServerMethod(encmeth,PAADMRowid, ARCIMRowid);
	  if (retDetail==1) return true;
	}
	*/
	return "";
}

function BaseValidCheck(ParamObj) {
    if (ParamObj.OrderItemInValid == 1) {
        dhcsys_alert(ParamObj.idesc + t['ItemInValid']);
        return false;
    }
    if (ParamObj.OrderAuthInValid == 0) {
        dhcsys_alert(ParamObj.idesc + t['NOT_ORDERED']);
        return false;
    }
    if (ParamObj.ireclocstr == "") {
        dhcsys_alert(ParamObj.idesc + t['NO_RECLOC']);
        return false;
    }
    if (ParamObj.AlertAuditSpecialItem != 0) {
        var NeedInsuAudit = dhcsys_confirm(ParamObj.idesc + t['NeedInsuAudit']);
        if (NeedInsuAudit == false) return false;
    }
    if (ParamObj.ASCheckFlag == 1) {
        dhcsys_alert(t['ASCheck1'] + ParamObj.idesc + t['ASCheck2'] + ParamObj.ASCheckSex + t['ASCheck3'] + ParamObj.ASCheckAgeRange);
        return false;
    }
    //�ж�ҽ�����е��ż�������
    if (ParamObj.CheckArcimTypeStr!=""){
        dhcsys_alert(ParamObj.idesc + ParamObj.CheckArcimTypeStr);
        return false;
    }
    return true;
}
function CheckItemPoison(ItemDesc, PHPoisonCode) {
    //������ҩƷ�ж����֤���Ƿ���ڣ��������ڣ����뱣��
    if ((PHPoisonCode == 'J2') || (PHPoisonCode == 'J1') || (PHPoisonCode == 'DX') || (PHPoisonCode == 'MZ')) {
	    var PrescPrior=$('#PrescPrior').combobox('getValue');
	    if ((PrescPrior==GlobalObj.OutOrderPriorRowid)&&(GlobalObj.OutPriorAllowPoisonDrug==0)){
		    dhcsys_alert(ItemDesc + "��Ժ��ҩ��������������ҩƷ!")
        	return false;
		}
    	var IDCardNo = $.cm({
			ClassName:"web.DHCDocOrderEntry",
			MethodName:"FindPAPMIID",
			dataType:"text",
			PatientID:GlobalObj.PatientID
		},false);
        if (IDCardNo == '') {
            var lnk = "dhcdoccheckpoison.csp?PatID=" + GlobalObj.EpisodeID;
            var retval = window.showModalDialog(lnk, "", "dialogwidth:575px;dialogheight:180px;status:no;center:1;resizable:no");
            if (retval) {
	            var rtn = $.cm({
					ClassName:"web.DHCDocCheckPoison",
					MethodName:"UpdateAgencyInfo",
					dataType:"text",
					EpisodeID:GlobalObj.EpisodeID,
					PatInfo:retval
				},false)
                if (rtn == "-100") {
                    dhcsys_alert(ItemDesc + t['POISONSAVE_FAILED'])
                    return false;
                }
            } else {
                dhcsys_alert(ItemDesc + t['POISON_ALERT'])
                return false;
            }
        }
    }
    if ((PHPoisonCode == 'DBTHZJ') || (PHPoisonCode == 'TLJS')) {
        dhcsys_alert(ItemDesc + t['POISON_SPORT_ALERT'])
        return true;
    }
    return true;
}
function CheckPHInteractWith(CurrDrugItemRowid) {
    if (CurrDrugItemRowid == "") return false;
    var OrderDrugItemRowid;
    var OrderDrugItemRowidStr = "";
    var CurrCellPos = FocusRowIndex + "^" + FocusGroupIndex;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    for (var i=1; i<=rows; i++){
		for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			var CellPos=i+"^"+j;
			if ((OrderARCIMRowid != "") && (CellPos != CurrCellPos)) {
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
				OtherDrugItemRowid = mPiece(OrderHiddenPara, String.fromCharCode(3), 2)
				if (OrderDrugItemRowidStr == "") {
                    OrderDrugItemRowidStr = OtherDrugItemRowid;
                } else {
                    OrderDrugItemRowidStr = OrderDrugItemRowidStr + "^" + OtherDrugItemRowid;
                }
			}
		}
	}	
    if (OrderDrugItemRowidStr != "") {
    	var ret = $.cm({
			ClassName:"web.DHCDocOrderCommon",
			MethodName:"CheckPHInteractWith",
			dataType:"text",
			DrgItemRowid:CurrDrugItemRowid, 
			OtherDrgItemRowids:OrderDrugItemRowidStr
		},false);
        var Find = mPiece(ret, "^", 0);
        var DrugItemDesc = mPiece(ret, "^", 1);
        if (Find == "1") {
            dhcsys_alert(t['InteractWith'] + ":" + DrugItemDesc);
            return true;
        }
    }
    return false
}
//�ж���������ѡ�Ĵ��������Ƿ����
function AtuoSelectPrescTypeList(OrderItemCatRowid, idesc){
    var ArcimStr=GetArcimStr();
    //var CMPrescTypeDetails = $("#CMPrescType").combobox('getValue');
    var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
    var DetailsArr=CMPrescTypeDetails.split("#");
    var SelPrescTypeCode=DetailsArr[0];
    var CNItemCatStr=DetailsArr[5];
    if (("^"+CNItemCatStr+"^").indexOf("^"+OrderItemCatRowid+"^")<0){
        var PrescTypeIndex=GetCNMedPrescTypeIndex(OrderItemCatRowid);
        /*var sbox=$HUI.combobox("#CMPrescType")
        var CMPrescTypeData = sbox.getData();
		var PrescType= CMPrescTypeData[PrescTypeIndex].desc;*/
		var PrescType="";
		var Data=$("#CMPrescTypeKW").keywords('options').items;
		for (var i=0;i<Data.length;i++){
			var CMPrescTypeCode=Data[i].id;
			if (CMPrescTypeCode==PrescTypeIndex){
				PrescType=Data[i].text;
				break;
			}
		}
        if (ArcimStr==""){
            var conflag = dhcsys_confirm(idesc + "Ϊ"+PrescType+"ҩƷ,�Ƿ�ȷ��¼��"+PrescType+"����?");
            if (conflag) {
                $("#CMPrescTypeKW").keywords('select',PrescTypeIndex);
            }else{
                return false;
            }
            return true;
        }else{
            dhcsys_alert(idesc + "Ϊ"+PrescType+"ҩƷ,������¼��");
            return false;
        }
    }
    return true;
}
///��ȡ������Ӧ�����Ĵ�������
function GetCNMedPrescTypeIndex(OrderItemCatRowid){
    var PrescTypeIndex="";
    //var sbox = $HUI.combobox("#CMPrescType");
	//var Data=sbox.getData();
	var Data=$("#CMPrescTypeKW").keywords('options').items;
	for (var j=0;j<Data.length;j++){
		var CNItemCatStr=Data[j].value.split("#")[5];
		if (("^"+CNItemCatStr+"^").indexOf("^"+OrderItemCatRowid+"^")>=0){
            //var PrescTypeIndex=j;
            var PrescTypeIndex=Data[j].id;
            break;
        }
	}
    return PrescTypeIndex;
}
function CheckConflict(ARCIMRowid, idesc) {
    //ʮ�˷�ʮ��η�ж�
    var ARCIMRowidNextAll = ""
    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
    for (var i=1; i<=rows; i++){
		for (var j=1; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			if (OrderARCIMRowid != "") {
				if (ARCIMRowidNextAll == "") ARCIMRowidNextAll = OrderARCIMRowid;
                else ARCIMRowidNextAll = ARCIMRowidNextAll + "^" + OrderARCIMRowid;
			}
		}
	}	
	var CheckCMLimitFlag = $.cm({
		ClassName:"web.DHCDocOrderEntryCM",
		MethodName:"GetCMLimitInfo",
		dataType:"text",
		ARCIMRowId:ARCIMRowid, ARCIMRowIdNextALL:ARCIMRowidNextAll
	},false);
    if (CheckCMLimitFlag != "") {
        var rtn = dhcsys_confirm(idesc + " " + CheckCMLimitFlag + $g(",�Ƿ�ȷ��¼��?"))
        if (!rtn) {
            SetFocusColumn("OrderName" + FocusGroupIndex, FocusRowIndex);
            return false;
        }
    }else{
	    var ret = $.cm({
			ClassName:"web.DHCDocOrderEntryCM",
			MethodName:"CheckConflict",
			dataType:"text",
			EpisodeID:GlobalObj.EpisodeID, ArcimRowid:ARCIMRowid
		},false);
        var CheckConflict=mPiece(ret,"^",0)
        var ConflictInfo=mPiece(ret,"^",1)
        if (CheckConflict=="Y")  {
            dhcsys_alert(idesc+ConflictInfo+$g("����!")); //$.messager.
        }
	}
    return true;
}
function CheckComboValue(id,CombValue)
{
	var NodeName=$.trim($("#"+id).parent().prev().text());
	var Value=$("#"+id).combobox('getValue');
	if(Value=="") {
		$.messager.alert('��ʾ',NodeName+' ����Ϊ��,������ѡ��');
		return false;
	}
	var DataArr=$("#"+id).combobox('getData');
	var i=0;
	for(i=0;i<DataArr.length;i++){
		var cmd="var val=DataArr[i]."+CombValue;
		eval(cmd);
		if(val==Value) break;
	}
	if(i<DataArr.length) return true;
	$.messager.alert('��ʾ',NodeName+' ֵ��Ч,������ѡ��!',"info",function(){
		$('#'+id).next('span').find('input').focus();
	});
	return false;
}
function GetPrescWeight() {
    var PrescDoseQty = 0;
    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
    for(var i=1;i<=rows;i++){
		var Row=i;
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
		   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
		   if (OrderARCIMRowid!=""){
			   var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
			   PrescDoseQty = parseFloat(PrescDoseQty) + parseFloat(OrderDoseQty);
		   }
		}
	}
    var PrescDurFactor = GetDurFactor();
    var PrescSumQty = PrescDoseQty * PrescDurFactor;
    return PrescSumQty;
}
function GetDurFactor(){
	var DurationRowid=$('#PrescDuration').combobox("getValue");
	if (DurationRowid=="") return "1";
	return PageLogicObj.PrescDurFactor;
}
function SaveOrderToEMR() {
	var argObj={
		EpisodeID:GlobalObj.EpisodeID,
		PAAdmType:GlobalObj.PAAdmType
    }
	var OrdList=Common_ControlObj.AfterUpdate("SaveOrderToEMR",argObj);
	return OrdList;
}
function ClearList() {
    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");
	for (var i=1;i<=rows;i++){
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
			ClearGroupData(i,j);
		}
	}
	SetFocusColumn("OrderName1", 1)
}
function StopPrescClickHandler(){
	var selVal=$('#PrescList').combobox("getValue");
	if (selVal!=""){
		var PrescNo=selVal.split("^")[0];
		if (PrescNo!=""){
			var rtn = $.cm({
				ClassName:"web.UDHCPrescript",
				MethodName:"CheckStopPrescNo",
				dataType:"text",
				PrescNo:PrescNo, UserID:session['LOGON.USERID'],EpisodeID:GlobalObj.EpisodeID
			},false);
			var rtnArr=rtn.split("^")
			if (rtnArr[0]!=0){
				$.messager.alert("��ʾ",PrescNo + $g(" ������ֹͣ:") + $g(rtnArr[1]));
        		return false;
			}
			StopPrescList(PrescNo);
		}else{
			$.messager.alert("��ʾ","���ڴ����б��У�ѡ����Ч�Ĵ�����¼!");
			return false;
		}
	}else{
		$.messager.alert("��ʾ","���ڴ����б��У�ѡ����Ч�Ĵ�����¼!");
		return false;
	}
}
function addSelectedFav(itemid,text,note,partInfo,callBackFun) {
	if (GlobalObj.warning != "") {
        $.messager.alert("����",GlobalObj.warning);
        return false;
    }
    var ItemType=itemid.indexOf("||")>-1?'ARCIM':'ARCOS';
    var PhSpecInstr=note||'';
	new Promise(function(resolve,rejected){
		CheckFormulaCanAppendItem("",resolve);
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) return false;
			FindNullCell();
			if (ItemType=="ARCOS") {
				OSItemListOpen(itemid,text,'YES','');
				if (callBackFun) callBackFun();
				return;
			}
			//�ж��Ƿ�������
			CheckDiagnose(itemid,resolve);
		})
	}).then(function(rtn){
		return new Promise(function(resolve,rejected){
			if (!rtn) return false;
			var findcell = FindNullCell();
	        if (!findcell) return false;
	        ClearGroupData(FocusRowIndex, FocusGroupIndex);
			var OrderPhSpecInstr='';
			if (PhSpecInstr!="") {
				$("#"+FocusRowIndex+"_OrderPhSpecInstr"+FocusGroupIndex+" option").each(function(){
					if (PhSpecInstr==$(this).text()) {
						OrderPhSpecInstr=$(this).val();
						return false;
					}
				})
			}
			var OrdParamsArr=new Array();
			OrdParamsArr.push({
				OrderARCIMRowid:itemid,
				ParamS:'',
				OrderPhSpecInstr:OrderPhSpecInstr
			});
			AddItemToList(FocusRowIndex,FocusGroupIndex,OrdParamsArr,resolve);
		})
	}).then(function(ret){
		if (ret==false) {
			ClearGroupData(FocusRowIndex,FocusGroupIndex);
		}else{
			SetScreenSum();
			var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
			if (FocusGroupIndex==GlobalObj.ViewGroupSum){
				var cbox=$HUI.checkbox("#DrugAndQtyYQ");
				if (!cbox.getValue()){
					if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
					FocusGroupIndex=1;
					FocusRowIndex=eval(FocusRowIndex)+1;
					SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
				}
			}
		}
		if (callBackFun) callBackFun();
	})
}
function DisableBtn(id,disabled){
	if (disabled){
		$HUI.linkbutton("#"+id).disable();
	}else{
		$HUI.linkbutton("#"+id).enable();
	}
}
function CheckDiagnose(OrderARCIMRowid,callBackFun) {
	if ((GlobalObj.OrderLimit==1)||(GlobalObj.PAADMMotherAdmId!="")||(GlobalObj.PAAdmType=="H")) {
		callBackFun(true);
		return;
	}
	var CMOrdNeedTCMDiag=0;
	var ItemCatRowid=tkMakeServerCall("web.DHCDocOrderCommon", "GetOrderSubCat", OrderARCIMRowid);
	if (GlobalObj.CMOrdNeedTCMDiagCat.indexOf("^"+ItemCatRowid+"^") >=0) {
		CMOrdNeedTCMDiag=1;
	}
	new Promise(function(resolve,rejected){
		var NeedDiagnosFlag = 1;NoDiagnosMsg="";
	    if (CMOrdNeedTCMDiag == 1){
		    var Ret=tkMakeServerCall("web.DHCDocOrderEntry", "GetCMMRDiagnoseCount", GlobalObj.mradm);
		    GlobalObj.MRDiagnoseCount = Ret;
		    NoDiagnosMsg="û����ҽ���,����¼��!";
		}else{
			//�����ﲡ������,¼����ϻ�ɾ����Ϻ�δˢ��ҽ��¼�����,�����������ȡ�Ĵ���
	    	var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", GlobalObj.mradm);
	    	GlobalObj.MRDiagnoseCount = Ret;
	    	NoDiagnosMsg="û�����,����¼��!";
		}
		if ((GlobalObj.MRDiagnoseCount == 0) && (NeedDiagnosFlag == 1)) {
			$.messager.alert("��ʾ",NoDiagnosMsg,"info",function(){
				var iframeName = window.name
		        if (iframeName == "") {
		            iframeName = window.parent.frames["oeordFrame"]?window.parent.frames["oeordFrame"].name:'';
		        }
		        if ((iframeName == "oeordFrame")||(GlobalObj.CareProvType != "DOCTOR")) {
		            resolve(false);
		        }else{
					websys_showModal({
						url:"diagnosentry.v8.csp?PatientID=" + GlobalObj.PatientID + "&EpisodeID=" + GlobalObj.EpisodeID + "&mradm=" + GlobalObj.mradm+"&CMDisFlag="+CMOrdNeedTCMDiag,
						title:'���¼��',
						//width:((websys_getTop().screen.width - 100)),height:(websys_getTop().screen.height - 120),
						width:"90%",height:(websys_getTop().screen.height - 120),
						invokeChartFun:parent.invokeChartFun||parent.parent.invokeChartFun,
						onClose:function(){
							if (CMOrdNeedTCMDiag == 1){
							    var Ret=tkMakeServerCall("web.DHCDocOrderEntry", "GetCMMRDiagnoseCount", GlobalObj.mradm);
							}else{
						    	var Ret = tkMakeServerCall("web.DHCDocOrderEntry", "GetMRDiagnoseCount", GlobalObj.mradm);
							}
				            GlobalObj.MRDiagnoseCount = Ret;
				            if (Ret == 0) { 
				            Ret = false; 
				            PageLogicObj.IsARCOSFormula=0;
				            } else { Ret = true; }
							resolve(Ret);
						}
					})
			    }
			})
	    }else{
		    callBackFun(true);
		}
	}).then(function(rtn){
		callBackFun(rtn);
	})
}
function ARCOSChangePrescType(ARCOSRowid,CallBackFun){
	if (typeof CallBackFun!="function"){
		CallBackFun=function(){};
	}
	var ARCOSPrescTypeStr = $.cm({
		ClassName:"web.UDHCFavItemNew",
		MethodName:"GetARCOSPrescType",
		dataType:"text",
		ARCOSItemRowid:ARCOSRowid,
		CurLogonHosp:session['LOGON.HOSPID']
	},false);
    if (ARCOSPrescTypeStr==""){CallBackFun();return true}
    var ARCOSPrescTypeCodeStr=ARCOSPrescTypeStr.split("^")[0];
    if (ARCOSPrescTypeCodeStr=="") {CallBackFun();return true}
	var ARCOSPrescTypeCodeArr=ARCOSPrescTypeCodeStr.split('!');
    var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var CMPrescTypeName=CMPrescTypeKWSel[0].text
    var DetailsArr=CMPrescTypeDetails.split("#");
    var SelPrescTypeCode=DetailsArr[0];
    new Promise(function(resolve,rejected){
	    if (ARCOSPrescTypeCodeArr.indexOf(SelPrescTypeCode)==-1){
			///�������͵��Զ��л��¼��п��ܰ���ת����ص����ѣ����AutoConvertPrescForm�еĴ���
			///ת��������ص����ݣ����callback�ĵ����������������ֵ�Ӱ�죬��AutoConvertPrescForm�ĵ�����̫��
			///������ֱ���ж��Ƿ������������ݣ��������֣�����ҽ���ֹ�ȥѡ���л��������ͣ�����AutoConvertPrescForm�����ݴ�����Ϻ�
			///��¼���ҽ����
			///----tanjishan
			///AutoConvertPrescForm�ڲ������AddItemToList�� �漰�ĵ�������̫�࣬����ֱ������ҽ���Ƿ��ֹ�������
			var HaveOrdItemFlag="N";
			//console.log(ARCOSPrescTypeStr)
			var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
			for(var i=1;i<=rows;i++){
				var Row=i;
				for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
				   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
				   if (OrderARCIMRowid!=""){
					    HaveOrdItemFlag="Y";
					    break;
				   }
			    }
			    if (HaveOrdItemFlag=="Y"){
					break;  
				}
			}
			if (HaveOrdItemFlag=="Y"){
				$.messager.confirm('��ʾ', "��ǰ�б��д���δ��˵�"+CMPrescTypeName+"ҽ����뵱ǰҽ�������ڲ�ͬ�������ͣ����л��������ͺ������¿�����ҽ���ף��Ƿ��Զ��л�?", function(r){
					if (r) {
						var Data=$("#CMPrescTypeKW").keywords('options').items;
						for (var i=0;i<Data.length;i++){
							var CMPrescTypeCode=Data[i].id;
							if (ARCOSPrescTypeCodeArr.indexOf(CMPrescTypeCode)>-1){
								$("#CMPrescTypeKW").keywords('select',CMPrescTypeCode);
								break;
							}
						}
					}
				});
				///ҽ���ײ��ټ���¼��
				return false;
			}
		}
		resolve();
    }).then(function(){
	    if (ARCOSPrescTypeStr.split("^").length>1){
		    SetCNInfoByOS(ARCOSPrescTypeStr);
		}
		CallBackFun();
		/*
		if (SelPrescTypeCode==ARCOSPrescTypeCode){return true}
		var Data=$("#CMPrescTypeKW").keywords('options').items;
		for (var i=0;i<Data.length;i++){
			var CMPrescTypeCode=Data[i].id;
			if (CMPrescTypeCode==ARCOSPrescTypeCode){
				$("#CMPrescTypeKW").keywords('select',CMPrescTypeCode);
				break;
			}
		}
		*/
    });
}
//��ҽ������Ϣ����ֵ:
function SetCNInfoByOS(CNInfoStr)
{
	if(CNInfoStr){
	    var CNArr=CNInfoStr.split(String.fromCharCode(2));
		var PrescTypeCode=CNArr[0].split("^")[0];
		var DoseQtyId=CNArr[1].split("^")[0];
		var FreqStr=CNArr[2];
		var InstrStr=CNArr[3];
		var DuratStr=CNArr[4];
		var Notes=CNArr[5];
        var Data=$("#CMPrescTypeKW").keywords('options').items;
        var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
		var CMPrescTypeSelCode=CMPrescTypeKWSel[0].id;
		if (CMPrescTypeSelCode!=PrescTypeCode) {
			for (var i=0;i<Data.length;i++){
				if (PrescTypeCode==Data[i].id){
					$("#CMPrescTypeKW").keywords('select',PrescTypeCode);
					SetPrescAppenItemQty();
					break;
				}
			}
		}
	    var FormInstrRowid=InstrStr.split("^")[0]
		var sbox = $HUI.combobox("#PrescInstruction");
		if ($.hisui.indexOfArray(sbox.getData(),"HIDDEN",FormInstrRowid)<0) FormInstrRowid="";
		sbox.select(FormInstrRowid);
	    $("#PrescInstruction").combobox('select',FormInstrRowid);
	    var data=$('#PrescOrderQty').combobox('getData')
        for (var j = 0; j < data.length; j++) {
            if (DoseQtyId==data[j].Code){
	            $("#PrescOrderQty").combobox('select',data[j].Code);
                break;
            }
        }
	    $("#PrescDuration").combobox('select',DuratStr.split("^")[0]);
	    var PrescFrequence=FreqStr.split("^")[4]
		var sbox = $HUI.combobox("#PrescFrequence");
		if ($.hisui.indexOfArray(sbox.getData(),"PHCFRRowid",PrescFrequence)<0) PrescFrequence="";
		sbox.select(PrescFrequence);
	    $("#PrescNotes").val(Notes);
	}
}
function PrescInstrLookUpSelect(){
	//var CMPrescTypeDetails=$HUI.combobox("#CMPrescType").getValue();
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
	var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
	var DetailsArr=CMPrescTypeDetails.split("#");
    var DefaultQtyStr=DetailsArr[4];
    var DefaultQtyID=mPiece(DefaultQtyStr, "!", 0);
	ResetPrescOrderQty(DefaultQtyID);
	$.cm({
		ClassName:'DHCDoc.OPDoc.CMOrderEntry',
		MethodName:'GetCMComList',
		ComboName:'CookMode',
		ExpStr:GlobalObj.EpisodeID+'^'+$('#PrescInstruction').combobox('getValue')
	},function(data){
		$('#CookModelist').combobox('loadData',data);
	});
}
function CheckFormulaCanAppendItem(OrderARCOSRowid,callBackFun){
    if ((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")&&(PageLogicObj.m_ARCOSRowId!=OrderARCOSRowid)){
		$.messager.alert("��ʾ","����¼��Э������,�������������ҽ��!","info",function(){
			callBackFun(false); 
		}); 
	}else{
		callBackFun(true);
	}
}
///������򰴷����ʱ��ת����
function MoveFouce(keycode,FocusRowIndex,FocusGroupIndex,FocusName){
	/*��37;��38;��39;��40*/
	var OldFocusRowIndex=FocusRowIndex;
	var OldFocusGroupIndex=FocusGroupIndex
	if ((keycode!="37")&&(keycode!="38")&&(keycode!="39")&&(keycode!="40")) {
		return false;
	}
	if (ItemzLookupGrid&&ItemzLookupGrid.store) return false;
	if (PageLogicObj.LookupPanelIsShow==1) return false;
	var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
	var cbox=$HUI.checkbox("#DrugAndQtyYQ");
	if (cbox.getValue()){
		if(keycode=="37"){
			if (FocusName=="OrderName"){
				if(FocusGroupIndex==1){
				    if (FocusRowIndex>1){
						FocusRowIndex=parseFloat(FocusRowIndex)-1;
						FocusGroupIndex=GlobalObj.ViewGroupSum;
						SetFocusColumn("OrderDoseQty"+FocusGroupIndex,FocusRowIndex);
					}else{
						SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
					}
				}else{
					FocusGroupIndex=parseFloat(FocusGroupIndex)-1;
					SetFocusColumn("OrderDoseQty"+FocusGroupIndex,FocusRowIndex);
				}
			}else if (FocusName=="OrderDoseQty"){
				SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
			}
		}else if (keycode=="38"){
			if (FocusRowIndex>1){
				FocusRowIndex=parseFloat(FocusRowIndex)-1;
			}
			SetFocusColumn(FocusName+""+FocusGroupIndex,FocusRowIndex);
		}else if (keycode=="39"){
			if (FocusName=="OrderName"){
				SetFocusColumn("OrderDoseQty"+FocusGroupIndex,FocusRowIndex);
			}else if (FocusName=="OrderDoseQty"){
				if(FocusGroupIndex==GlobalObj.ViewGroupSum){
					if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
					FocusGroupIndex=1;
					FocusRowIndex=parseFloat(FocusRowIndex)+1;
				}else{
					FocusGroupIndex=parseFloat(FocusGroupIndex)+1;
				}
				SetFocusColumn("OrderName"+FocusGroupIndex,FocusRowIndex);
			}
		}else if (keycode=="40"){
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")) { return false;}
			if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
			FocusRowIndex=parseFloat(FocusRowIndex)+1;
			SetFocusColumn(FocusName+""+FocusGroupIndex,FocusRowIndex);
		}
	}else{
		if(keycode=="37"){
			if(FocusGroupIndex==1){
			    if (FocusRowIndex>1){
					FocusRowIndex=parseFloat(FocusRowIndex)-1;
					FocusGroupIndex=GlobalObj.ViewGroupSum;
				}
			}else{
				FocusGroupIndex=parseFloat(FocusGroupIndex)-1;
			}
		}else if(keycode=="38"){
			if (FocusRowIndex>1){
				FocusRowIndex=parseFloat(FocusRowIndex)-1;
			}
		}else if(keycode=="39"){
			if(FocusGroupIndex==GlobalObj.ViewGroupSum){
				if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
				FocusGroupIndex=1;
				FocusRowIndex=parseFloat(FocusRowIndex)+1;
			}else{
				FocusGroupIndex=parseFloat(FocusGroupIndex)+1;
			}
		}else if(keycode=="40"){
			if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")) { return false;}
			if (records==FocusRowIndex) {Add_CMOrdEntry_row();}
			FocusRowIndex=parseFloat(FocusRowIndex)+1;
		}
		SetFocusColumn(FocusName+FocusGroupIndex,FocusRowIndex);
	}
	return true;
	
}

function InitPrescNotes(){
	$("#PrescNotes").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'Code',
        textField:'Desc',
        columns:[[  
			{field:'Desc',title:'����',width:350,sortable:true},
			{field:'Code',hidden:true}
        ]],
        pagination:true,
        panelWidth:500,
        panelHeight:370,
        isCombo:true,
        minQueryLen:0,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.PilotProject.DHCDocPilotProject',QueryName: 'FindDefineData',MDesc:"ҽ��¼���ֵ�",DDesc:"��ҩ¼�뱸ע"},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        //if (desc=="") return false;
			param = $.extend(param,{Alias:desc});
	    },onSelect:function(ind,item){
		    $("#PrescNotes").val(item.Desc);
		}
    });
}
/*function INSCPackSumInt(GroupIndex, Row,Type,Sum,OrderARCIMRowid){
	if (Sum==""){
		var Sum=GetCellData(Row,GroupIndex,"OrderDoseQty");
	}
	if (OrderARCIMRowid==""){
		var OrderARCIMRowid=GetCellData(Row,GroupIndex,"OrderARCIMID");
	}
	var RecLoc=$('#RecLoc').combobox('getValue');
	var RecLocDesc=$("#RecLoc").combobox('getText');
	if ((parseInt(Sum).toString() != Sum.toString())) {
        return "";
    } else {
        if (Sum > 1000000) {
            return "";
        }
    }
    var INICrowInfo="";
    var numStr =tkMakeServerCall("web.DHCDocOrderEntryCM","CheckINCIPackSum",GlobalObj.EpisodeID,OrderARCIMRowid, RecLoc,parseFloat(Sum))
    if (numStr != "") {
    	var INICConFacStr=numStr.split(String.fromCharCode(2))[0];
    	    INICrowInfo=numStr.split(String.fromCharCode(2))[1];
    	var minNear=numStr.split(String.fromCharCode(2))[2];
    	var maxNear=numStr.split(String.fromCharCode(2))[3];
    	//if (minNear==0) var minNear=maxNear
        if (INICrowInfo=="") {
            if (Sum=="1"){
            	var FindINICrowInfo=INSCPackSumInt(GroupIndex,Row,"0",maxNear,OrderARCIMRowid)
			    return FindINICrowInfo;
			}else{
	            var lnk="DHCDocSelectCMQty.csp?OrderARCIMRowid="+OrderARCIMRowid+"&RecLoc="+RecLoc+"&minNear="+minNear+"&maxNear="+maxNear;
			    var retval=window.showModalDialog(lnk,"","dialogwidth:400px;dialogheight:150px;status:no;center:1;resizable:yes");
			    if ((retval=="")||(retval==undefined)||(retval==null)||(retval==0)){
					return "";
			    }else{
				    var FindINICrowInfo=INSCPackSumInt(GroupIndex,Row,"0",retval,OrderARCIMRowid)
				    return FindINICrowInfo;
			    }
		    }
        }
    }
    if (INICrowInfo!=""){
	   	return INICrowInfo+"^"+Sum;
	}else{
	    return "";
	}
}*/
function CheckINCIPackSum(GroupIndex,Row,Type,callBackFun) {
	new Promise(function(resolve,rejected){
		var Sum=GetCellData(Row,GroupIndex,"OrderDoseQty");
		var OrderARCIMRowid=GetCellData(Row,GroupIndex,"OrderARCIMID");
		var RecLoc=$('#RecLoc').combobox('getValue');
		var RecLocDesc=$("#RecLoc").combobox('getText');
	    //�ж��µ������ǲ�����ҩ��ϵ�����
	    //Э��������Ŀ,������������
		var INICrowInfo="";
	    var RecLoc=$('#RecLoc').combobox('getValue');
	    var TakingMedicineMethod=""
	    if (GlobalObj.TakingMedicineShowFlag=="Y"){
			var TakingMedicineMethod=$("#TakingMedicineMethod").combobox('getValue');
	    }
	    var numStr =tkMakeServerCall("web.DHCDocOrderEntryCM","CheckINCIPackSum",GlobalObj.EpisodeID,OrderARCIMRowid, RecLoc,parseFloat(Sum),session['LOGON.HOSPID'],TakingMedicineMethod)
    	if (numStr != "") {
	    	var INICConFacStr=numStr.split(String.fromCharCode(2))[0];
    	    INICrowInfo=numStr.split(String.fromCharCode(2))[1];
	    	var minNear=numStr.split(String.fromCharCode(2))[2];
	    	var maxNear=numStr.split(String.fromCharCode(2))[3];
    	 	if ((Type=="1")||(INICrowInfo!="")) {
	    	 	resolve(INICrowInfo);
	    	}else{
	            //����ֱ��ѡ����������¼�� ��ʾ�ĵط���Ӧ�޸�
	            var lnk="dhcdocselectcmqty.csp?OrderARCIMRowid="+OrderARCIMRowid+"&RecLoc="+RecLoc+"&minNear="+minNear+"&maxNear="+maxNear;
	            websys_showModal({
					url:lnk,
					title:$g('��ѡ�������'),
					width:400,height:200,
					closable:false,
					CallBackFunc:function(result){
						websys_showModal("close");
						if (result=="") {
							SetFocusColumn("OrderDoseQty"+GroupIndex,Row);
							resolve("");
						}else{
							$("#"+Row+"_OrderDoseQty"+GroupIndex+"").val(result);
							new Promise(function(resolve,rejected){
								CheckINCIPackSum(GroupIndex,Row,0,callBackFun)
							}).then(function(rtnValue){
								callBackFun(rtnValue);
							})
						}
					}
				})
		    }
	    }else{
		    resolve("");
		}
	}).then(function(rtnValue){
		callBackFun(rtnValue);
	})
}

//��Ԫ��ȡֵ
function GetCellData(rowid, GroupIndex, colname) {
	var id=rowid + "_" + colname + GroupIndex;
    var CellData = "";
    if ($.isNumeric(rowid) == true) {
        var obj = document.getElementById(id);
        if (obj) {
            if (obj.type == "checkbox") {
                if ($("#" + id).prop("checked")) {
                    CellData = "Y";
                } else {
                    CellData = "N";
                }
            } else {
                CellData = $("#" + id).val();
            }
        } else {
            CellData = $("#CMOrdEntry_DataGrid").getCell(rowid, ""+colname+GroupIndex+"");
        }
    } else {
        var obj = document.getElementById(colname);
        if (obj) {
            CellData = $("#" + colname).val();
        }
    }
    return CellData;
}
//��Ԫ��ֵ
function SetCellData(rowid, GroupIndex, colname, data) {
	var id=rowid + "_" + colname + GroupIndex;
    if ($.isNumeric(rowid) == true) {
        var obj = document.getElementById(id);
        if (obj) {
            if (obj.type == "checkbox") {
                // data: true or  false
                var olddata = $("#" + id + "").prop("checked");
                if (data=="Y"){
	                $("#" + id + "").prop("checked", true);
	                }else{
		            $("#" + id + "").prop("checked", false);    
		                }
            } else {
                $("#" + id + "").val(data);
            }
        } else {
	        $("#CMOrdEntry_DataGrid").setCell(rowid, ""+colname+GroupIndex+"", data, "", "", true);
        }
    } else {
        var obj = document.getElementById(colname);
        if (obj) {
            $("#" + colname + "").val(data);
        }
    }
}
function AddCPWOrdClickHandler(){
	addOrdItemToDoc(GlobalObj.EpisodeID,"C",addOEORIByCPW,GlobalObj.PAAdmType);
}
//����ٴ�·��ҽ��
function addOEORIByCPW(StepItemIDS){
	if (StepItemIDS != '') {
        var ret = cspRunServerMethod(GlobalObj.AddMRCPWItemToListMethod, 'AddCopyItemToList', '', StepItemIDS,session['LOGON.HOSPID'],GlobalObj.EpisodeID);
    }
}
// ҩƷ˵����
function YDTS_Click() {
	/*if(GlobalObj.HLYYInterface==1){
		HLYYYDTS_Click();
	}*/
	if(GlobalObj.HLYYInterface==1){
		var OrderARCIMRowid=GetFocusARCIMRowid();
		if(OrderARCIMRowid!=""){
			Common_ControlObj.Interface("YDTS",{
				ARCIMRowid:OrderARCIMRowid
			});
		}
	}else{
		$.messager.alert("��ʾ", "δ���û�δά����Ӧ˵����","warning");	
	}
}

function GetFocusARCIMRowid(){
	if ((FocusGroupIndex==0)||(FocusRowIndex==0)){
		$.messager.alert("��ʾ","��ѡ����Ҫ�鿴��ҽ��","info");  
		return "";
	}
	var OrderARCIMRowid=GetCellData(FocusRowIndex,FocusGroupIndex,"OrderARCIMID"); 
	if (OrderARCIMRowid==""){
		$.messager.alert("��ʾ","��Ч��ҽ��,������ѡ��","warning");  
		return "";
	}
	return OrderARCIMRowid;
}
var _start  = Date.now();
function InitOrderNameLookup(rowid){
	$("input[id^='"+rowid+"_OrderName']").lookup({
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'ARCIMDesc',
        /*columns:[[  
           {field:'ARCIMDesc',title:'����',width:200,sortable:true},
           {field:'SubCategoryDesc',title:'����',width:100,sortable:true},
           {field:'Price',title:'�۸�',width:80,sortable:true},
           {field:'BillUOM',title:'��λ',width:60,sortable:true},
           {field:'StockQty',title:'���',width:90,sortable:true},
           {field:'FormDesc',title:'����',width:90,sortable:false},
           {field:'PackedQty',title:'�����',width:90,sortable:true},
           {field:'InsuNationCode',title:'ҽ�����ұ���',width:100,sortable:false},
           {field:'InsuNationName',title:'ҽ����������',width:100,sortable:false},
        ]],*/
        className:"web.DHCDocOrderEntryCM",
		queryName:"LookUpItem",
        pagination:true,
        panelWidth:800,
        panelHeight:300,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderEntryCM',QueryName: 'LookUpItem'},
        rowStyler: function(index,row){
            var Type=row["HIDDEN2"]
            var StockQty=row["StockQty"]
            if ((Type=="ARCIM")&&(StockQty==0)){
	            return 'background-color:#DDA0DD;';
            }
	    },
		onColumnsLoad:function(columns){
		},
		onLoadSuccess:function(Data){
            //����ҩƷͼ����ʽ
            PHA_COM.Drug.Tips();
        },
        onBeforeLoad:function(param){
	        //var CMPrescTypeDetails=$HUI.combobox("#CMPrescType").getValue();
	        var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
			var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
			var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
	        var desc=param['q'];
			var minQueryLen=$(this).lookup("options").minQueryLen;
			if (desc.length<minQueryLen){return false;}
	        var RelocID=$("#RecLoc").combobox('getValue');
			param = $.extend(param,{Item:desc,GroupID:session['LOGON.GROUPID'],Category:"",SubCategory:"",TYPE:'0',
									LUCategoryDesc:CMPrescTypeCode,LUSubCategoryDesc:"",
									EpisodeID:GlobalObj.EpisodeID,BillingGrp:"",BillingSubGrp:"",RelocID:RelocID,
									OrdCatGrp:"",NonFormulary:"",Form:"",Strength:"",Route:""
									
       				 });
	    },onSelect:function(ind,item){
		    var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			new Promise(function(resolve,rejected){
				OrderItemLookupSelect(ItemArr.join("^"),resolve);
			}).then(function(rtn){
				if (rtn==true) {
					var iordertype=item["HIDDEN2"];
					if (iordertype == "ARCIM") {
						DHCDocUseCount(item["HIDDEN"], "User.ARCItmMast");
					}else{
						DHCDocUseCount(item["HIDDEN"], "User.ARCOrdSets")
					}
				}
			})
		},onHidePanel:function(){
			PageLogicObj.LookupPanelIsShow=0;
			_start  = Date.now();
		},onShowPanel:function(){
			PageLogicObj.LookupPanelIsShow=1;
		},onBeforeShowPanel:function(){
			var _now = Date.now();
			if ((_now-_start)<500) return false; //��ֹ��������������ҽ������ٻس����Σ������ٴξ۽���ԭҽ��������
			if ((window.event)&&((window.event.keyCode ==40)||(window.event.keyCode ==38))) return false;
			var id=$(this)[0].id; //"1_OrderName2"
			var row=id.split("_")[0];
			var group=id.split("_")[1].split("OrderName")[1];
			var OrderName=GetCellData(row,group,"OrderName");
			var minQueryLen=$(this).lookup("options").minQueryLen;
			if (OrderName.length<minQueryLen){return false;}
			var OrderHiddenPara=GetCellData(row,group,"OrderHiddenPara");
			if (OrderHiddenPara!=""){
		        var ARCIMARCOSRowid=OrderHiddenPara.split(String.fromCharCode(3))[6];
		        PageLogicObj.IsARCOSFormula = $.cm({
					ClassName:"web.UDHCPrescript",
					MethodName:"IsARCOSFormula",
					dataType:"text",
					ARCOSRowid:ARCIMARCOSRowid
				},false);
		        if (PageLogicObj.IsARCOSFormula=="1") return false;
		    }else{
		    	if ((PageLogicObj.IsARCOSFormula=="1")&& (GlobalObj.FormulaCanAppendItem=="0")) return false;
		    }
		}
    });
	$("input[id^='"+rowid+"_OrderName']").change(OrderNameChangeHandle);
}
function OrderNameChangeHandle(e){
	//var obj=websys_getSrcElement(e);
	//var Id=obj.id;
	var id=$(this)[0].id;
	var row=id.split("_")[0];
	var group=id.split("_")[1].split("OrderName")[1];
	var OrderName=GetCellData(row,group,"OrderName");
	var OrderARCIMRowid=GetCellData(row,group,"OrderARCIMID"); 
	if ((OrderName=="")&&(OrderARCIMRowid!="")){
		ClearGroupData(row, group);
	}
}
function InitLayOut() {
	//�����Ƿ����ú�����ҩ����ʾ��˵���顿��ť
	if (GlobalObj.HLYYInterface==0){
		$("#YDTS").hide();
		$("#YDTS").parent().prev().hide()
	}else{
		$("#YDTS").show();
		$("#YDTS").parent().prev().show()
	}
}
//��¼������������ʹ�ô���
function DHCDocUseCount(ValueId, TableName) {
    var rtn = tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", TableName, ValueId, session["LOGON.USERID"], "U", session["LOGON.USERID"])
}
function CMOrderOpenForAllHospClick(e,value){
	setTimeout(function(){
		//var PrescCookDecoctionFlag=$("#PrescCookDecoction").checkbox('getValue')?1:0;
		var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
		var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
		var DetailsArr=CMPrescTypeDetails.split("#");
	    SetRecLoc();
	    ///��������д�������ת������֤��ȡ����ȷ�Ľ��ܿ���
    	AutoConvertPrescForm();
	})
}

///ʵϰ�����ҽ��
function InsertPriceAdd() {
	var OrderItemStr=""
	var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected')[0].id;
	var PrescFreqRowid=$('#PrescFrequence').combobox("getValue");
	var PrescInstruction=$("#PrescInstruction").combobox('getValue');
	var PrescDuration=$("#PrescDuration").combobox('getValue');
	var AddLongOrderList=$("#AddLongOrderList").combobox('getValue');
	var PrescOrderQty=$("#PrescOrderQty").combobox('getText');
	var PrescPrior=$("#PrescPrior").combobox('getValue');
	var RecLoc=$("#RecLoc").combobox('getValue');
	var PrescNotes=$('#PrescNotes').val();
	var PrescUrgent=$HUI.checkbox("#PrescUrgent").getValue();
	var PrescCookDecoction=$('#CookModelist').combobox('getValue'); //$HUI.checkbox("#PrescCookDecoction").getValue();
	var DrugAndQtyYQ=$HUI.checkbox("#DrugAndQtyYQ").getValue();
	var DrugAndQtySplit=$HUI.checkbox("#DrugAndQtySplit").getValue();
	var PrescAppenItemQty=$('#PrescAppenItemQty').val();
	var CMOrderOpenForAllHosp=$HUI.checkbox("#CMOrderOpenForAllHosp").getValue(); //��Ժ
	var TakingMedicineMethod=""
	if (GlobalObj.TakingMedicineShowFlag=="Y"){
		var TakingMedicineMethod=$("#TakingMedicineMethod").combobox('getValue');
	}
	OrderItemStr=CMPrescTypeKWSel + String.fromCharCode(4) +  PrescFreqRowid+ String.fromCharCode(4) +PrescInstruction  + String.fromCharCode(4) + PrescDuration+ String.fromCharCode(4) +AddLongOrderList + String.fromCharCode(4) + PrescOrderQty
	OrderItemStr=OrderItemStr + String.fromCharCode(4) +  PrescPrior+ String.fromCharCode(4) +PrescAppenItemQty+String.fromCharCode(4)+RecLoc  + String.fromCharCode(4) + PrescNotes + String.fromCharCode(4) + PrescUrgent
	OrderItemStr=OrderItemStr + String.fromCharCode(4) +  PrescCookDecoction+ String.fromCharCode(4) +DrugAndQtyYQ  + String.fromCharCode(4) + DrugAndQtySplit + String.fromCharCode(4) +CMOrderOpenForAllHosp
	OrderItemStr=OrderItemStr + String.fromCharCode(4) +  $("#PrescStartDate").val()+ String.fromCharCode(4) +PageLogicObj.m_ARCOSRowId+ String.fromCharCode(4) +TakingMedicineMethod;
    var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
	for(var i=1;i<=rows;i++){
		var Row=i;
		for (var j=1;j<=GlobalObj.ViewGroupSum;j++){
		   var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID"); 
		   if (OrderARCIMRowid!=""){
			    var OrderName=GetCellData(i,j,"OrderName");
			    var OrderDoseQty=GetCellData(i,j,"OrderDoseQty");
			    var OrderPhSpecInstr=GetCellData(i,j,"OrderPhSpecInstr"); //$("#"+i+"_OrderPhSpecInstr"+j+"").find("option:selected").text();
			    var OrderPrice=GetCellData(i,j,"OrderPrice");
			    var OrderItemSum=GetCellData(i,j,"OrderSum");
				var OrderHiddenPara=GetCellData(i,j,"OrderHiddenPara");
				var OrderDoseUOM=GetCellData(i,j,"OrderDoseUOM");
                if (OrderDoseQty==""){OrderDoseUOMRowid=""}
                var OrderCoverMainIns=GetCellData(i,j,"OrderCoverMainIns"); 
				OrderItem=OrderARCIMRowid+","+OrderName+","+OrderDoseQty+","+OrderDoseUOM+","+OrderPrice +","+OrderItemSum+","+OrderHiddenPara+","+OrderPhSpecInstr+","+OrderCoverMainIns;
				if (OrderItemStr==""){OrderItemStr=OrderItem}else{OrderItemStr=OrderItemStr+String.fromCharCode(4)+OrderItem}
		   }
	    }
	}
	var Rtn = cspRunServerMethod(GlobalObj.InsertPrcaticeDocMethod,GlobalObj.EpisodeID,OrderItemStr,session["LOGON.USERID"],"C")
	return true;
}
//չʾʵϰ��ҳ��
function ShowPracticeOrder() {
    if (GlobalObj.EpisodeID) {
        websys_showModal({
			url:"ipdoc.practicedocpreorder.hui.csp?EpisodeID=" + GlobalObj.EpisodeID+"&PageType=C" ,
			title:'ʵϰ��ҽ������',
			//width:screen.availWidth-200,height:screen.availHeight-200,
            width:"96%",height:screen.availHeight-200,
			AddPracticeOrder:AddPracticeOrder
		});
    }
}
function AddPracticeOrder(PracticePreary,RowidStr){
	ClearClickHandler();
	var PracticePrearyArry=PracticePreary.split(String.fromCharCode(4))
	$("#CMPrescTypeKW").keywords('select',PracticePrearyArry[0]);
	$HUI.checkbox("#CMOrderOpenForAllHosp").setValue(PracticePrearyArry[14]=="true"?true:false);
	setTimeout(function(){
		var sbox = $HUI.combobox("#PrescFrequence");
		sbox.select(PracticePrearyArry[1]);
		var sbox = $HUI.combobox("#PrescInstruction");
		sbox.select(PracticePrearyArry[2]);
		var sbox = $HUI.combobox("#PrescDuration");
		sbox.select(PracticePrearyArry[3]);
		var sbox = $HUI.combobox("#AddLongOrderList");
		sbox.select(PracticePrearyArry[4]);
		var sbox = $HUI.combobox("#PrescOrderQty");
		sbox.setText(PracticePrearyArry[5]); //select
		var sbox = $HUI.combobox("#PrescPrior");
		sbox.select(PracticePrearyArry[6]);
		var sbox = $HUI.combobox("#RecLoc");
		sbox.select(PracticePrearyArry[8]);
		$('#PrescNotes').val(PracticePrearyArry[9]);
		$HUI.checkbox("#PrescUrgent").setValue(PracticePrearyArry[10]=="true"?true:false);
		$("#CookModelist").combobox('setValue',PracticePrearyArry[11]);
		//$HUI.checkbox("#PrescCookDecoction").setValue(PracticePrearyArry[11]=="true"?true:false);
		$HUI.checkbox("#DrugAndQtyYQ").setValue(PracticePrearyArry[12]=="true"?true:false);
		$HUI.checkbox("#DrugAndQtySplit").setValue(PracticePrearyArry[13]=="true"?true:false);
		
		setTimeout(function(){
			$('#PrescAppenItemQty').val(PracticePrearyArry[7]);
		})
		$("#PrescStartDate").val(PracticePrearyArry[15]);
		PageLogicObj.IsARCOSFormula=0;
		PageLogicObj.m_ARCOSRowId=PracticePrearyArry[16];
		if (GlobalObj.TakingMedicineShowFlag=="Y"){
			$("#TakingMedicineMethod").combobox('select',PracticePrearyArry[17]);
		}
		if (PageLogicObj.m_ARCOSRowId) {
			PageLogicObj.IsARCOSFormula = $.cm({
				ClassName:"web.UDHCPrescript",
				MethodName:"IsARCOSFormula",
				dataType:"text",
				ARCOSRowid:PageLogicObj.m_ARCOSRowId
			},false);
		}
		FocusRowIndex=1
		FocusGroupIndex=1
		for(var i=17;i<PracticePrearyArry.length;i++){
			if (PracticePrearyArry[i].indexOf(",") <=0) continue;
			FindNullCell();
			var OrderStr=PracticePrearyArry[i]
			var OrderStry=OrderStr.split(",")
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderName",OrderStry[1]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderDoseQty",OrderStry[2]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderARCIMID",OrderStry[0]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderPrice",OrderStry[4]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderDoseUOM",OrderStry[3]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderSum",OrderStry[5]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderHiddenPara",OrderStry[6]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderPhSpecInstr",OrderStry[7]);
			SetCellData(FocusRowIndex,FocusGroupIndex,"OrderCoverMainIns",OrderStry[8]);
			var ARCIMARCOSRowid=OrderStry[6].split(String.fromCharCode(3))[6];
			if (ARCIMARCOSRowid) {
				var IsARCOSFormula=$.cm({
					ClassName:"web.UDHCPrescript",
					MethodName:"IsARCOSFormula",
					dataType:"text",
					ARCOSRowid:PageLogicObj.m_ARCOSRowId
				},false);
				if (IsARCOSFormula==1){
				   ChangeRowStyle1(FocusRowIndex,FocusGroupIndex,true);
				}
			}
			SetScreenSum();
			FocusGroupIndex=FocusGroupIndex+1
			if (FocusGroupIndex>GlobalObj.ViewGroupSum){
				FocusRowIndex=FocusRowIndex+1
				FocusGroupIndex=1
			}
		}
		PageLogicObj.PractiacRowStr=RowidStr;
	})
}
///У���ܷ񽫸���ҽ����ӵ�����
function CheckItemCongeries(ItemToListDetailObj){
	var CheckBeforeAddObj={
		SuccessFlag:true,				//�Ƿ���Ҫ�������ҽ��
		UserOptionObj:new Array()
	}
	var CallBakFunS=ItemToListDetailObj.CallBakFunS;
	new Promise(function(resolve,rejected){
		///ִ�лص�����
		if (typeof ItemToListDetailObj.CallBakFunS=="object"){
			///�Ƚ����ж��Ƿ�����Ҫ�ݹ�ĺ���
			(function(callBackExecFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var CallBakFunCode=CallBakFunS[i].CallBakFunCode;
						var CallBakFunParams=CallBakFunS[i].CallBakFunParams;
						ExeItemCongeriesUserOption(CallBakFunCode,CallBakFunParams,resolve);
					}).then(function(UserOptionObj){
						if (!$.isEmptyObject(UserOptionObj)){
							CheckBeforeAddObj.UserOptionObj.push(UserOptionObj);
						}						
						i++;
						if ( i < CallBakFunS.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		}else{
			resolve();
		}
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if (CheckBeforeAddObj.UserOptionObj.length>0){
				resolve();
			}else{
				if (typeof CallBakFunS=="object"){
					///�ٽ����ж��Ƿ���Ҫ����������ͨ�ĺ���
					(function(callBackExecFun){
						function loop(i){
							new Promise(function(resolve,rejected){
								var CallBakFunCode=CallBakFunS[i].CallBakFunCode;
								var CallBakFunParams=CallBakFunS[i].CallBakFunParams;
								ExeItemCongeriesCallBackFun(CallBakFunCode,CallBakFunParams,resolve);
							}).then(function(ReturnObj){
								if (ReturnObj.SuccessFlag==false){
									CheckBeforeAddObj.SuccessFlag=false;
									callBackExecFun();
								}else{
									i++;
									if ( i < CallBakFunS.length ) {
										 loop(i);
									}else{
										callBackExecFun();
									}
								}
							})
						}
						loop(0);
					})(resolve);
				}else{
					resolve();
				}
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if (CheckBeforeAddObj.UserOptionObj.length>0){
				resolve();
			}else{
				var ErrCode=ItemToListDetailObj.ErrCode;
				var ErrMsg=ItemToListDetailObj.ErrMsg;
				if ((CheckBeforeAddObj.SuccessFlag==false)||(ErrCode==0)){
					resolve();
				}else{
					if (ErrCode!="0"){
						$.messager.alert("��ʾ",ErrMsg,"info",function(){
							$.extend(CheckBeforeAddObj, {SuccessFlag:false});
							resolve();
						});
					}
				}
			}
		})
	}).then(function(){
		ItemToListDetailObj.callBackFun(CheckBeforeAddObj)
	})
	function ExeItemCongeriesUserOption(FunCode,FunCodeParams,CallBackFun){
		///-------
		//��������������̨��ѯ���������ڶԺ���������Ӱ���confirm���㣬
		//ÿ�ζ����ֵ���������Եĸ�ֵ������Ҫ�ں�̨�����м��϶�Ӧ�Ĵ���
		//UserOptionObӦ���ٰ��������̶�����{Type:"",Value:""},���ں�̨����ʶ��
		var UserOptionObj={};
		new Promise(function(resolve,rejected){
			var ParamsArr=FunCodeParams.split(";");
			switch(FunCode)
			{
				case "SelectCMDoseQty": //������ҩ���������
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							ShowSelectCMDoseQty(ParamsArr,resolve);
						}).then(function(OrderDoseQty){
							if (OrderDoseQty!="") {
								$.extend(UserOptionObj,{Type:"SelectCMDoseQty",Value:OrderDoseQty,ARCIMRowId:ParamsArr[1]});
							}
							callBackFunExec();
						})
					})(resolve); //�˴���resolveָ����FunObj.CallBackFun(UserOptionObj);
					break;
				default:
					resolve();
					break;
			}
		}).then(function(){
			CallBackFun(UserOptionObj);
		})
	}
	/*
	����additemtolist�����Ļص���ע�⣺
	Ϊ���ݿ���ҽ����¼��ģʽ���˷����в���ֱ�Ӷ������ݽ��в�������������ݲ�������ʹ�÷��ض��󣬲���ParamObj
	*/
	function ExeItemCongeriesCallBackFun(FunCode,FunCodeParams,CallBackFun){
		var ReturnObj={SuccessFlag:true}
		var ParamsArr=FunCodeParams.split(";");
		new Promise(function(resolve,rejected){
			switch(FunCode)
			{
				case "Alert":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.alert("��ʾ",ParamsArr.join(";"),"info",function(){
								callBackFunExec();
							});
						})
					})(resolve); //�˴���resolveָ����FunObj.CallBackFun(ReturnObj);
					break;
				case "Confirm" :
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.confirm('ȷ�϶Ի���', FunCodeParams, function(r){
								if (!r) {
									ReturnObj.SuccessFlag=false;
								}
								callBackFunExec();
							});
						})
					})(resolve);
					break;	
				case "SwitchCMPrescTypeKW" :
					(function(callBackFunExec){
						var CMPrescTypeKWSel=$("#CMPrescTypeKW").keywords('getSelected');
						var CMPrescTypeDetails=CMPrescTypeKWSel[0].value;
						var CMPrescTypeCode=CMPrescTypeDetails.split("#")[0];
						if (ParamsArr[1]!=CMPrescTypeCode){
							$.messager.confirm('ȷ�϶Ի���', ParamsArr[0], function(r){
								if (r) {
									$("#CMPrescTypeKW").keywords('select',ParamsArr[1]);
									ReturnObj.SuccessFlag=true;
								}else{
									ReturnObj.SuccessFlag=false;
								}
								callBackFunExec();
							});
						}else{
							ReturnObj.SuccessFlag=true;
							callBackFunExec();
						}
					})(resolve);
					break;
				case "CheckPoison":
					(function(callBackFunExec){
						new Promise(function(resolve,rejected){
							websys_showModal({
								url:"dhcdoccheckpoison.csp?PatID=" + GlobalObj.EpisodeID,
								title:'���鴦����Ϣ��֤',
								iconCls:'icon-w-list',
								width:590,height:290,
								closable:false,
								CallBackFunc:function(retval){
									websys_showModal("close");
									if (typeof retval=="undefined"){
										retval="";
									}
									if (retval!="") {
										resolve();
										/*
										var encmeth = GlobalObj.UpdateAgencyInfoMethod;
						                if (encmeth != "") {
							                var rtn = $.cm({
												ClassName:"web.DHCDocCheckPoison",
												MethodName:"UpdateAgencyInfo",
												dataType:"text",
												EpisodeID:GlobalObj.EpisodeID,
												PatInfo:retval
											},false)
						                    if (rtn == "-100") {
							                    $.messager.alert("��ʾ",FunCodeParams + t['POISONSAVE_FAILED'],"info",function(){
													ReturnObj.SuccessFlag=false;
													resolve();
												});
						                    }else{
							                    resolve();
							                }
						                }else{
							                resolve();
							            }*/
									}else{
										$.messager.alert("��ʾ",FunCodeParams + t['POISON_ALERT'],"info",function(){
											ReturnObj.SuccessFlag=false;
											resolve();
										});
									}
								}
							})
						}).then(function(){
							callBackFunExec();
						})
					})(resolve);
					break;
				default:
					resolve();
					break;
			}
		}).then(function(){
			CallBackFun(ReturnObj);
		})
	}
}
function AddItemDataToRow(RowIndex,GroupIndex,ParamObj){
	SetCellData(RowIndex,GroupIndex,"OrderName",ParamObj.OrderName);
	SetCellData(RowIndex,GroupIndex,"OrderDoseQty",ParamObj.OrderDoseQty);
	SetCellData(RowIndex,GroupIndex,"OrderARCIMID",ParamObj.OrderARCIMRowid);
	SetCellData(RowIndex,GroupIndex,"OrderPrice",ParamObj.OrderPrice);
	SetCellData(RowIndex,GroupIndex,"OrderDoseUOM",ParamObj.PHCDoseUOMDesc);
	SetCellData(RowIndex,GroupIndex,"OrderHiddenPara",ParamObj.OrderHiddenPara);
	SetCellData(RowIndex,GroupIndex,"OrderSum",ParamObj.OrderSum);
	SetCellData(RowIndex,GroupIndex,"OrderPhSpecInstr",ParamObj.OrderPhSpecInstr);
	PageLogicObj.IsARCOSFormula=ParamObj.IsARCOSFormula;
	if (ParamObj.IsARCOSFormula==1){
	   ChangeRowStyle1(RowIndex,GroupIndex,true);
	}
	SetCellData(RowIndex,GroupIndex,"OrderCoverMainIns",ParamObj.OrderCoverMainIns);
	return true;
}
function ShowSelectCMDoseQty(ParamsArr,callBackFun) {
	var lnk="DHCDocSelectCMQty.csp?OrderARCIMRowid="+ParamsArr[1]+"&RecLoc="+ParamsArr[2]+"&minNear="+ParamsArr[3]+"&maxNear="+ParamsArr[4];
	websys_showModal({
		url:lnk,
		title:'��ҩ����ѡ��',
		width:400,height:200,
		closable:false,
		CallBackFunc:function(result){
			websys_showModal("close");
			if (typeof result=="undefined"){
				result="";
			}
			callBackFun(result);
		}
	})
}
function SetTimeLog(FunctionName, Position){
	var myDate = new Date();
    var DateTime = myDate.toLocaleString() + '.' + myDate.getMilliseconds();
    var TimeLogStr = 'FunctionName:' + FunctionName + ',Position:' + Position + ',DateTime:' + DateTime;
    console.log(TimeLogStr);
    return;
}
function CheckBeforeSaveToServer(OrderItemStr,callBackFun) {
    var UserAddRowid = session['LOGON.USERID'];
    var UserAddDepRowid = session['LOGON.CTLOCID'];
    var DoctorRowid = GlobalObj.LogonDoctorID
    var LogonDep = "";
    var FindRecLocByLogonLoc=$("#FindByLogDep").checkbox("getValue")?1:0;
    if (FindRecLocByLogonLoc == "1") { LogonDep = session['LOGON.CTLOCID'] }
    var OrderOpenForAllHosp = $("#CMOrderOpenForAllHosp").checkbox("getValue")?1:0;
    var ExpStr = "" +"^"+LogonDep+"^"+OrderOpenForAllHosp;
    
    var ret = cspRunServerMethod(GlobalObj.CheckBeforeSaveMethod, GlobalObj.EpisodeID, OrderItemStr, UserAddRowid, UserAddDepRowid, DoctorRowid, ExpStr,1)
    var CheckResultObj=jQuery.parseJSON(ret);
    
	/*var ErrCode=CheckResultObj.ErrCode; //1
	var ErrMsg=CheckResultObj.ErrMsg;	//2
    var ErrCellPosi=CheckResultObj.cellPosi;	//3
    var FocusCol=CheckResultObj.FocusCol;//4
    var NeedCheckDeposit=CheckResultObj.NeedCheckDeposit;//4*/
	var CheckBeforeSaveObj={
		isAfterCheckLoadDataFlag:false,	//ǰ̨�Ƿ���Ҫ��������
		SuccessFlag:true				//�Ƿ���Ҫ�������ҽ��
	}
	new Promise(function(resolve,rejected){
		//ִ�лص�����
		var CallBakFunS=CheckResultObj.CallBakFunS;
		if (typeof CallBakFunS=="object"){
			(function(callBackExecFun){
				function loop(i){
					new Promise(function(resolve,rejected){
						var FunCode=CallBakFunS[i].CallBakFunCode;
						var FunCodeParams=CallBakFunS[i].CallBakFunParams;
						var Row=CheckResultObj.ErrCode;
						CheckAfterCheckMethod(FunCode,FunCodeParams,Row,resolve);
					}).then(function(ReturnObj){
						if (ReturnObj.isAfterCheckLoadDataFlag){
							CheckBeforeSaveObj.isAfterCheckLoadDataFlag=true;
						}
						if (ReturnObj.SuccessFlag==false){
							CheckBeforeSaveObj.SuccessFlag=false;
							callBackExecFun();
							return;
						}
						i++;
						if ( i < CheckResultObj.CallBakFunS.length ) {
							 loop(i);
						}else{
							callBackExecFun();
						}
					})
				}
				loop(0);
			})(resolve);
		}else{
			resolve();
		}
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var ErrCode=CheckResultObj.ErrCode;
			var ErrMsg=CheckResultObj.ErrMsg;
		    var ErrCellPosi=CheckResultObj.cellPosi;
		    var FocusCol=CheckResultObj.FocusCol;
			if (ErrMsg!=""){
				if (ErrCode=="-1@NoStockOnePrompt"){
					debugger
					$.messager.confirm('ȷ�϶Ի���', ErrMsg+$g(" �Ƿ�ȫ��ɾ����"), function(r){
						if (r) {
							var CellArr=ErrCellPosi.split("��");
							for (var len=0; len<CellArr.length; len++){
								var CellPosi=CellArr[len];
								if (CellPosi=="") continue;
								FocusRowIndex=CellPosi.split(";")[0];
								FocusGroupIndex=CellPosi.split(";")[1];
								Delete_CMOrdEntry_row("N");
							}
							resolve();
						}else{
							resolve();
						}
					});
				}else if ((ErrCellPosi)&&(FocusCol!="")){
					$.messager.alert("��ʾ", ErrMsg, "warning", function() {
						var FocusRow=ErrCellPosi.split(";")[0];
						var FocusCellCol=ErrCellPosi.split(";")[1];
						SetFocusColumn(FocusCol+FocusCellCol,FocusRow);
						resolve();
				    });
				}else if((ErrCellPosi=="")&&(FocusCol!="")){
					$.messager.alert("��ʾ", ErrMsg, "warning", function() {
						$("#"+FocusCol).focus();
						resolve();
				    });
				}else{
					$.messager.alert("��ʾ",ErrMsg,"info",function(){
						resolve();
					});
				}
		    }else{
			    resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var ErrCode=CheckResultObj.ErrCode;
			if ((parseInt(ErrCode)<0)){
				CheckBeforeSaveObj.SuccessFlag=false;
			}
			var NeedCheckDeposit=CheckResultObj.NeedCheckDeposit;
			if (NeedCheckDeposit) {
		        var amount=$("#ScreenBillSum").val();
		        if (!CheckDeposit(amount, "")) {
		            CheckBeforeSaveObj.SuccessFlag=false;
		        }
		    }
		    resolve();
		})
	}).then(function(){
		callBackFun(CheckBeforeSaveObj);
	})
}
function CheckAfterCheckMethod(FunCode,FunCodeParams,Row,CallBackFun){
	var ReturnObj={
		isAfterCheckLoadDataFlag:false,
		SuccessFlag:true
	}
	var ParamsArr=FunCodeParams.split(",");
	new Promise(function(resolve,rejected){
	    switch(FunCode)
	    {
			case "Confirm" :
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						$.messager.confirm('ȷ�϶Ի���', FunCodeParams, function(r){
							if (r) {
								ReturnObj.SuccessFlag=true;
							}else{
								ReturnObj.SuccessFlag=false;
							}
							callBackFunExec();
						});
					})
				})(resolve); //�˴���resolveָ����CheckAfterCheckObj.CallBackFun(FunObj.ReturnObj);
				break;
			default:
				resolve();
				break;
		}
	}).then(function(){
		CallBackFun(ReturnObj);
	})
}

function InitPatOrderViewGlobalCM(EpisPatInfo){
	var EpisPatObj=eval("("+EpisPatInfo+")");
	$.extend(GlobalObj,EpisPatObj);
	var adm=GetMenuPara("EpisodeID");
	var FixedEpisodeID="";
	if ((parent)&&((parent.FixedEpisodeID)&&(typeof parent.FixedEpisodeID!="undefined"))){
		FixedEpisodeID=parent.FixedEpisodeID;
	}
	if ((parent.parent.FixedEpisodeID)&&(typeof parent.parent.FixedEpisodeID!="undefined")){
		FixedEpisodeID=parent.parent.FixedEpisodeID;
	}
	// ����ʶswitchSysPatΪN,�õ���request�ڵĲ���,�Ҳ����л�����
	if ((parent.switchSysPat)&&(parent.switchSysPat=="N")) {
		FixedEpisodeID=EpisPatObj.EpisodeID;
	}
	if ((adm!=GlobalObj.EpisodeID)&&((FixedEpisodeID=="")||((FixedEpisodeID!="")&&(FixedEpisodeID!=GlobalObj.EpisodeID)))){
		//xhrRefresh("",adm,"")
		var Url=window.location.href;
		 Url=rewriteUrl(Url, {
	        EpisodeID:GetMenuPara("EpisodeID"),
        	PatientID:GetMenuPara("PatientID"),
        	mradm:GetMenuPara("mradm"),
        	EpisodeIDs:"",
        	copyOeoris:"",
        	copyTo:""});
        history.pushState("", "", Url);
        window.location.reload();
		return;
	}
	
	var warning="";
	if (GlobalObj.warning != ""){
		warning=GlobalObj.warning;
	}
	if (warning!=""){
		$("#Prompt").css("display","");
		$("#Prompt").text(warning);
	}else{
		$("#Prompt").css("display","none");
	}
	if (GlobalObj.CPWOrdFlag=="1") {
		$("#Add_CPWOrd").show();
	}else{
		$("#Add_CPWOrd").hide();
	}
	InitDateFlatpickr();
	InitButtonBar();
	//����ӿڳ�ʼ��
	Common_ControlObj.xhrRefresh({
	    EpisodeID:GlobalObj.EpisodeID,
	    PAAdmType:GlobalObj.PAAdmType
	});
}
//ʹ�þֲ�ˢ��,��������һ����Ⱦ�����ظ�ʹ�ýϿ�
function xhrRefresh(Args){
	//console.log("xhrRefresh"+Args.adm)
	$(".messager-button a").click(); //�Զ��ر���һ�����ߵ�alert����
	//�ر����е�dialog,window,message
	$(".panel-body.window-body").each(function(index,element){
	});
	//�п��������ƽ���û������CheckLinkDetails,��������ط��л�ʧ�ܣ����ⲻ�ֲܾ�ˢ���ˣ�Ҫ����url
	if (typeof GlobalObj=="undefined"){
		window.location.reload();
		return;
	}
	CopyOeoriDataArr = new Array();
	if ((typeof Args.copyOeoris !="undefined")&&(Args.copyOeoris !="")){
		var copyOeorisArr=Args.copyOeoris.split("^");
		for (var i = 0; i < copyOeorisArr.length; i++) {
			var dataItem = tkMakeServerCall("web.DHCDocMain", "CreateCopyItem", copyOeorisArr[i],"");
			//var dataItem = copyOeorisArr[i];
			if (dataItem=="") continue
			CopyOeoriDataArr.push(dataItem);
		}
	}
	//CDSS��дҽ���ֲ�ˢ��ʱ����
	var copyCDSSData=Args.copyCDSSData;
	var papmi=GetMenuPara("PatientID");
	var adm=GetMenuPara("EpisodeID");
	var EpisPatObj={EpisodeID:Args.adm};
	var FixedEpisodeID=GetFixedEpisodeID(EpisPatObj);
	if (FixedEpisodeID!="") adm=FixedEpisodeID;
	if ((adm==GlobalObj.EpisodeID)||(adm=="")){
		var EpisPatInfo = tkMakeServerCall("web.DHCDocViewDataInit", "InitPatOrderViewGlobalCM", adm,GlobalObj.EmConsultItm);
		var EpisPatObj=eval("("+EpisPatInfo+")");
		InitPatOrderViewGlobalCM(EpisPatInfo);
		if (CopyOeoriDataArr.length>0){
			AddCopyItemToList(CopyOeoriDataArr);
			CopyOeoriDataArr=undefined;
		}
		if(typeof CDSSObj=='object') CDSSObj.AddOrdToList(copyCDSSData);
		setTimeout(function(){
			if ( +GlobalObj.CMDrugAndQtySplitConfig == 0) {
			    $("#DrugAndQtyYQ").checkbox('check');
			}else{
				$("#DrugAndQtySplit").checkbox('check');
			}
		},700)
        ShowSecondeWin("onOPenCMPresc");
		HideWindowMask();
		return
	}
	$(".window-mask.alldom").show();
	//$(".window-mask.alldom").height();
	var EpisPatInfo = tkMakeServerCall("web.DHCDocViewDataInit", "InitPatOrderViewGlobalCM", adm,GlobalObj.EmConsultItm);
	var EpisPatObj=eval("("+EpisPatInfo+")");
	///������������ǿ��ˢ�£���֤������ʽ��ȷ�仯
	if (
		(EpisPatObj.PAAdmType!=GlobalObj.PAAdmType)||
		(EpisPatObj.CPWOrdFlag!=GlobalObj.CPWOrdFlag)
	){
		if (typeof(history.pushState) === 'function') {
	        var Url=window.location.href;
	        Url=rewriteUrl(Url, {
		        EpisodeID:EpisPatObj.EpisodeID,
	        	PatientID:EpisPatObj.PatientID,
	        	mradm:EpisPatObj.mradm,
	        	EpisodeIDs:"",
	        	copyOeoris:"",
	        	copyTo:""});
	        history.pushState("", "", Url);
	        window.location.reload();
	        return;
	    }
	}
	//�Ƶ���ջ����֤��������չʾ--PB by tanjishan ���ĳ��ֶ������α�������ⲽ
	window.requestAnimationFrame(function(){
		DocumentUnloadHandler();
		InitPatOrderViewGlobalCM(EpisPatInfo);
		InitPrescriptTypeBillList();
		//�������͸ı�ʱ��Ҫ�޸�����combobox��Ĭ��ֵ,�ʳ�ʼ��ʱ��������Ԫ�ؼ�����֮�����
		InitCMPrescType(GlobalObj.CMPrescTypeStrStr);
		//�����CMPrescTypeChangeHandler�и�ֵ���������Ԫ�ص�ֵ
		$("#PrescNotes").val("");
		$("#PrescUrgent").checkbox('setValue',false);
		
		if (GlobalObj.PracticeShowFlag>0){
	    	ShowPracticeOrder();
	    }
		///���������Ҫ���ڸ�������ĳ�ʼ�������Բ��ܷŵ�InitPatOrderViewGlobalCM��
		ReloadPrescListData();
		if ((GlobalObj.CurrentDischargeStatus=="B")||(GlobalObj.VisitStatus=="P")||(GlobalObj.LoginAdmLocFlag!="Y")) {
			$("#AddLongOrderList").combobox('select','').combobox("disable");
	   	}else{
			$("#AddLongOrderList").combobox("disable",false);
		}
		//���������Ƹ���ҽ�����渴��
		if (('undefined' !== typeof CopyOeoriDataArr)&&(CopyOeoriDataArr.length>0)){
			AddCopyItemToList(CopyOeoriDataArr);
			CopyOeoriDataArr=undefined;
		}
		InitBtnDisplay();
		ResizePromptWidth();
		setTimeout(function(){
			$('#CMOrdEntry_DataGrid').jqGrid('clearGridData');
			var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
			if(records==0){
				Add_CMOrdEntry_row();
			}
		},700)
        ShowSecondeWin("onOPenCMPresc");
		HideWindowMask();
	});
}
function ReloadPrescListData(){
	var PrescListArr=new Array();
    var ArrData = GlobalObj.PrescList.split(String.fromCharCode(2));
    for (var i = 0; i < ArrData.length; i++) {
        var ArrData1 = ArrData[i].split(String.fromCharCode(1));
        if (ArrData1[0]=="") continue;
        var value=ArrData1[0]+"^"+ArrData1[2];
		PrescListArr.push({"value":value, "desc":ArrData1[1]});
    }
	$HUI.combobox("#PrescList", {data:PrescListArr});
}

function GetMenuPara(ParaName) {
    var myrtn = "";
    var frm = dhcsys_getmenuform();
    if (frm) {
	    if (eval("frm." + ParaName)){
        	myrtn = eval("frm." + ParaName + ".value");
        }
    }
    return myrtn;
}
function HideWindowMask(){
	$(".window-mask.alldom").hide();
}
function InitPrescriptTypeBillList(){
	if (GlobalObj.PrescriptTypes!=""){
		clearTab();
		//var PrescriptTypesArr=[];
		var defaultIndex="",defaultBilltype="";
	    var PrescriptTypesCount=GlobalObj.PrescriptTypes.split("||").length;
	    for (var i=0;i<PrescriptTypesCount;i++){
		    var PrescriptTypeTemp=GlobalObj.PrescriptTypes.split("||")[i];
		    var presctypebilltypeid=PrescriptTypeTemp.split(PrescTypeDetailDelim)[4];
		    var presctypedesc=PrescriptTypeTemp.split(PrescTypeDetailDelim)[2];
		    var presctypedefault=PrescriptTypeTemp.split(PrescTypeDetailDelim)[7];
		    var selected=false
		    if (presctypedefault=="Y") {
			    selected=true;
			    defaultIndex=i;
			    defaultBilltype=presctypebilltypeid;
			}
		    $('#PrescriptTypeBillList').tabs('add',{    
			    title:presctypedesc,    
			    content:'',
			    closable:false,   
			    selected:selected
			})
			//PrescriptTypesArr.push({"id":presctypebilltypeid,"text":presctypedesc,"selected":selected});
			PageLogicObj.m_selTabIndex=i;
			GlobalObj.OrderBillTypeRowid=presctypebilltypeid;
		}
		//�л�����ʱ�ظ���ʼ����Ԫ�ػᵼ��Ԫ����ʽ�쳣
		/*if ($('#PrescriptTypeBillList').hasClass('combobox-f')){
			$('#PrescriptTypeBillList').combobox('clear').combobox('loadData',PrescriptTypesArr);
		}else{
			$('#PrescriptTypeBillList').combobox({
				valueField:'id',   
		    	textField:'text',
		    	editable:false,
		    	data:PrescriptTypesArr,
		    	onSelect:function(record){
					PrescTypeBillChange(record["id"]);
				}
			});
		}*/
		if (defaultBilltype==""){
			//PageLogicObj.m_selTabIndex=0;
			//GlobalObj.OrderBillTypeRowid=presctypebilltypeid;
			$('#PrescriptTypeBillList').tabs('select',0);
			PrescTypeBillChange(0);
		}else{
			PageLogicObj.m_selTabIndex=defaultIndex;
			GlobalObj.OrderBillTypeRowid=defaultBilltype;
		}
	}else{
		GlobalObj.OrderBillTypeRowid=GlobalObj.DefaultBilltype;
	}
	
}

function InitBtnDisplay(){
	if (GlobalObj.EnableButton == 0) {
		DisableBtn("Update",true);
	    DisableBtn("Delete_Order_btn",true);
	    DisableBtn("Add_Order_btn",true);
	}else{
		DisableBtn("Update",false);
	    DisableBtn("Delete_Order_btn",false);
	    DisableBtn("Add_Order_btn",false);
	}
}
function ReloadFrameData() {
	$(".window-mask.alldom").show();
	window.requestAnimationFrame(function(){
		$.extend(PageLogicObj,{IsARCOSFormula:0,m_ARCOSRowId:""}); //,m_selTabIndex:""
		var EpisPatInfo = tkMakeServerCall("web.DHCDocViewDataInit", "InitPatOrderViewGlobalCM", GlobalObj.EpisodeID,GlobalObj.EmConsultItm);
		InitPatOrderViewGlobalCM(EpisPatInfo);
		$('#CMOrdEntry_DataGrid').jqGrid('clearGridData');
		var records=$('#CMOrdEntry_DataGrid').getGridParam("records");
		if(records==0){
			Add_CMOrdEntry_row();
		}
		$("#PrescUrgent,#CMOrderOpenForAllHosp").checkbox("uncheck");
		$("#PrescList").combobox('select','clear');
		$("#PrescPrior").combobox('loadData',JSON.parse(GlobalObj.PrescPriorJson));
		ReloadPrescListData();
		$("#PrescList").combobox('select','');
		if (GlobalObj.PAAdmType=="I"){
			var AddLongOrderObj=$("#AddLongOrderList").combobox('options').data;
			if (AddLongOrderObj.length==1){
				$("#AddLongOrderList").combobox('select',AddLongOrderObj[0].value);
			}else{
				$("#AddLongOrderList").combobox('select','');
			}
		}
		/*if ($("#CMPrescTypeKW").keywords('getSelected').length>0){
			var SelCMPrescTypeKW=$("#CMPrescTypeKW").keywords('getSelected')[0].id;
			$("#CMPrescTypeKW").keywords('select',SelCMPrescTypeKW);
		}*/
		$("#PrescNotes").lookup('setText',"");
		InitCMPrescType(GlobalObj.CMPrescTypeStrStr);
		InitPrescriptTypeBillList();
		HideWindowMask();
		if (GlobalObj.PAAdmType=="I"){
		   if ((GlobalObj.CurrentDischargeStatus=="B")||(GlobalObj.VisitStatus=="P")||(GlobalObj.LoginAdmLocFlag!="Y")) {
			   $("#AddLongOrderList").combobox('select','').combobox("disable");
		   }
	    }
	    if (GlobalObj.TakingMedicineShowFlag=="Y"){
	    	$("#TakingMedicineMethod").combobox('select','');
	    }
	});
}
function clearTab(){
	var tabs=$('#PrescriptTypeBillList').tabs("tabs");
	for (var i=tabs.length;i>=0;i--) {
		$('#PrescriptTypeBillList').tabs("close",i);
	}
}
function GetNewFocusIndex(){
	if (+FocusRowIndex==0) FocusRowIndex=1;
	if (+FocusGroupIndex==0) FocusGroupIndex=1;
	var rows=$('#CMOrdEntry_DataGrid').getGridParam("records");	
	var Find=0;
	for (var i=FocusRowIndex; i<=rows; i++){
		for (var j=FocusGroupIndex; j<=GlobalObj.ViewGroupSum; j++){
			var OrderARCIMRowid=GetCellData(i,j,"OrderARCIMID");
			if (OrderARCIMRowid=="") {
				FocusRowIndex=i;
				FocusGroupIndex=j;
				Find=1;
				break;
			}
		}
		if (Find==1) break;
	}
	var FocusObj={
		FocusRowIndex:FocusRowIndex,
		FocusGroupIndex:FocusGroupIndex
	}
	return FocusObj;
}
function GetPreCMPrescTypeDataObj(){
	if (PageLogicObj.PreCMPrescTypeCode=="") return;
	var PrescFreqRowid=$('#PrescFrequence').combobox("getValue");
	var PrescInstrRowid=$('#PrescInstruction').combobox("getValue");
	var PrescDurRowid=$('#PrescDuration').combobox("getValue");
	var PrescOrderQty=$('#PrescOrderQty').combobox('getText')
	var OrderRecDepRowid=$('#RecLoc').combobox("getValue");
    var PrescNotes=$('#PrescNotes').val();
    var PrescCookDecoction=$('#CookModelist').combobox('getValue');
    var TakingMedicineMethod=""
    if (GlobalObj.TakingMedicineShowFlag=="Y"){
    	var TakingMedicineMethod=$('#TakingMedicineMethod').combobox('getValue');
    }
    PreCMPrescTypeDataObj[PageLogicObj.PreCMPrescTypeCode]={};
    $.extend(PreCMPrescTypeDataObj[PageLogicObj.PreCMPrescTypeCode], {
	    PrescFrequence:PrescFreqRowid,
	    PrescInstruction:PrescInstrRowid,
	    PrescDuration:PrescDurRowid,
	    PrescOrderQty:PrescOrderQty,
	    CMOrderOpenForAllHosp:$("#CMOrderOpenForAllHosp").checkbox('getValue'),
	    RecLoc:OrderRecDepRowid,
	    PrescNotes:PrescNotes,
	    CookModelist:PrescCookDecoction,
	    TakingMedicineMethod:TakingMedicineMethod
	});
}
function SetPreCMPrescTypeData(CMPrescTypeCode){
	if (!$.isEmptyObject(PreCMPrescTypeDataObj[CMPrescTypeCode])) {
		var dataObj=PreCMPrescTypeDataObj[CMPrescTypeCode];
		for ( var id in dataObj) {
			setValue(id,dataObj[id]);
		}
	}
	$.extend(PreCMPrescTypeDataObj[CMPrescTypeCode], {});
}
///����Ԫ�ص�classname��ֵ
function setValue(id,value){
	var _$id=$("#"+id)
	var className=_$id.attr("class")
	if(typeof className =="undefined"){
		_$id.val(value);
		return;
	}
	if(className.indexOf("hisui-lookup")>=0){
		_$id.lookup('setText',value);
	}else if(className.indexOf("combobox-f")>=0){
		_$id.combobox('select',value);
	}else if(className.indexOf("hisui-datebox")>=0){
		_$id.datebox("select",value)
	}else{
		_$id.val(value);
	}
}
function FormateNumber(Number) {
    if ((Number == "")||(Number==" ")) return "";
    if (Number.indexOf(".") == -1) { 
    	if (Number.indexOf("-") >=0) {
	    	var NewNumber="";
	    	for (var m=0;m<Number.split("-").length;m++) {
		    	if (NewNumber=="") NewNumber=FormateNumber(Number.split("-")[m]);
		    	else  NewNumber=NewNumber+"-"+FormateNumber(Number.split("-")[m]);
		    }
		    return NewNumber;
	    }else{
    		return +Number ;
    	}
    }
    var FirstNum = Number.split(".")[0];
    FirstNum = +FirstNum
    var SecondNum = ""
    if (Number.indexOf(".") != -1) SecondNum = Number.split(".")[1];
    if (SecondNum != "") SecondNum = SecondNum
    if (SecondNum != "") {
        return FirstNum + "." + SecondNum;
    } else {
        return FirstNum;
    }
}
function InitDateFlatpickr(){
	var dateFormate="d/m/Y H:i:S";
    if (PageLogicObj.SYSDateFormat==3){
        dateFormate="Y-m-d H:i:S"
    }
    if (GlobalObj.CurrentDischargeStatus=="B") {
		var defaultDate=GlobalObj.DischargeDate+" "+GlobalObj.DischargeTime;
		$("#PrescStartDate").attr("disabled",true);
	}else{
		var defaultDate=GetCurr_time();
	}
	$("#PrescStartDate").flatpickr({
    	enableTime: true,
    	enableSeconds:true,
    	dateFormat: dateFormate,
    	time_24hr: true,
    	defaultDate:defaultDate,
    	onOpen:function(pa1,ap2){
	        //$("#PrescStartDate").setDate(ap2,true);
	    },
	    onChange:function(){
		    SetRecLoc();
		}
    })
}
function GetCurr_time() {
    //ȡ��ǰ���ں�ʱ��(������)
    var CurrDateTime = tkMakeServerCall("web.DHCDocOrderCommon","GetCurrentDateTime", PageLogicObj.SYSDateFormat, "1");
    var CurrDateTimeArr = CurrDateTime.split("^");
    var CurrDate = CurrDateTimeArr[0];
    var CurrTime = CurrDateTimeArr[1];
    var CurrDateTime = CurrDate + " " + CurrTime;
    return CurrDateTime;
}
function ResizePromptWidth(){
	setTimeout(function(){
		//��ֹģ�������ʱ�����ά�����ܣ��ᵼ����ʾ���ڵ���ť�����
		var CNTemplateWidthW=$('#layoutMain').layout('panel',"west").width()||0;
		var mainWidth=$('#layoutMain').layout('panel','center').width();
		mainWidth=mainWidth+CNTemplateWidthW;
		if($("#PrescriptTypeBillList").length>0){
			var $obj=$("#PrescriptTypeBillList ul.tabs li:last");
			if(!$obj.size()) return; 
			$("#Prompt").css({
				width:mainWidth-$obj.offset().left-$obj.outerWidth()-15,
				top:$obj.offset().top+3,
				left:$obj.offset().left+$obj.outerWidth()+5
			});
		}else{
			var $obj=$("#CMPrescTypeKW ul li:last");
			if(!$obj.size()) return; 
			$("#Prompt").css({
				width:mainWidth-$obj.offset().left-$obj.outerWidth()-300,
				top:$obj.offset().top-3,
				left:$obj.offset().left+$obj.outerWidth()+5
			});
		}
		var CNTemplateRegion=['east','west'];
		var CWidth=$('#layoutMain').layout('panel','center').width();
		if (CNTemplateRegion.includes(GlobalObj.CNTemplateRegion)){
			CWidth=CWidth<1170?1150:(CWidth-2);
			$("#CMPrescInfo").css({width:CWidth});
		}
	},300);
}
function GetFixedEpisodeID(EpisPatObj){
	var FixedEpisodeID="";
	if ((parent)&&((parent.FixedEpisodeID)&&(typeof parent.FixedEpisodeID!="undefined"))){
		FixedEpisodeID=parent.FixedEpisodeID;
	}
	if ((parent.parent.FixedEpisodeID)&&(typeof parent.parent.FixedEpisodeID!="undefined")){
		FixedEpisodeID=parent.parent.FixedEpisodeID;
	}
	// ����ʶswitchSysPatΪN,�õ���request�ڵĲ���,�Ҳ����л�����
	if ((parent.switchSysPat)&&(parent.switchSysPat=="N")) {
		FixedEpisodeID=EpisPatObj.EpisodeID;
	}
	return FixedEpisodeID;
}
function InitTempFrame()
{
	PageLogicObj.TempHeight=GlobalObj.TempHeightScale?$('#layoutMain').height()*GlobalObj.TempHeightScale/100:400;
	PageLogicObj.TempWidth=GlobalObj.TempWidthScale?$('#layoutMain').width()*GlobalObj.TempWidthScale/100:300;
    var content="<iframe id='templateFrame' name='templateFrame' width='100%' height='100%' frameborder='0'></iframe>"
    if(GlobalObj.CNTemplateRegion=='window'){
        $('<div id="templateWin"></div>').appendTo('#layoutMain').window({
            title:'ҽ��ģ��',
            iconCls:'icon-w-list',
            minimizable:false,
            maximizable:false,
            closable:false,
            closed:false,
            modal:false,
            width:PageLogicObj.TempWidth,
            height:$(window).height()-150,
            content:content,
            onCollapse:function(){
                $(this).window('resize',{
                    width: 130
                }).window('move',{
                    top:$(window).height()-100,
                    left:$(window).width()-150
                });
                $(this).parent().addClass("boxshadow");
            },
            onExpand:function(){
                $(this).window('resize',{
                    width: PageLogicObj.TempWidth
                }).window('move',{
                    top:100,
                    left:$(window).width()-PageLogicObj.TempWidth-30
                });
                $(this).parent().removeClass("boxshadow");
            }
        });
        if(GlobalObj.DefCollapseTemp=='Y') $('#templateWin').window('collapse');
        else $('#templateWin').window('options').onExpand.call($('#templateWin')[0]);
    }else{
	    var style={'padding':'5px 4px'}
	    if (GlobalObj.PAAdmType=="O") style.padding=0;
        $('#layoutMain').layout('add',{
            region:GlobalObj.CNTemplateRegion,
            border:false,
            collapsible:false,
            split:true,
            width:PageLogicObj.TempWidth,
            height:PageLogicObj.TempHeight,
            style:style,
            content:content,
            onResize:function(){
	        	ResetOrdListScale($(this).parent().outerHeight(),$(this).outerWidth());
	        }
        });
    }
    var CONTEXT=GlobalObj.XCONTEXT||"W50007"
	var url='oeorder.entry.template.csp?TemplateRegion='+GlobalObj.CNTemplateRegion+'&CONTEXT='+CONTEXT+'&EpisodeID='+GlobalObj.EpisodeID;
	if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
    $('#templateFrame').attr('src',url);
}
//ˢ��ģ��
function refreshTemplate()
{
	return frames["templateFrame"].LoadTemplateData();
}
//ģ��༭ģʽ�л�
function TemplateModeChange(mode)
{
    var width=mode?PageLogicObj.TempWidth:800;
    if(GlobalObj.CNTemplateRegion=='window'){
        $('#templateWin').window('resize',{
            width: width
        }).window('move',{
            top:100,
            left:$(window).width()-width-10
        });
    }else if(['north','south'].indexOf(GlobalObj.CNTemplateRegion)>-1){
    }else{
        $('#layoutMain').layout('panel',GlobalObj.CNTemplateRegion).panel('resize',{width:width});
        $('#layoutMain').layout('resize');
        ResizePromptWidth();
        return;
    }
}
function ResetOrdListScale(height,width)
{
	if(!window.event) return false;
	if(window.event.type.indexOf('mouse')==-1) return false;
	clearTimeout(PageLogicObj.resizeTimer);
	PageLogicObj.resizeTimer=setTimeout(function(){
		if(['north','south'].indexOf(GlobalObj.CNTemplateRegion)>-1){
			var ConfigNode='TempHeightScale';
			var scale=Math.round(height/$('#layoutMain').height()*100);
		}else{
			var ConfigNode='TempWidthScale';
			var scale=Math.round(width/$('#layoutMain').width()*100);
		}
		$.cm({
			ClassName:"web.DHCDocConfig",
			MethodName:"SetUserPageScale",
			PageCode:"CMOrderEntry",Property:ConfigNode,Value:scale,
			dataType:'text'
		},function(){
			$.messager.popover({msg:'���ֵ����ɹ�!',type:'success'});
			if(height) PageLogicObj.TempHeight=height;
			if(width) PageLogicObj.TempWidth=width;
			if(['west','east'].indexOf(GlobalObj.CNTemplateRegion)>-1){
				ResizePromptWidth();
			}
		});
	},1000);
	return true;
}
///����ҽ������鿴
function InsuNationShowClick(){
	var OrderARCIMRowid=GetFocusARCIMRowid();
	if(OrderARCIMRowid!=""){
		websys_showModal({
			url:"dhc.orderinsudetail.csp?ArcimDr=" + OrderARCIMRowid+"&EpisodeID="+GlobalObj.EpisodeID,
			title:'����ҽ���鿴',
			width:640,height:250
		});
	}
}
function ChangePrescPrior(PriorTypeDr){
	// ����ҽ������Ĭ���÷�
	var DefInstr = $.cm({
		ClassName:"DHCDoc.DHCDocConfig.DocConfig",
		MethodName:"GetInstrByPriorType",
		dataType:"text",
		PriorTypeDr:PriorTypeDr,
		HospId:session['LOGON.HOSPID']
	},false);
	if (DefInstr!="") $("#PrescInstruction").combobox('select',DefInstr)
}
function AddOrderRowClick(){
	if((PageLogicObj.IsARCOSFormula=="1")&&(GlobalObj.FormulaCanAppendItem=="0")) { 
		return false;
	}
	Add_CMOrdEntry_row();
}
function MoveUpClick(){
	OrdVerticalMove("MoveUp_btn");
}
function MoveDownClick(){
	OrdVerticalMove("MoveDown_btn");
}
function MoveLeftClick(){
	OrdHorizontalMove("MoveLeft_btn");
}
function MoveRightClick(){
	OrdHorizontalMove("MoveRight_Btn");
}
function SetComboValue(id,value)
{
	if(!$('#'+id).size()) return;
	if(value==''){
		$('#'+id).combobox('setValue',value);
		return;
	}
	var valueField=$('#'+id).combobox('options').valueField;
	var rows=$('#'+id).combobox('getData');
	$.each(rows,function(index,row){
		if(row[valueField]==value){
			$('#'+id).combobox('select',value);
			return false;
		}
	});
}
/// չʾ�ڶ�����
function ShowSecondeWin(Flag){
    if (PageLogicObj.MainSreenFlag==0){
	    var Obj={PatientID:GlobalObj.PatientID,EpisodeID:GlobalObj.EpisodeID,mradm:GlobalObj.mradm,PageShowFromWay:"SecondEntry"};
	    if (Flag=="onOpenIPTab"){
		    //��Ϣ����
		}
		if (Flag=="onOPenCMPresc"){
			//��������
		}
		websys_emit(Flag,Obj);
	}
}
//�������������¼�
websys_on({
	"onCopyCMPresc":function(obj){
        //���ƴ���ҽ��
		AddCopyItemToListFromQuery(obj);
	},"onPrescListChange":function(obj){
		//���ƴ�����Ϣ
        PrescListChange(obj.PrescInfo,obj.copyFlag);
	},"onOpenIPTab":function(obj){
		$("#msg").html(JSON.stringify(obj));
	}
});