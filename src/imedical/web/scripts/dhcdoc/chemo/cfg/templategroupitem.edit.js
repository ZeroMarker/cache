/**
 * templategroupitem.edit.js
 * 
 * Copyright (c) 2018-2019 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2020-04-28
 * 
 * 
 */
PLObject = {
	v_Arcim: ""	//PLObject.v_Arcim
}
if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
	 document.getElementsByTagName('head')[0].appendChild(script);
}
$(function() {
	Init();
	InitEvent();
})


function Init(){
	InitCombox();
	InitData()
}

function InitEvent () {
	$("#save").click(SaveItem)
	$("#clear").click(ClearItem)
}

function InitCombox() {
	//Combox_ItmLinkDoctor();
	Combox_ItemDesc();
	Combox_ItemFrequence();
	Combox_ItemDuration();
	Combox_ItemInstruction()
	Combox_ItemDoseUOM();
	Combox_ItemBillUOM();
	//Combox_remark();
	Combox_DHCDocOrderType();
	Combox_DHCDocOrderStage();
	Combox_DHCDocOrderRecLoc();
	Combox_OrderFlowRateUnit();
	Combox_OrderPriorRemarks();
	Combox_SkinAction();
	//Combox_sampleType();
	Combox_Formula();
}

//���㹫ʽ
function Combox_Formula () {
	PLObject.m_Formula = $HUI.combobox("#Formula", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryFormula&ResultSetType=array",
		valueField:'id',
		textField:'text',
		blurValidValue:true
	});
}

function Combox_ItmLinkDoctor () {
	PLObject.m_ItmLinkDoctor = $HUI.combobox("#ItmLinkDoctor", {
		url:$URL+"?ClassName=DHCDoc.Chemo.CFG.Item&QueryName=QryTPLGroupItem&TPGID="+ServerObj.TPGID+"&ResultSetType=array",
		valueField:'TPGIID',
		textField:'arcimDesc',
		blurValidValue:true
	});
}

//ҽ������
function Combox_ItemDesc(){
	/*
	$("#ItemDesc").lookup({
		width:$("#ItemDesc").parent().width(),
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'ArcimDR',
        textField:'ArcimDesc',
        columns:[[  
           {field:'ArcimDesc',title:'����',width:320,sortable:true},
            {field:'ArcimDR',title:'ID',width:70,sortable:true}
        ]],
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'DHCDoc.Chemo.COM.Qry',QueryName: 'FindMasterItem',InOrderCate:"��ҩ",HospId:ServerObj.InHosp},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
			param = $.extend(param,{arcimdesc:desc});
	    },onSelect:function(ind,item){
		   PLObject.v_Arcim = item.ArcimDR;
		   console.log(item)
		   OrderItemLookupSelect(item);
		}
    });
    */
    
    
    $("#ItemDesc").lookup({
		width:$("#ItemDesc").parent().width(),
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'ArcimRowID',
        textField:'ARCIMDesc',
        columns:[[  
           {field:'ARCIMDesc',title:'����',width:300,sortable:true},
           {field:'ItemPrice',title:'����',width:70,sortable:true},
           {field:'ArcimRowID',hidden:true}
        ]],
        pagination:true,
        panelWidth:400,
        panelHeight:410,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCARCOrdSets',QueryName: 'LookUpItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;//session['LOGON.GROUPID']
			param = $.extend(param,{Item:desc,GroupID:"",OrderPrescType:"Other",SearchLimitType:"",ParamARCOSRowid:"",HospID:ServerObj.InHosp});
	    },onSelect:function(ind,item){
		   $("#ItemRowid").val(item['ArcimRowID']);
		   PLObject.v_Arcim = item['ArcimRowID'];
		   var ItemArr=new Array();
		    $.each(item, function(key, val) {
				ItemArr.push(val);
			});
			OrderItemLookupSelect(ItemArr.join("^"));
		}
    });
    
}

//Ƶ��
function Combox_ItemFrequence() {
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemFrequence", 
		Inpute1:"^N",Inpute2:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#ItemFrequence", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			}
	 });
}

//Ƶ��
function FreqCombCreat()
{
	var INPut="^N"
	if (ARCOSPrescType!="Other"){
		INPut="^Clear";
	}
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemFrequence", 
		Inpute1:INPut,Inpute2:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#ItemFrequence", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				//return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["CombCode"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			},
			onSelect: function(rec){ 
				if (rec) {
					/**/
				}  
			},onChange:function(newValue, oldValue){
				if (newValue=="") {
					$("#OrderFreqDispTimeStr").val("");
					ChangeOrderFreqTimeDoseStr();
				}
			},
			onHidePanel:function(){
				ItemFrequenceChange();
			}
	 });
}


//������λ
function Combox_ItemDoseUOM(ArcimID,DefaultDosUomDr) {
	ArcimID=ArcimID||"",
	DefaultDosUomDr=DefaultDosUomDr||"";
	
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemDoseUOM", 
		Inpute1:ArcimID,Inpute2:DefaultDosUomDr,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#ItemDoseUOM", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					$(this).combobox('select',DefaultDosUomDr);
				}
		 });
	});
}

//������λ
function ItemDoseUOMCombCreat(ArcimID,DefaultDosUomDr)
{
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemDoseUOM", 
		Inpute1:ArcimID,Inpute2:DefaultDosUomDr,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#ItemDoseUOM", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					$(this).combobox('select',DefaultDosUomDr);
				}
		 });
	});
}

//�Ƴ�
function Combox_ItemDuration() {
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemDuration", 
		Inpute1:"^N",
		rows:99999
	},false);
	
	var cbox = $HUI.combobox("#ItemDuration", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			}
	 });
}
//�÷�
function Combox_ItemInstruction() {
	/*var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemInstruction", 
		Inpute1:"",Inpute2:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#ItemInstruction", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			}
	 });*/
	 
	 var cbox = $HUI.combobox("#ItemInstruction", {
				url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=LookUpInstr&ResultSetType=array",
				valueField:'HIDDEN',
				textField:'Desc',
				//multiple:true,
				mode:'remote',
				blurValidValue:true,
				onBeforeLoad:function(param){
					var desc=param['q'];
					param = $.extend(param,{instrdesc:desc});
				},onSelect: function(rec){ 
					if (rec) {
						$("#SkinTest").checkbox('enable');
						$("#SkinAction").combobox('enable');
						if (m_ArcimClassification =="RC") {
							
							$("#SkinTest").checkbox('enable');
							$("#SkinAction").combobox('enable');
						}
						if (m_ArcimClassification !="RW") {
							//$("#SkinTest").checkbox('disable')
							//$("#SkinAction").combobox('setValue',"").combobox('disable');
						}
						if ((SkinTestInstr!="")&&(SkinTestInstr.indexOf("^"+rec.CombValue+"^")>=0)) {
							$("#SkinAction").combobox('setValue',"").combobox('disable');
							$("#SkinTest").checkbox('setValue', true);
							//$("#SkinTest").checkbox('disable').checkbox('uncheck');
						}
						//var OrderFlowRateUnit=$("#OrderFlowRateUnit").combobox('getValue');
						//if (OrderFlowRateUnit=="") {
							$.cm({
							    ClassName:"web.DHCOEOrdItemView",
							    MethodName:"GetInstrDefSpeedRateUnit",
							    InstrRowId:rec.HIDDEN,
							    dataType:"text"
							},function(OrderFlowRateUnitRowId){
								if (OrderFlowRateUnitRowId!=""){
									$("#OrderFlowRateUnit").combobox('select',OrderFlowRateUnitRowId);
							    }
							})
						//}
					}  
				}
			});
}

