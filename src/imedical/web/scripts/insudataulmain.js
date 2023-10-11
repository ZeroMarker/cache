/**
 * FileName: insudataulmain.js
 * Anchor: wty
 * Date: 2021-03-15
 * Description: ҽ�������ϴ�����
 * ���������ϴ����нӿ�����
 */
var GV={
	 mainDtlList:null,
	 m_PARID:"",
	 m_AdmDr:"",
	 m_DivDr:"",
	 m_OptType:"",
	 m_HospDr:"",
	 m_USERID:session['LOGON.USERID'],
	 DPLRowid:"",
	 DPLInfno:"",
	 m_AdmType:"",
	 m_PrtDr:"",
	 m_BillDr:"",
	 m_ddv:null
	 }
$(document).ready(function () {		
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initDataDtlList();
	initHOSPID();
	initInsuType();
});

function initQueryMenu() {
	$('#SDate, #EDate').datebox();
	
	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			loadDataDtlList();
		}
	});

	//�ǼǺŻس���ѯ�¼�
	$('#PatNo').keydown(function (e) {
		patientNoKeyDown(e);
	});
	
	//�����Żس���ѯ�¼�
	$('#MedNo').keydown(function (e) {
		MedicareNoKeyDown(e);
	});
	
	///�ϴ���־
	$HUI.combobox('#UpFlag', {
		panelHeight: 'auto',
		data: [{
				value: '1',
				text: 'δ�ϴ�',
				'selected':true
			}, {
				value: '2',
				text: '���ϴ�'
			}
		],
		valueField: 'value',
		textField: 'text',
		onSelect: function (data) {	
		   if(data.value=="2"){
			  $('#DateFlag').combobox('select',5);
			}				
		}
	});
	
	///���ڱ�־
	$HUI.combobox('#DateFlag', {
		panelHeight: 'auto',
		data: [/*{
				value: '1',
				text: '��Ժ����',
			}, {
				value: '2',
				text: '��Ժ����'
			},*/{
				value: '3',
				text: '��������',
				'selected':true
			}, {
				value: '4',
				text: '��Ŀ����',				
			}, {
				value: '5',
				text: '�ϴ�����',				
			}
		],
		valueField: 'value',
		textField: 'text'
	});	
	
	///ҵ������
	$HUI.combobox('#OptType', {
		panelHeight: 'auto',
		data: [{
				value: 'OP',
				text: '����',				
			}, {
				value: 'IP',
				text: 'סԺ',
				'selected':true
			}
		],
		valueField: 'value',
		textField: 'text',		
	});

	$('#SDate, #EDate').datebox('setValue', getDefStDate(0));
	$("#btn-up").click(BUpClickHandle);
	$("#btn-del").click(BDelClickHandle);
	$("#info").select();
	$('#InfoWin').dialog({
		buttons:[{
			text:'�ر�',
			handler:function(){
				$('#InfoWin').dialog('close');
			}
		},
		{
			text:'����',
			handler: function(){
				copyText($("#copyInfo").text());
			}
		}]
		})	
}


function patientNoKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: 'web.UDHCJFBaseCommon',
			MethodName: 'regnocon',
			PAPMINo: $(e.target).val()
		}, function (PatNo) {
			$(e.target).val(PatNo);
			loadDataDtlList();
		});
	}
}

//�����Żس��¼�
function MedicareNoKeyDown(e) {
	var e = e || window.event;
	if (e.keyCode == 13) {
		var MedNo = jQuery("#MedNo").val();
		loadDataDtlList();
	}
}

function setUpbtnAbled(PrtActStus,UpFlag)
{
  var PrtActStusN=PrtActStus||"";	
  var UpFlagN= UpFlag || "";	   
  //todo ...Flag ���� 
  var Flag=PrtActStusN;				        					        
  switch (Flag)
	    { 
	      case "Y" :
              enableById("btn-up");    
			  enableById("btn-del");    
                break;
           case "N" :
                 disableById("btn-up");    
			     disableById("btn-del"); 
                break;
           default :
                 enableById("btn-up");    
			     enableById("btn-del"); 
                 break;
         }					        			        
	return 	;			        
					       				        
}