//����װ��λ
function Combox_ItemBillUOM(ArcimDr,DefPackQtyUomRowId) {
	ArcimDr = ArcimDr||"",
	DefPackQtyUomRowId = DefPackQtyUomRowId||"";
	
	//ItemBillUOMCombCreat(ArcimDr,DefPackQtyUomRowId);
	//return false
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemBillUOM", Inpute1:"", Inpute2:ArcimDr, 
		Inpute3:$("#DHCDocOrderRecLoc").combobox('getValue'), Inpute4:DefPackQtyUomRowId,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#ItemBillUOM", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(data){
					if (data.length>0){
						var DHCDocOrderRecLoc=$("#DHCDocOrderRecLoc").combobox('getValue');
						if (DHCDocOrderRecLoc!=""){
							$(this).combobox('select',data[0]['CombValue']);
						}else{
							$(this).combobox('select',DefPackQtyUomRowId);
						}
					}
				}
		 });
	});
}

//����װ��λ
function ItemBillUOMCombCreat(ArcimDr,DefPackQtyUomRowId)
{
	//alert(ArcimDr+": "+DefPackQtyUomRowId)
	var Edit=true
	var INPut="N"
	if (ARCOSPrescType!="Other"){
		INPut="Y"
	}
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"ItemBillUOM", Inpute1:INPut, Inpute2:ArcimDr, 
		Inpute3:$("#DHCDocOrderRecLoc").combobox('getValue'), Inpute4:DefPackQtyUomRowId,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#ItemBillUOM", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(data){
					if (data.length>0){
						var DHCDocOrderRecLoc=$("#DHCDocOrderRecLoc").combobox('getValue');
						if (DHCDocOrderRecLoc!=""){
							$(this).combobox('select',data[0]['CombValue']);
						}else{
							$(this).combobox('select',DefPackQtyUomRowId);
						}
					}
				}
		 });
	});
}

//��ע
function Combox_remark(Tremark) {
	INPut="^Y"
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"remark", Inpute1:INPut,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#remark", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(data){
					if (Tremark!=""){
						$(this).combobox('setText',Tremark);
					}
				}
		 });
	});
}

//ҽ������
function Combox_DHCDocOrderType() {
	
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"DHCDocOrderType", 
		Inpute1:"",
		Inpute2:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#DHCDocOrderType", {
		valueField: 'CombValue',
		textField: 'CombDesc', 
		editable:true,
		data: GridData["rows"],
		filter: function(q, row){
			return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},onLoadSuccess:function(){
			//$(this).combobox('select',"");
		},onSelect:function(){
			
		},onChange:function(newValue,oldValue){
			
		}
    });
    
    /*
    $HUI.combobox("#DHCDocOrderType", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryOEType&InDesc=NORM&ResultSetType=array",
		valueField:'rowid',
		textField:'desc',
		blurValidValue:true,
		onLoadSuccess:function(){
	        var val = $(this).combobox('getData');
	        for (var item in val[0]){
	            if (item == 'rowid'){
	                 $(this).combobox('select', val[0][item]);
	            }
	        }
	    }
    
	});
	*/
}

//ҽ������
function DHCDocOrderTypeCombCreat()
{
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"DHCDocOrderType", 
		Inpute1:m_ArcimClassification,
		Inpute2:session['LOGON.CTLOCID'],
		rows:99999
	},false);
	var cbox = $HUI.combobox("#DHCDocOrderType", {
		valueField: 'CombValue',
		textField: 'CombDesc', 
		editable:true,
		data: GridData["rows"],
		filter: function(q, row){
			return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		},onLoadSuccess:function(){
			//$(this).combobox('select',"");
		},onSelect:function(){
			ChangeFormStyle(m_ArcimClassification,m_iorderSubCatID,m_idoseqtystr);
		},onChange:function(newValue,oldValue){
			if (newValue==""){
				ChangeFormStyle(m_ArcimClassification,m_iorderSubCatID,m_idoseqtystr);
			}
		}
    });
}

//ҽ���׶�
function Combox_DHCDocOrderStage() {
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"DHCDocOrderStage", 
		rows:99999
	},false);
	var cbox = $HUI.combobox("#DHCDocOrderStage", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			}
	 });
}

//���տ���
function Combox_DHCDocOrderRecLoc(ArcimID,DefaultOrdRecLoc,DefaultFlag){
	ArcimID=ArcimID||"",
	DefaultOrdRecLoc=DefaultOrdRecLoc||"",
	DefaultFlag=DefaultFlag||"";
	
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"DHCDocOrderRecLoc", 
		Inpute1:ArcimID, Inpute2:DefaultOrdRecLoc, Inpute3:DefaultFlag,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#DHCDocOrderRecLoc", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				value:DefaultOrdRecLoc,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(){
					//$(this).combobox('select',DefaultOrdRecLoc);
				},onChange:function(newValue,oldValue){
					if (newValue==""){
						$('#DHCDocOrderRecLoc').combobox('select',"");
						$('#ItemBillUOM').combobox('select',""); 
						var ArcimID=$("#ItemRowid").val();
						ItemBillUOMCombCreat(ArcimID,"")
					} 
				},onSelect:function(record){
					var ArcimID=$("#ItemRowid").val();
					ItemBillUOMCombCreat(ArcimID,"");
				}
		 });
	});
}

//���տ���
function DHCDocOrderRecLocCombCreat(ArcimID,DefaultOrdRecLoc,DefaultFlag){
	//alert(ArcimID)
		var cbox = $HUI.combobox("#DHCDocOrderRecLoc", {
				url:$URL+"?ClassName=web.UDHCFavItemNew&QueryName=CombListFind&CombName=DHCDocOrderRecLoc&Inpute1="+ArcimID+"&Inpute2="+DefaultOrdRecLoc+"&Inpute3="+DefaultFlag,
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				mode:"remote",
				//data: GridData["rows"],
				loadFilter:function(data){
				    return data['rows'];
				},
				onBeforeLoad:function(param){
					param = $.extend(param,{Inpute4:param['q']});
				}/*,
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				}*/,onLoadSuccess:function(){
					//$(this).combobox('select',DefaultOrdRecLoc);
				},onChange:function(newValue,oldValue){
					if (newValue==""){
						$('#DHCDocOrderRecLoc').combobox('select',"");
						$('#ItemBillUOM').combobox('select',""); 
						var ArcimID=$("#ItemRowid").val();
						ItemBillUOMCombCreat(ArcimID,"")
					}
				},onSelect:function(record){
					var ArcimID=$("#ItemRowid").val();
					ItemBillUOMCombCreat(ArcimID,"");
				}
		 });
	//});
}

//���ٵ�λ
function Combox_OrderFlowRateUnit(){
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"OrderFlowRateUnit", 
		rows:99999
	},false);
	var cbox = $HUI.combobox("#OrderFlowRateUnit", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			}
	 });
}

//����˵��
function Combox_OrderPriorRemarks() {
	var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"OrderPriorRemarks", 
		Inpute1:"",
		rows:99999
	},false);
	var cbox = $HUI.combobox("#OrderPriorRemarks", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},onLoadSuccess:function(){
				//$(this).combobox('select',"");
			}
	 });
}

//Ƥ�Ա�ע
function Combox_SkinAction() {
	/*var GridData=$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"OrderAction", 
		rows:99999
	},false);
	var cbox = $HUI.combobox("#SkinAction", {
			valueField: 'CombValue',
			textField: 'CombDesc', 
			editable:true,
			data: GridData["rows"],
			filter: function(q, row){
				return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onSelect: function (r) {
				
			}
	 });*/
	 var cbox = $HUI.combobox("#SkinAction", {
		url:$URL+"?ClassName=DHCDoc.Chemo.COM.Qry&QueryName=QryPS&ResultSetType=array",
		valueField:'rowid',
		textField:'desc',
		mode:'remote',
		editable:false,
		blurValidValue:true,
		onSelect: function (r) {
			if (typeof r != "undefined") {
				if (r.rowid==0) {
					$("#SkinTest").checkbox("enable");	
					$(this).combobox("clear");
				} else {
					$("#SkinTest").checkbox("uncheck");
					$("#SkinTest").checkbox("disable");		
				}
				
			}
		}
	});
	
}

//��ʼ���걾
function Combox_sampleType(ArcimDr,SampleID,Flag) {
	ArcimDr=ArcimDr||"",
	SampleID=SampleID||"",
	Flag=Flag||"";
	
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"sampleType", 
		Inpute1:ArcimDr,Inpute2:SampleID,Inpute3:Flag,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#sampleType", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(data){
					$(this).combobox('select',SampleID);
					if ((Flag==1)&&(data.length>0)){
						$(this).combobox('select',data[0]['CombValue']);
					}
				}
		 });
	});
}

function OrderItemLookupSelect(txt) {
	Clear_Mes();
	setTimeout(function(){
		var ARCOSPrescType="Other"
		var adata=txt.split("^");
		var idesc=adata[0];
		var icode=adata[1];
		var ifreq=adata[2];
		var iordertype=adata[3];
		var ialias=adata[4];
		var isubcatcode=adata[5];
		var iorderCatID=adata[6];
		var iSetID=adata[7];
		var mes=adata[8];
		var irangefrom=adata[9];
		var irangeto=adata[10]
		var iuom=adata[11];
		var idur=adata[12];
		var igeneric=adata[13];
		var match="notfound";
		var SetRef=1;
		var OSItemIDs=adata[15];
		var iorderSubCatID=adata[16];
		if (ARCOSPrescType!="Other"){
			var ibilluom=adata[19]
		}else{
			var ibilluom=adata[20]
		}
	    if (iordertype=="ARCOS") {
		    //ҽ����ID
			$("#ItemRowid").val(""); 
			//ҽ������
			$("#ItemDesc").lookup("setText","");
			
		    return;
		}
		if (iordertype=="ARCIM") iSetID="";
		var idoseqtystr=""
		var DefaultDoseQty="",DefaultDoseUOMRowid="";
		var ArcimClassification="";
		var ArcItemCat="";
		var ret=$.cm({
			ClassName:"web.DHCDocOrderCommon",
			MethodName:"GetARCIMDetail",
			ArcimRowid:icode, 
			dataType:"text",
		},false);
		
		if (ret!=""){
			var idesc=mPiece(ret,"^",0);
			var OrderType=mPiece(ret,"^",1);
			var ArcItemCat=mPiece(ret,"^",2);
			m_Itemcat=ArcItemCat
			var ipackqtystr=mPiece(ret,"^",5);
			var iformstr=mPiece(ret,"^",6);
			var idoseqtystr=mPiece(ret,"^",7);
			m_idoseqtystr=idoseqtystr;
			var ifrequencestr=mPiece(ret,"^",8);
			var iinstructionstr=mPiece(ret,"^",9);
			var idurationstr=mPiece(ret,"^",10);
			var ArcimClassification=mPiece(ret,"^",12);
			var NotifyClinician=mPiece(ret,"^",13);
			var ARCIMDefSensitive=mPiece(ret,"^",14);
			var PHPrescType=mPiece(ret,"^",16);
			
			PageLogicObj.m_SameFreqDifferentDosesFlag=mPiece(ret,"^",15);//ͬƵ�β�ͬ����ҽ����־
			PageLogicObj.m_PHPrescType=PHPrescType;
			var OrderPackQty=mPiece(ipackqtystr,String.fromCharCode(1),0);
			var OrderPackUOM=mPiece(ipackqtystr,String.fromCharCode(1),1);
			var OrderPackUOMRowid=mPiece(ipackqtystr,String.fromCharCode(1),2);
			var OrderFreq=mPiece(ifrequencestr,String.fromCharCode(1),0);
			var OrderFreqRowid=mPiece(ifrequencestr,String.fromCharCode(1),1);
			var OrderFreqFactor=mPiece(ifrequencestr,String.fromCharCode(1),2);
			var OrderFreqInterval=mPiece(ifrequencestr,String.fromCharCode(1),3);
			var OrderInstr=mPiece(iinstructionstr,String.fromCharCode(1),0);
			var OrderInstrRowid=mPiece(iinstructionstr,String.fromCharCode(1),1);
			var OrderDur=mPiece(idurationstr,String.fromCharCode(1),0);
			var OrderDurRowid=mPiece(idurationstr,String.fromCharCode(1),1);
			var OrderDurFactor=mPiece(idurationstr,String.fromCharCode(1),2); 
			var DefaultDoseQty="";
			var DefaultDoseUOMRowid="";
			if (idoseqtystr!=""){
				var ArrData=idoseqtystr.split(String.fromCharCode(2));
				for (var i=0;i<ArrData.length;i++) {
					 var ArrData1=ArrData[i].split(String.fromCharCode(1));
					 if (i==0) {
					 	var DefaultDoseQty=ArrData1[0];
					 	var DefaultDoseQtyUOM=RowidData=ArrData1[1];
					 	var DefaultDoseUOMRowid=RowidData=ArrData1[2];
					}
				}
			}
		}
		//ҽ����ID
		$("#ItemRowid").val(icode); 
		//ҽ������
		$("#ItemDesc").lookup("setText",idesc); 
		//�Ӽ���־
		if(NotifyClinician!="Y") {
			$("#NotifyClinician").checkbox("setValue",false)
			$HUI.checkbox('#NotifyClinician').disable();
		}else{
			$HUI.checkbox('#NotifyClinician').enable();
		}
		if (ARCIMDefSensitive=="Y"){
			$("#NotifyClinician").checkbox("check");
		}else{
			$("#NotifyClinician").checkbox("uncheck");
		}
		//��ʼ��������λ
		ItemDoseUOMCombCreat(icode,DefaultDoseUOMRowid); 
		//����װ��λ
		ItemBillUOMCombCreat(icode,OrderPackUOMRowid);
		DefaultDoseQty=ChangeNum(DefaultDoseQty)
		//���μ���
		if (DefaultDoseQty!="") $("#ItemDoseQty").val(DefaultDoseQty);
		//���տ���
		
	    Combox_DHCDocOrderRecLoc(icode,"",0); 
	   
		//��ҩ�����²����и�ֵ
		if (ARCOSPrescType=="Other"){
			//��ʼ���걾
			sampleTypeCombCreat(icode,"",1);
			OrderPackQty=ChangeNum(OrderPackQty)
			if (OrderFreqRowid!="")  {
				$('#ItemFrequence').combobox('select',OrderFreqRowid);//Ƶ��
				ItemFrequenceChange();
			}
			if (OrderInstrRowid!="")  $('#ItemInstruction').combobox('select',OrderInstrRowid); //�÷�
			if (OrderDurRowid!="")  $('#ItemDuration').combobox('select',OrderDurRowid);
			if (OrderPackQty!="")  $("#ItemQty").val(OrderPackQty);
		}
		m_ArcimClassification=ArcimClassification;
		DHCDocOrderTypeCombCreat();
		setTimeout(function(){
			ChangeFormStyle(ArcimClassification,iorderSubCatID,idoseqtystr);
		});
		InitBodyPartLabel(true);
		if (PageLogicObj.m_SameFreqDifferentDosesFlag=="Y") {
			OrdDoseQtyBindClick();
		}
	});
			
}
function OrderItemLookupSelectOld (item,defaultVal) {
	Combox_ItemDoseUOM(item.ArcimDR,defaultVal);
	Combox_ItemBillUOM(item.ArcimDR,defaultVal)
	Combox_DHCDocOrderRecLoc(item.ArcimDR,defaultVal)
	//Combox_sampleType(item.ArcimDR,defaultVal)
	if ((("^" + ServerObj.NotLinkItemCat + "^").indexOf("^" + item.itemDr + "^") >= 0)){ 
		$("#ItmLinkDoctor").val("").prop("disabled",true);
	} else {
		$("#ItmLinkDoctor").prop("disabled",false);
	}
}