function initDataDtlList() {
GV.mainDtlList=	$HUI.datagrid('#mainDtlList', {
		fit: true,
		border: false,
		striped: true,
		//singleSelect: true,
		selectOnCheck: true,
	   //checkOnSelect: false,
		autoRowHeight: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		data: [],
		view: detailview,
		detailFormatter: function(rowIndex, rowData) {
			return "<div style=\"padding:2px;\"><table class=\"ddv\"></table></div>"
		},
		onExpandRow: function(rowIndex, rowData) {
			GV.m_PARID=rowData.Did || "";
			GV.m_AdmDr=rowData.AdmDr;
			GV.m_DivDr=rowData.DivDr;
			GV.m_OptType=$('#OptType').combobox('getValue');
			GV.m_PrtDr=rowData.TPrtDr;
		    //GV.m_HospDr=$('#HOSPID').combobox('getValue');
		    GV.m_HospDr=rowData.THospID;
			//var $ddv = GV.mainDtlList.getRowDetail(rowIndex).find("table.ddv");
			GV.m_InsuType=rowData.TInsuType;
			GV.m_ddv= GV.mainDtlList.getRowDetail(rowIndex).find("table.ddv");
			//	$ddv.datagrid({
			GV.m_ddv.datagrid({
				width: 800,
				height: 'auto',
				bodyCls: 'panel-body-gray',
				//singleSelect: true,
				loadMsg: '',
				rownumbers: true,
				pageList: [5,10,30],
				pageSize: 5,
				pagination: true,
			    selectOnCheck: false,
		        checkOnSelect: false,
			columns: [[
			    {
		
					title: 'ck1',
					field: 'ck1',
					checkbox: true
				},
			      {
					title: '���ױ��',
					field: 'TradeNo',
					align: 'center',
					width: 80
				}, {
					title: '��������',
					field: 'TradeDesc',
					align: 'center',
					width: 150
				},{
					title: '�ϴ���־',
					field: 'UpFlag',
					align: 'center',
					width: 80,
					styler:UpFlagStyle
				},
				{
				   field:'InptPara',
				   title:'�������',
				   width:80,
				   formatter:setInputInfoFormatter  //DingSH 20220331
				 },
			    {
				    field:'OutPara',
			        title:'���׳���',
			        width:80,
			        formatter:setOutputInfoFormatter
			    }
				, {
					title: '�ϴ���',
					field: 'OptUser',
					align: 'center',
					width: 80
				}, {
					title: '�ϴ�����',
					field: 'OptDate',
					align: 'center',
					width: 100
				}
				, {
					title: '�ϴ�ʱ��',
					field: 'OptTime',
					align: 'center',
					width: 100
				}
				,{
					title: 'Rowid',
					field: 'DPLid',
					hidden:true
				}
				,{
					title: 'Rowid',
					field: 'DParid',
					hidden:true
				}
			]],
				url: $URL,
				queryParams: {
					//PARID='+RowId+"&OptType="+$('#OptType').combobox('getValue')+"&HospDr="+$('#HOSPID').combobox('getValue'),
					ClassName: 'web.DHCINSUDataUL',
		            QueryName: 'QueryPortList',
		            PARID:GV.m_PARID,
		            OptType:GV.m_OptType,
		            HospDr:GV.m_HospDr,
		            InsuType:GV.m_InsuType
				},
				onLoadSuccess: function(data) {
					setTimeout(function() {
						GV.mainDtlList.fixDetailRowHeight(rowIndex);    //�����̶�����ϸ���ݼ���ʱ���и߶�
					}, 0);
				},
				onSelect:function(index,row){
					 GV.DPLRowid = row.DPLid;
					 GV.DPLInfno = row.TradeNo;
					},
				onUnselect:function(index,row) {
					   GV.DPLRowid = "";
					   GV.DPLInfno = "";
					}
				
			});
			GV.mainDtlList.fixDetailRowHeight(rowIndex);    //�����̶�����ϸ���ݼ���ʱ���и߶�
		},
		onCollapseRow:function(rowIndex, rowData)
		 {
			//alert(31)
			GV.DPLRowid="";
			GV.DPLInfno="";
			GV.m_ddv=null;
			GV.m_InsuType="";
		 },
		columns: [[{
		
					title: 'ck',
					field: 'ck',
					checkbox: true
				},
		         {
					title: '�ϴ���־',
					field: 'TOptFlag',
					align: 'center',
					width: 80,
					formatter: function (value, row, index) {
						//btnstr="<a type='button'  onclick=\"EprListDetail(\'" + row.Did + "\')\" style='width:70px;height:25px;font-size:14px'>"+value+"</a>";
						btnstr="<a type='button'   style='width:70px;height:25px;font-size:14px'>"+value+"</a>";
						return btnstr						
					}
				}, {
					title: '����',
					field: 'TPatName',
					align: 'center',
					width: 80
				},{
					title: '�ǼǺ�',
					field: 'TPatRegNo',
					align: 'center',
					width: 100
				},  {
					title: '������',
					field: 'TMedcasNo',
					align: 'center',
					width: 100
				}, {
					title: 'סԺ����',
					field: 'TDepDesc',
					align: 'center',
					width: 120
				}, {
					title: '��Ժ����',
					field: 'TAdmDate',
					align: 'center',
					width: 100
				}, {
					title: '��Ժ����',
					field: 'TOutDate',
					align: 'center',
					width: 100
				}, {
					title: '��������',
					field: 'TDisDate',
					align: 'center',
					width: 100
				},{
					title: '��Ʊ״̬',
					field: 'TPrtActStus',
					align: 'center',
					width: 80,
					styler: function(value,row,index){
				        var rtnStyle="";
					    switch (value)
					    { 
					      case "N" :
	    		                rtnStyle= 'color:red';
	    		                break;
	    	               default :
	    		                 rtnStyle= '';
	    		                 break;
	                     }		
					return rtnStyle
				},
				formatter: function(value,row,index){
				if (value == "Y"){
					return "��Ч";
				} else {
					return "��Ч";
				}
			   }
				
				}, {
					title: 'ҽ������',
					field: 'TInsuNo',
					align: 'center',
					width: 120
				}, {
					title: 'ҽ���Ǽ�id',
					field: 'TInsuZylsh',
					align: 'center',
					width: 160,
					hidden:true
				}, {
					title: 'ҽ������id',
					field: 'TInsuDjlsh',
					align: 'center',
					width: 160,
					hidden:true
				}
				, {
					title: '�ϴ���Ա',
					field: 'TOpter',
					align: 'center',
					width: 100
				}, {
					title: '�ϴ�����',
					field: 'TOptDate',
					align: 'center',
					width: 150
				}, {
					title: 'ҽ������',
					field: 'TInsuType',
					align: 'center',
					width: 80
				}, {
					title: 'Rowid',
					field: 'Did',
					align: 'center',
					width: 60
				}, {
					title: 'AdmDr',
					field: 'AdmDr',
					align: 'center',
					width: 60
				}, {
					title: 'DivDr',
					field: 'DivDr',
					align: 'center',
					width: 60
				}, {
					title: '��������',
					field: 'TAdmType',
					align: 'center',
					width: 80
				}, {
					title: 'ҽԺ',
					field: 'THospID',
					align: 'center',
					width: 60
				}, {
					title: '��ƱDr',
					field: 'TPrtDr',
					align: 'center',
					width: 80
				}
				
			]],
			onLoadSuccess: function(){
				$(".easyui-tooltip").tooltip({
					onShow: function () {
						$(this).tooltip('tip').css({
							borderColor: '#000'
						});
					}
				});
				//$("a[name='view']").linkbutton({});
			},
			
		  onSelect:function(index,row){
			        setUpbtnAbled(row.TPrtActStus);
					GV.m_PARID=row.Did;
			        GV.m_AdmDr=row.AdmDr;
			        GV.m_DivDr=row.DivDr;
			        GV.m_OptType=$('#OptType').combobox('getValue');
			        GV.m_PrtDr=row.TPrtDr;
		            //GV.m_HospDr=$('#HOSPID').combobox('getValue');
		            GV.m_HospDr=row.THospID;
		            GV.m_InsuType=row.TInsuType;
		            
		            
		            
					}
					
			
			
		
	});
}