function LoadLinkArcimData(MObj) {
	Combox_ItemDoseUOM(MObj.TPGIArcimDR,MObj.TPGIDosageUomDR);
	
	Combox_DHCDocOrderRecLoc(MObj.TPGIArcimDR,MObj.TPGIRecLoc)
	//setTimeout(function () {
		Combox_ItemBillUOM(MObj.TPGIArcimDR,MObj.TPGIUomDR)
	//},10)
}

function InitData() {
	if (ServerObj.TPGIID!="") {
		$cm({
			ClassName:"DHCDoc.Chemo.Model.TemplateItem",
			MethodName:"GetInfo",
			TPGIID: ServerObj.TPGIID
		},function(MObj){
			console.log(MObj)
			$("#ItemDesc").lookup('setText', MObj.TPGIArcimDesc);
			PLObject.v_Arcim = MObj.TPGIArcimDR
			if ((("^" + ServerObj.NotLinkItemCat + "^").indexOf("^" + MObj.TPGIItemDr + "^") >= 0)){ 
				$("#ItmLinkDoctor").prop("disabled",true);
			} else {
				$("#ItmLinkDoctor").prop("disabled",false);
			}
			$("#ItemDoseQty").val(MObj.TPGIDosage);
			//$("#ItemDoseUOM").combobox('select', MObj.TPGIDosageUomDR);
			$("#ItemFrequence").combobox('select', MObj.TPGIFreqDR);
			$("#ItemInstruction").combobox('select', MObj.TPGIInstrucDR);
			$("#ItemDuration").combobox('select', MObj.TPGIDuratDR);
			$("#ItemQty").val(MObj.TPGIQty);
			//$("#ItemBillUOM").combobox('select', MObj.TPGIUomDR);
			$("#ItmLinkDoctor").val(MObj.TPGILinkItem);
			//$("#remark").combobox('select', MObj.TPGINote);
			$("#remark").val(MObj.TPGINote);
			$("#DHCDocOrderType").combobox('select', MObj.TPGIPriorDR);
			//$("#sampleType").combobox('select', MObj.TPGISimpleDR);
			$("#OrderPriorRemarks").combobox('select', MObj.TPGIRemark);
			//$("#DHCDocOrderRecLoc").combobox('select', MObj.TPGIRecLoc);
			$("#DHCDocOrderStage").combobox('select', MObj.TPGIStage);
			$("#OrderSpeedFlowRate").val(MObj.TPGIFlowRate);
			$("#OrderFlowRateUnit").combobox('select', MObj.TPGIFlowRateDR);
			$("#SkinTest").checkbox("getValue")?"Y":"N";
			if (MObj.TPGISkinAction!="") {
				$("#SkinAction").combobox('select', MObj.TPGISkinAction);
			}
			$("#Formula").combobox('select', MObj.TPGIFormula);
			LoadLinkArcimData(MObj);
			$("#BSAUnitSTD").val(MObj.TPGIBSAUnitSTD);
			$("#BSAUnit").val(MObj.TPGIBSAUnit);
			$("#MainDrugNote").val(MObj.TPGIMainDrugNote);
			$("#ShowDate").val(MObj.TPGIShowDate);
			if (MObj.TPGISkinTest == "Y") {
				$("#SkinTest").checkbox("check")
			} else {
				$("#SkinTest").checkbox("uncheck")
			}
			if (MObj.TPGIMainDrug == "Y") {
				$("#MainDrug").checkbox("check")
			} else {
				$("#MainDrug").checkbox("uncheck")
			}
		});
	}
	
}
function SaveItem () {
	var TPGID = ServerObj.TPGID;
	var id = ServerObj.TPGIID;
	var arcim = PLObject.v_Arcim||""
	var dosage = $.trim($("#ItemDoseQty").val());
	var dosageUom = $("#ItemDoseUOM").combobox('getValue')||"";
	var freq = $("#ItemFrequence").combobox('getValue')||"";
	var instruc = $("#ItemInstruction").combobox('getValue')||"";
	var dura = $("#ItemDuration").combobox('getValue')||"";
	var qty = $.trim($("#ItemQty").val());
	var uom = $("#ItemBillUOM").combobox('getValue')||"";
	var linkitem = $.trim($("#ItmLinkDoctor").val());
	//var linkitem = PLObject.m_ItmLinkDoctor.getValue()||"";			//
	//var note = $("#remark").combobox('getValue')||"";				//��ע
	var note = $.trim($("#remark").val());
	var prior = $("#DHCDocOrderType").combobox('getValue')||"";
	var simple = ""	//$("#sampleType").combobox('getValue')||"";
	var remark = $("#OrderPriorRemarks").combobox('getValue')||"";	//����˵��
	var recloc = $("#DHCDocOrderRecLoc").combobox('getValue')||"";
	var stage = $("#DHCDocOrderStage").combobox('getValue')||"";
	var flowrate = $.trim($("#OrderSpeedFlowRate").val());
	var flowrateDR = $("#OrderFlowRateUnit").combobox('getValue')||"";
	var skinTest = $("#SkinTest").checkbox("getValue")?"Y":"N";
	var skinAction = $("#SkinAction").combobox('getValue')||"";
	var MainDrug = $("#MainDrug").checkbox("getValue")?"Y":"N";
	var Formula = $("#Formula").combobox('getValue')||"";
	var user = session['LOGON.USERID'];
	var BSAUnitSTD = $.trim($("#BSAUnitSTD").val());
	var BSAUnit = $.trim($("#BSAUnit").val());
	var MainDrugNote = $.trim($("#MainDrugNote").val());
	var ShowDate = $.trim($("#ShowDate").val());
	new Promise(function(resolve,rejected){
		if (arcim == "") {
			$.messager.alert("��ʾ", "����дҽ�����ƣ�", "info");
			return false;
		}
		if (prior == "") {
			$.messager.alert("��ʾ", "����дҽ�����ͣ�", "info");
			return false;
		}
		
		if (dosageUom == "") {
			$.messager.alert("��ʾ", "����д������λ��", "info");
			return false;
		}
		if (freq == "") {
			$.messager.alert("��ʾ", "����дƵ�Σ�", "info");
			return false;
		}
		if (instruc == "") {
			$.messager.alert("��ʾ", "����д�÷���", "info");
			return false;
		}
		if (dura == "") {
			$.messager.alert("��ʾ", "����д�Ƴ̣�", "info");
			return false;
		}
		
		if (flowrate!="") {
			var OrderSpeedFlowRateArr=flowrate.split("-");
			if (OrderSpeedFlowRateArr.length>=3) {
				$.messager.alert('��ʾ','��������Ч����Һ����������Χ!����2-9',"info",function(){
					$("#OrderSpeedFlowRate").focus();
				});
				return false;
			} else if (OrderSpeedFlowRateArr.length==2) {
				if ((OrderSpeedFlowRateArr[0]=="")||(OrderSpeedFlowRateArr[1]=="")) {
					$.messager.alert('��ʾ','��������Ч����Һ����������Χ!����2-9',"info",function(){
						$("#OrderSpeedFlowRate").focus();
					});
					return false;
				}
				
				if ((!isNumber(OrderSpeedFlowRateArr[0]))||(!isNumber(OrderSpeedFlowRateArr[1]))) {
					$.messager.alert('��ʾ','��������Ч����Һ����������Χ!����2-9',"info",function(){
						$("#OrderSpeedFlowRate").focus();
					});
					return false;
				}
				
			} else {
				if (!isNumber(flowrate)) {
					$.messager.alert("��ʾ", "��������ȷ����Һ���٣�", "info",function () {
						$("#OrderSpeedFlowRate").focus();	
					});
					return false;
				}
			}
		}	
	
		resolve();
	}).then(function(resolve) {
		return new Promise(function(resolve,rejected){
			if (MainDrug == "Y") {
				if (Formula == "") {
					$.messager.confirm("��ʾ", "���㹫ʽû��ά��,�Ƿ������", function (r) {
						if (r) {
							resolve();		
						} else {
							return false;
						}
					});
					return false;
				} else {
					resolve();
				}
			} else {
				resolve();
			}
		})
		
		
	}).then(function(){
		return new Promise(function(resolve,rejected){
			if ((MainDrug == "N")&&(Formula!="")) {
				$.messager.confirm("��ʾ", "���ǻ�����ҩ������ά�����㹫ʽ,�Ƿ������", function (r) {
					if (r) {
						resolve();		
					} else {
						return false;
					}
				});
				return false;
			} else {
				resolve();
			}
		})
		
	}).then(function(){
		var mList = id + "^" + arcim + "^" + dosage + "^" + dosageUom + "^" + freq + "^" + instruc + "^" + dura + "^" + qty + "^" + uom;
		mList = mList + "^" + linkitem + "^" + note + "^" + prior + "^" + simple + "^" + remark + "^" + recloc + "^" + stage + "^" + flowrate;
		mList = mList + "^" + flowrateDR + "^" + skinTest + "^" + skinAction + "^" + MainDrug + "^" + Formula + "^" + BSAUnitSTD + "^" + BSAUnit;
		mList = mList + "^" + MainDrugNote + "^" + ShowDate;
		
		$m({
			ClassName:"DHCDoc.Chemo.CFG.Item",
			MethodName:"SaveTPLGroupItem",
			TPGID:TPGID,
			mList:mList
		}, function(result){
			if (result == 0) {
				$.messager.alert("��ʾ", "����ɹ���", "info",function () {
					websys_showModal("hide");
					websys_showModal('options').CallBackFunc();
					websys_showModal("close");	
				});
			} else if (result == "-108") {
				$.messager.alert("��ʾ", "�����Ѵ��ڣ�" , "info");
				return false;
			} else {
				$.messager.alert("��ʾ", "����ʧ�ܣ�" + result , "info");
				return false;
			}
		});
	})
	
	

	
}
function ClearLinkArcimData() {
	Combox_ItemDoseUOM("");
	Combox_ItemBillUOM("")
	Combox_DHCDocOrderRecLoc("")
	//Combox_sampleType("")
}

function ClearItem () {
	ClearLinkArcimData();
	$('#ItemDesc').focus();
	$("#ItemDesc").lookup("setText","");
	PLObject.v_Arcim = "";
	
	$("#ItemDoseQty,#ItemQty,#ItmLinkDoctor,#OrderSpeedFlowRate,#remark,#BSAUnitSTD").val("");
	$("#SkinTest").checkbox('uncheck');
	$("#ItemFrequence,#ItemInstruction,#ItemDuration,#DHCDocOrderType,#DHCDocOrderRecLoc,#DHCDocOrderStage,#OrderFlowRateUnit,#SkinAction,#OrderPriorRemarks,#sampleType").combobox("clear");
	
	
}

function ChangeNum(InputNum)
{
	InputNum=InputNum.replace(/(^\s*)|(\s*$)/g,'');
	if (InputNum==""){return ""}
	if (InputNum.indexOf("-")>=0) {
		var NewInputNum="";
		for (var i=0;i<InputNum.split("-").length;i++){
			var FormateInputNum=tkMakeServerCall("web.UDHCFavItemNew","ChangeQty",InputNum.split("-")[i]);
			if (NewInputNum=="") NewInputNum=FormateInputNum;
			else  NewInputNum=NewInputNum+"-"+FormateInputNum;
		}
		return NewInputNum;
	}else{
		InputNum=tkMakeServerCall("web.UDHCFavItemNew","ChangeQty",InputNum);
		return InputNum;
	}
}