function loadDataDtlList() {
	setUpbtnAbled("")
	var stDate = $('#SDate').datebox('getValue');
	var endDate = $('#EDate').datebox('getValue');
	var queryParams = {
		ClassName: 'web.DHCINSUDataUL',
		QueryName: 'QueryPat',
		MedNo: $('#MedNo').val(),
		PatNo: $('#PatNo').val(),		
		SDate: stDate,
		EDate: endDate,		
		DateFlag: $('#DateFlag').combobox('getValue') || '',
		UpFlag: $('#UpFlag').combobox('getValue') || '',		
		InsuType: $('#InsuType').combobox('getValue') || '',
		OptType:$('#OptType').combobox('getValue') || '',
		HOSPID:$('#HOSPID').combobox('getValue') || '',
	};
	loadDataGridStore('mainDtlList', queryParams);
}

function initHOSPID(){
	$('#HOSPID').combogrid({  
	    panelWidth:350,   
	    panelHeight:220,  
	    idField:'Rowid',   
	    textField:'Desc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = 'INSU.COM.BaseData';
	      	param.QueryName = 'QueryHospInfo';
	     },
	    columns:[[   
	        {field:'Rowid',title:'����ID',width:60},  
	        {field:'Desc',title:'����',width:100}
	    ]],
	    fitColumns: true,
	    onSelect:function(){
		   initInsuType()
		},
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				$('#HOSPID').combogrid('grid').datagrid('selectRow',0);
		    }
		}
	}); 	
}
function initInsuType(){
	$('#InsuType').combogrid({  
	    panelWidth:350,   
	    panelHeight:220,
	    idField:'Code',   
	    textField:'Desc', 
      	rownumbers:false,
      	fit: true,
      	pagination: false,
      	editable:false,
      	url:$URL,
      	onBeforeLoad:function(param){
	      	param.ClassName = 'web.DHCINSUDataUL';
	      	param.QueryName = 'QueryDicInfo';
	      	param.DicType="DLLType"
	      	param.HospDr = $('#HOSPID').combobox('getValue');
	     },
	    columns:[[   
	        {field:'Code',title:'����ID',width:40},  
	        {field:'Desc',title:'����',width:100}
	    ]],
	    fitColumns: true,
	    onSelect:function()
	    {	
	      $('#mainDtlList').datagrid({data:[]});	    
		},
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				//$('#InsuType').combogrid('grid').datagrid('selectRow',0);
				$('#InsuType').combogrid('grid').datagrid('selectRecord','00A'); //���޸�
		    }
		}
	}); 	
}