function InitBodyPartLabel(ShowPartWinFlag){
	var ARCIMRowid=$("#ItemRowid").val(); 
	if (ARCIMRowid==""){
		return;
	}
	var ItemServiceFlag = $cm({
		ClassName:"web.DHCDocOrderCommon",
		MethodName:"GetItemServiceFlag",
		InStr:ARCIMRowid,
		dataType:"text"
	},false);
	var isExistPart=0;
	if (ItemServiceFlag=="1"){
		isExistPart=$cm({
			ClassName:"web.DHCAPPInterface",
			MethodName:"isExistPart",
			itmmastid:ARCIMRowid,
			dataType:"text"
		},false);
	}
	if ((isExistPart=="1")&&(ItemServiceFlag=="1")){
		if (ShowPartWinFlag==true){
			OrderBodyPartLabelTextFocusHandler();
		}
		setTimeout(function(){
			$("#OrderBodyPartLabelText").prop("disabled",false);
		});
		$("#OrderBodyPartLabelText").click(function(){
		    OrderBodyPartLabelTextFocusHandler();
		});
	}else{
		setTimeout(function(){
			$("#OrderBodyPartLabelText").prop("disabled",true);
		});
		$("#OrderBodyPartLabelText").val("");
		$("#OrderBodyPartLabel").val("");
		$("#OrderBodyPartLabelText").unbind("click");
	}
}

function ChangeFormStyle(ArcimClassification,ArcItemSubCat,idoseqtystr) { 
	if (ArcimClassification=="ARCOS"){
		$(".textbox").not("#ItemDesc").prop("disabled",true);  
		$(".hisui-combobox").combobox('disable'); 
		$("#ItemDoseUOM,#DHCDocOrderRecLoc,#ItemBillUOM,#sampleType").combobox('disable'); 
		$(".hisui-checkbox").checkbox('disable');
		return;
	}
	m_idoseqtystr=idoseqtystr;
	m_ArcimClassification=ArcimClassification;
	m_iorderSubCatID=ArcItemSubCat;
	$(".textbox").prop("disabled",false);  
	$(".hisui-combobox").combobox('enable'); 
	var InstructionRowID=$("#ItemInstruction").combobox('getValue');
	if ((SkinTestInstr!="")&&(SkinTestInstr.indexOf(InstructionRowID)>=0)) {
		$("#SkinAction").combobox('setValue',"").combobox('disable');
		//$("#SkinTest").checkbox('disable').checkbox('uncheck');
	}
	if (ArcimClassification !="RW") {
		$("#SkinTest").checkbox('disable')
		$("#SkinAction").combobox('setValue',"").combobox('disable');
	}else{
		$("#SkinTest").checkbox('enable')
		$("#SkinAction").combobox('enable');
	}
	if ((("^" + NotLinkItemCat + "^").indexOf("^" + m_iorderSubCatID + "^") >= 0)){ 
		$("#ItmLinkDoctor").val("").prop("disabled",true);
	}
	//���顢���ҽ��
	if((ArcimClassification=="L")||(ArcimClassification=="E")) {
		//������λ��Ƶ�Ρ��Ƴ̡��÷�������˵�� ���ɱ༭
		$("#ItemDoseUOM,#ItemFrequence,#ItemDuration,#ItemInstruction,#OrderPriorRemarks").combobox('disable');
		//���μ��������� ���ɱ༭
		$("#ItemDoseQty").prop("disabled",true);
		//ҽ������ ǿ����ʱ
		$("#DHCDocOrderType").combobox('select',ShortOrderPriorRowid);
	}
	//��ҩƷ����顢����ҽ��,�ж�ά��ҽ���׵�Ƶ�κ��÷��ǲ��ǿ�ѡ Ƶ�κ��Ƴ�ͬ��,������Ƶ��Ҳ����ά���Ƴ�
	var DisPlayFreq="N",DisInstr="N";
	if ((ArcItemSubCat!="")&&(ArcimClassification!="RW")){
		//¼��Ƶ�εķ�ҩƷ����
		//if ((FrequencedItemCat!="")&&(("^"+FrequencedItemCat+"^").indexOf("^"+ArcItemSubCat+"^")>=0)){
		if (PageLogicObj.m_PHPrescType =="4"){
			DisPlayFreq="Y";
		}
		//��ѡ���÷��ķ�ҩƷ�ӷ���
		if ((inputInstrNotDrugCat!="")&&(("^"+inputInstrNotDrugCat+"^").indexOf("^"+ArcItemSubCat+"^")>=0)){
			DisInstr="Y";
		}
		if (DisPlayFreq!="Y"){
			$("#ItemFrequence,#ItemDuration").combobox('disable');
		}else{
            $("#ItemFrequence,#ItemDuration").combobox('enable');
        }
		if (DisInstr!="Y"){
			$("#ItemInstruction").combobox('disable');
		}
	}
	//���������ҩ Ҳ���ǲ�ҩ �򵥴μ�����λ����¼��
	if ((ArcimClassification!="RW")&&(ArcimClassification!="RC")){
		$("#ItemDoseUOM").prop("disabled",true);
	}
	//���������λ��Ϊ���ҷ�¼��Ƶ�εķ�ҩƷ���࣬������¼�����
	if ((idoseqtystr=="")&&(DisPlayFreq=="N")){ 
		$("#ItemDoseQty").prop("disabled",true);
	}
	//����ҩ ����ά����Һ���� ���ٵ�λ
	if (ArcimClassification!="RW"){
		$("#OrderSpeedFlowRate").prop("disabled",true);
		$("#OrderFlowRateUnit").combobox('disable');
		if (ArcimClassification=="RC"){
			//��ҩ ������λ���걾������˵����ҽ���׶�
			$("#ItemBillUOM,#sampleType,#OrderPriorRemarks,#DHCDocOrderStage").combobox('disable');
			//����װ����������
			$("#ItemQty,#ItmLinkDoctor").prop("disabled",true);
		}
	}else{
		$("#sampleType").combobox('disable');
	}
	if (ArcimClassification=="O"){
		if ($("#DHCDocOrderType").combobox('getValue')==LongOrderPriorRowid){
			var PHPrescType=$.cm({
				ClassName:"web.DHCDocOrderCommon",
				MethodName:"GetPHPrescType",
				ItemCatRowid:ArcItemSubCat, 
				dataType:"text",
			},false);
			if (PHPrescType==4){
				$("#ItemDoseQty").prop("disabled",false);
				if (idoseqtystr==""){
					//#ItemBillUOM  CombValue CombDesc
					var data=$("#ItemBillUOM").combobox('getData');
					$("#ItemDoseUOM").combobox('loadData',data);
					if (data.length==1){
						$("#ItemDoseUOM").combobox('select',data[0]['CombValue']);
					}
				}
			}
		}else{
			if ((idoseqtystr=="")&&(DisPlayFreq=="N")){
				$("#ItemDoseQty").val('');
				$("#ItemDoseUOM").combobox('loadData',[]);
				$("#ItemDoseUOM").combobox('select',"");
			}
		}
	}
	//ChangePrescTypeLayout();
	
	/*//����label
	$("#CsampleType").hide();
	//����comboԪ��
	$("#sampleType").next(".combo").hide();
	//����textbox
	//��ʾcombo��label
	$("#CItemDoseQty,#CItemDoseUOM,#CItmLinkDoctor,#CItemFrequence,#CItemDuration,#CItemInstruction,#COrderPriorRemarks").show();
	$("#CItemDoseQty").parent().show();
	//��ʾcomboԪ��
	$("#ItemDoseQty,#ItemDoseUOM,#ItmLinkDoctor,#ItemFrequence,#ItemDuration,#ItemInstruction,#OrderPriorRemarks").next(".combo").show();
	//��ʾtextbox
	$("#ItemDoseQty,#ItmLinkDoctor").show();
	
	//ҽ������ ǿ����ʱ
	//$("#DHCDocOrderType").combobox('setValue','');
	if((ArcimClassification=="L")||(ArcimClassification=="E")) {
		//����label
		$("#CItemDoseQty,#CItemDoseUOM,#CItmLinkDoctor,#CItemFrequence,#CItemDuration,#CItemInstruction,#COrderPriorRemarks").hide();
		//����comboԪ��
		$("#ItemDoseUOM,#ItemFrequence,#ItemDuration,#ItemInstruction,#OrderPriorRemarks").next(".combo").hide();
		//����textx		box
		$("#ItemDoseQty,#ItmLinkDoctor").hide();
		//��ʾcombo��label
		$("#CsampleType").show();
		//��ʾcomboԪ��
		$("#sampleType").next(".combo").show();
		//��ʾtextbox
		//ҽ������ ǿ����ʱ
		$("#DHCDocOrderType").combobox('setValue',ShortOrderPriorRowid);
	}
	
	//��������ҩƷͬʱ���Ǽ�����ҽ��,�ж�ά��ҽ���׵�Ƶ�κ��÷��ǲ��ǿ�ѡ Ƶ�κ��Ƴ�ͬ��������Ƶ��Ҳ����ά���Ƴ�
	if ((ArcItemSubCat!="")&&(ArcimClassification!="RW"))
	{
		var DisPlayFreq="N"
		var DisInstr="N"
		if ((FrequencedItemCat!="")&&(("^"+FrequencedItemCat+"^").indexOf("^"+ArcItemSubCat+"^")>=0)){DisPlayFreq="Y"}
		if ((SelectInstrNotDrugCat!="")&&(("^"+SelectInstrNotDrugCat+"^").indexOf("^"+ArcItemSubCat+"^")>=0)){DisInstr="Y"}
		if (DisPlayFreq=="Y"){
			$("#CItemFrequence").show();$("#ItemFrequence").next(".combo").show();
			$("#CItemDuration").show();$("#ItemDuration").next(".combo").show();
			$("#CItemFrequence").parent().parent().show();
		}
		else{
			$("#CItemFrequence").hide();$("#ItemFrequence").next(".combo").hide();
			$("#CItemDuration").hide();$("#ItemDuration").next(".combo").hide();
			$("#CItemFrequence").parent().parent().hide();
		}
		if (DisInstr=="Y"){$("#CItemInstruction").show();$("#ItemInstruction").next(".combo").show();}else{$("#CItemInstruction").hide();$("#ItemInstruction").next(".combo").hide();}
		
	}
	//���������ҩ Ҳ���ǲ�ҩ �򵥴μ�����λ����¼��
	if ((ArcimClassification!="RW")&&(ArcimClassification!="RC")){
		$("#CItemDoseUOM").hide();$("#ItemDoseUOM").next(".combo").hide();
	}
	//���������λ��Ϊ�գ�������¼�����
	if (idoseqtystr==""){ 
		$("#CItemDoseQty").hide();$("#ItemDoseQty").hide();
	}else{
	}
	if (ArcimClassification=="RW"){
		$("#COrderSpeedFlowRate,#OrderSpeedFlowRate").show();
		$("#COrderFlowRateUnit").show();$("#OrderFlowRateUnit").next(".combo").show();
	}else{
		$("#COrderSpeedFlowRate,#OrderSpeedFlowRate").hide();
		$("#COrderFlowRateUnit").hide();$("#OrderFlowRateUnit").next(".combo").hide();
	}
	ChangePrescTypeLayout();*/
}