/*
 ����ʹ�� �޸� DingSH 20220411 
*/
/*function EprListDetail(RowId){
	websys_showModal({
		url: 'insudataportlistdtl.csp?PARID='+RowId+"&OptType="+$('#OptType').combobox('getValue')+"&HospDr="+$('#HOSPID').combobox('getValue'),
		title: '�ϴ�������ϸ��Ϣ',
		iconCls: 'icon-w-list',
		height:600,
		width:800
	});		
}*/

function BUpClickHandle()
{
	var myRows = $("#mainDtlList").datagrid('getRows');
	var outstr="",Flag="", n=1;
	for(var i=0;i<myRows.length;i++){
		if($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).is(':checked')) Flag=1;
		else Flag=0;
		var row =myRows[i];
		if (Flag==1){
			var Infno=GV.DPLInfno ; //����Ϊ��,��ȫ������
			var InArgType="STR",OutArgType="JSON";
			//ҽ������^�ӿڱ��^ҽԺID^����ԱID^0^102^1^�����^InsuDivID^��������^��ƱId^�˵�Id
				      var m_PARID=row.Did || "";
			          var m_AdmDr=row.AdmDr;
			          var m_DivDr=row.DivDr;
			          var m_OptType=$('#OptType').combobox('getValue');
			          var m_PrtDr=row.TPrtDr;
		            //var m_HospDr=$('#HOSPID').combobox('getValue');
		              var m_HospDr=row.THospID;
			          var m_AdmType="";
			          var m_BillDr="";
			          var m_InsuType=row.TInsuType; //�Է� �� ҽ�����������ѱ�
			          var DLLInsuType=m_InsuType; //�ӿ�ҽ������
			          if (DLLInsuType==""){DLLInsuType="00A";}
			          
			var InArgInfo=DLLInsuType+"^"+Infno+"^"+m_HospDr+"^"+GV.m_USERID+"^0^^1^"+m_AdmDr+"^"+m_DivDr+"^"+m_OptType+"^"+m_PrtDr+"^"+m_BillDr;
			var ExpStr=DLLInsuType+"^^"+m_OptType+"^"+m_PARID+"^"+m_InsuType;
			InsuDataUL(0,GV.m_USERID,InArgInfo,InArgType,OutArgType,ExpStr); //DHCInsuPort.js
			if((GV.m_ddv)&&(Infno)) {
				GV.m_ddv.datagrid("reload")
				}
		}
			
			     
			
		 				
	}	
}

function BDelClickHandle()
{
	var myRows = $("#mainDtlList").datagrid('getRows');
	var outstr="",Flag="", n=1;
	for(var i=0;i<myRows.length;i++){
		if($("#mainDtlList").parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(i).is(':checked')) Flag=1;
		else Flag=0;
		if (Flag==1){
			///�����ӿڡ������������������
			var DPLRowid=GV.DPLRowid;
			if(GV.DPLRowid==""){
				$.messager.alert("��ܰ��ʾ","��ѡ��һ�������Ľ���", 'info');
				return;
				}
			var ExpStr=$('#InsuType').combobox('getValue')+"^^";
			var InArgInfo=DPLRowid+"^"+GV.m_AdmDr+"^"+GV_m_DivDr,InArgType="STR",OutArgType="JSON";
			InsuAdmDataULCancel(0,GV.m_USERID,InArgInfo,InArgType,OutArgType,ExpStr) ;//DHCInsuPort.js
		}		
	}	
}
function setInputInfoFormatter(value,row,index){
	 var PLRowid=row.DPLid || "";
	 var ULRowid=row.DParid || "";
	 var TradeNo=row.TradeNo || "";
	 var UpFlag=row.UpFlag || "";
	 var AdmDr =GV.m_AdmDr || "";
	 var DivDr=GV.m_DivDr || "";
	 var PrtDr=GV.m_PrtDr || ""; //+DingSH 20220614 
	 var nfhml="<span class='linkinfo' onclick='showInputJson("+"\""+PLRowid+"\""+","+"\""+ULRowid+"\""+","+"\""+TradeNo+"\""+","+"\""+GV.m_AdmDr+"\""+","+"\""+GV.m_DivDr+"\""+","+"\""+UpFlag+"\""+","+"\""+index+"\""+","+"\""+PrtDr+"\""+")'>����</span>";
	return nfhml;
}		    
function setOutputInfoFormatter(value,row,index)
{
     var PLRowid=row.DPLid || "";
	 var ULRowid=row.DParid || "";
	 var TradeNo=row.TradeNo || "";
	 var UpFlag=row.UpFlag || "";
	 //var AdmDr =row.AdmDr || "";
	 //var InDivDr=row.InDivDr || "";
	 var nfhml="<span class='linkinfo' onclick='showOutputJson("+"\""+PLRowid+"\""+","+"\""+ULRowid+"\""+","+"\""+TradeNo+"\""+","+"\""+GV.m_AdmDr+"\""+","+"\""+GV.m_DivDr+"\""+","+"\""+UpFlag+"\""+")'>����</span>";
	return nfhml;
}
function showInputJson(PLRowid,ULRowid,TradeNo,AdmDr,InDivDr,UpFag,index,PrtDr){
   $("#info").html("");
     var ckval=false;
     if((index)&&(GV.m_ddv.parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(':checked'))){
	     ckval=true;
	     }

   
   
	//if((UpFag=="�ϴ��ɹ�")||((UpFag=="�ϴ�ʧ��")))
    if((UpFag=="�ϴ��ɹ�")||(((UpFag=="�ϴ�ʧ��"))&&(!ckval)))
	{
		var options={
		ClassName:"web.DHCINSUDataUL",
		MethodName:"GetPLInPutData",
		PLRowid: PLRowid,
		ULRowid: ULRowid,
		TradeNo: TradeNo
	   }
	}
	else
	{
	 var InsuType=GV.m_InsuType;
	 if(InsuType==""){InsuType="00A"}
	 var InputInfo=InsuType+"^"+TradeNo+"^"+$('#HOSPID').combobox('getValue')+"^"+GV.m_USERID+"^0^^1^"+AdmDr+"^"+InDivDr+"^^"+PrtDr; //ҽ������^�ӿڱ��^ҽԺID^����ԱID^0^102^1^�����^InsuDivID^optType^PrtDr^�˵���
	var InArgType="STR"; //�������(JSON��STR)
	var OutArgType="JSON"     //���θ�ʽ(JSON,XML,STR)
	var options={
		ClassName:"INSU.OFFBIZ.BL.BIZ00A",
		MethodName:"InsuDataUL",
		InputInfo: InputInfo,
		InArgType: InArgType,
		OutArgType:OutArgType
		
	 }
	}
	var ret=$m(options,false);
	try{
		ret=JSON.stringify(JSON.parse(ret), null, 4);
	}catch(ex){}
	$("#info").html("<pre id='copyInfo'>"+ret+"</pre>");
	$('#InfoWin').dialog("setTitle",TradeNo+"-�������");
	$('#InfoWin').dialog("open");
}			
function showOutputJson(PLRowid,ULRowid,TradeNo,UpFag){
	$("#info").html("");
	var options={
		ClassName:"web.DHCINSUDataUL",
		MethodName:"GetPLOutPutData",
		PLRowid: PLRowid,
		ULRowid: ULRowid,
		TradeNo: TradeNo
	   }
	var ret=$m(options,false);
	try{
		ret=JSON.stringify(JSON.parse(ret), null, 4);
	}catch(ex){}
	$("#info").html("<pre id='copyInfo'>"+ret+"</pre>");
	$('#InfoWin').dialog("setTitle",TradeNo+"���׳���");
	$('#InfoWin').dialog("open");
}
function UpFlagStyle(value,row,index){
	if (value=="�ϴ�ʧ��") return "color:red;";
	if (value=="�ϴ��ɹ�") return "color:green;";
}