function ItemFrequenceChange(){
	var OrderFreqRowid=$("#ItemFrequence").combobox('getValue');
	 if ($("#ItemFrequence").combobox('getText')=="") OrderFreqRowid="";
	 if (OrderFreqRowid!="") {
		 var FreqInfoStr="";
		 var Data=$("#ItemFrequence").combobox('getData');
		 for(var i=0;i<Data.length;i++){
			 var CombValue=Data[i].CombValue
			 var CombDesc=Data[i].CombDesc
			  if(CombValue==OrderFreqRowid){
				  FreqInfoStr=Data[i].CombValueInfo;
				  break;
		      }
		  }
		  if (FreqInfoStr!="") {
			    var Split_Value = FreqInfoStr.split("!"); //String.fromCharCode(1)
				var WeekFlag = Split_Value[8];
				var FreeTimeFreqFlag = Split_Value[12];
				if (WeekFlag=="Y") {
					new Promise(function(resolve,rejected){
						//��Ƶ��
						var OrderFreqDispTimeStr=""; //$("#OrderFreqDispTimeStr").val();
						GetOrderFreqWeekStr(OrderFreqRowid,OrderFreqDispTimeStr,resolve);
					}).then(function(OrderFreqWeekInfo){
						var OrderFreqDispTimeStr=mPiece(OrderFreqWeekInfo, "^", 0);
						if (OrderFreqDispTimeStr==""){
				            $.messager.alert("��ʾ","��Ƶ�������ѡ��ʹ������!","info",function(){
					            $("#ItemFrequence").combobox('setValue',"");
				            	$("#OrderFreqDispTimeStr").val("");
					        });
				            return;
						}
						var OrderFreqWeekDesc=mPiece(OrderFreqWeekInfo, "^", 1);
						var CalOrderStartDateStr=mPiece(OrderFreqWeekInfo, "^", 2);
						$("#OrderFreqDispTimeStr").val(OrderFreqDispTimeStr);
						var OrderFreq=$("#ItemFrequence").combobox('getText')+" "+OrderFreqWeekDesc;
						$("#ItemFrequence").combobox('setText',OrderFreq);
						ChangeOrderFreqTimeDoseStr();
					})
				}else if (FreeTimeFreqFlag=="Y"){
					new Promise(function(resolve,rejected){
						//������ַ�ʱ��
						var OrderFreqDispTimeStr=""; //$("#OrderFreqDispTimeStr").val();
						GetOrderFreqFreeTimeStr(OrderFreqRowid,OrderFreqDispTimeStr,resolve);
					}).then(function(OrderFreqFreeTimeInfo){
						var OrderFreqDispTimeStr=mPiece(OrderFreqFreeTimeInfo, "^", 0);
						if (OrderFreqDispTimeStr==""){
				            $.messager.alert("��ʾ","������ַ�ʱ��Ƶ�������ѡ��ַ�ʱ��!","info",function(){
					            $("#ItemFrequence").combobox('setValue',"");
				            	$("#OrderFreqDispTimeStr").val("");
					        });
				            return;
						}
						var OrderFreqFactor=OrderFreqDispTimeStr.split(String.fromCharCode(1)).length;
						var OrderFreqWeekDesc=mPiece(OrderFreqFreeTimeInfo, "^", 1);
						$("#OrderFreqDispTimeStr").val(OrderFreqDispTimeStr);
						var OrderFreq=$("#ItemFrequence").combobox('getText')+" "+OrderFreqWeekDesc;
						$("#ItemFrequence").combobox('setText',OrderFreq);
						ChangeOrderFreqTimeDoseStr();
					})
					
				}else{
					$("#OrderFreqDispTimeStr").val("");
					ChangeOrderFreqTimeDoseStr();
				}
				
		  }
	  }
}
	
function ChangeOrderFreqTimeDoseStr(callBackFun){
	var OrderFreqRowid=$("#ItemFrequence").combobox('getValue');
	var OrderFreqDispTimeStr=$("#OrderFreqDispTimeStr").val();
    if (PageLogicObj.m_SameFreqDifferentDosesFlag=="Y"){
	    var FreqDispTimeDoseQtyStr=$("#OrderFreqTimeDoseStr").val();
	    var FreqDispTimeStr=$.m({
		    ClassName:"web.DHCOEOrdItemView",
		    MethodName:"GetFreqFreqDispTimeStr",
		    OrderFreqRowid:OrderFreqRowid,
		    OrderFreqDispTimeStr:OrderFreqDispTimeStr,
		    type:"text"
		},false);
		if (FreqDispTimeStr.split("!").length==1) {
			$("#OrderFreqTimeDoseStr").val("");
			var OrderDoseQty=$("#ItemDoseQty").val();
			if (OrderDoseQty!="") {
				$("#ItemDoseQty").val(OrderDoseQty.split("-")[0]);
			}
			$("#ItemDoseQty").prop("readonly",false);
			if (callBackFun) callBackFun();
			return;
		}
		var OrderARCIMRowid=$("#ItemRowid").val();
		var OrderName=$("#ItemDesc").lookup('getText');
		var OrderDoseUOM=$("#ItemDoseUOM").combobox('getText');
		new Promise(function(resolve,rejected){
		    ShowFreqQty(FreqDispTimeStr,OrderName,FreqDispTimeDoseQtyStr,OrderDoseUOM,resolve);
		}).then(function(OrderFreqTimeDoseStr){
			if (OrderFreqTimeDoseStr!=""){
				$("#OrderFreqTimeDoseStr").val(OrderFreqTimeDoseStr);
			    var DoseQtyStr=GetDoseQty(OrderFreqTimeDoseStr);
			    $("#ItemDoseQty").val(DoseQtyStr).prop("readonly",true);
			}else{
				$("#OrderFreqTimeDoseStr,#ItemDoseQty").val("");
				$.messager.alert("��ʾ"," ͬƵ�β�ͬ����ҽ������ذ��շַ�ʱ����д����!","info",function(){
					$("#ItemDoseQty").prop("readonly",false);
				})
			}
			if (callBackFun) callBackFun();
		})
	}else{
		if (callBackFun) callBackFun();
	}
}

function Clear_Mes(){
	ClearLinkArcimData();
	//$('#ItemDesc').focus();
	$("#ItemDesc").lookup("setText","");
	//PLObject.v_Arcim = "";
	
	$("#ItemDoseQty,#ItemQty,#ItmLinkDoctor,#OrderSpeedFlowRate,#remark,#BSAUnitSTD").val("");
	$("#SkinTest").checkbox('uncheck');
	$("#ItemFrequence,#ItemInstruction,#ItemDuration,#DHCDocOrderType,#DHCDocOrderRecLoc,#DHCDocOrderStage,#OrderFlowRateUnit,#SkinAction,#OrderPriorRemarks,#sampleType").combobox("clear");
	
	
	
}

//��ʼ���걾
function sampleTypeCombCreat(ArcimDr,SampleID,Flag)
{
	$.cm({
		ClassName:"web.UDHCFavItemNew",
		QueryName:"CombListFind",
		CombName:"sampleType", 
		Inpute1:ArcimDr,Inpute2:SampleID,Inpute3:Flag,
		rows:99999
	},function(GridData){
		var cbox = $HUI.combobox("#sampleType", {
				valueField: 'CombValue',
				textField: 'CombDesc', 
				editable:true,
				data: GridData["rows"],
				filter: function(q, row){
					return (row["CombDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},onLoadSuccess:function(data){
					$(this).combobox('select',SampleID);
					if ((Flag==1)&&(data.length>0)){
						$(this).combobox('select',data[0]['CombValue']);
					}
				}
		 });
	});
}

//ͬƵ�β�ͬ�������--start
function OrdDoseQtyBindClick(){
	//�Ƚ���󶨷�ʽclick��ֹ�ظ���
	$("#ItemDoseQty").unbind('click');
	$("#ItemDoseQty").click(function(){
		new Promise(function(resolve,rejected){
			ChangeOrderFreqTimeDoseStr(resolve);
		}).then(function(){
			//SetPackQty(rowid);
		})
	});
}
