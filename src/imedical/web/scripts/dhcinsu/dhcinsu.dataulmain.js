/**
 * FileName: dhcinsu.dataulmain.js
 * Anchor: wxq
 * Date: 2022-06-10
 * Description: ҽ�������ϴ�����
 * 
 */
 
var GV={
	 mainDtlList:null,
	 PortListDic:null,
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
	 m_ddv:null,
	 HOSPID:session['LOGON.HOSPID']
	 }
$(document).ready(function () {	


   var hospComp = GenUserHospComp();
	$.extend(hospComp.jdata.options, {
		onSelect: function(index, row){
			ClearDatagrid();
			initQueryMenu();
			loadDataDtlList();
		},
		onLoadSuccess: function(data){
			ClearDatagrid();
			initQueryMenu();
			loadDataDtlList();
		}
	});
	
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initDataDtlList();
	//initHOSPID();
	initInsuType();
	InitPortListDicDg();
	InitPortListULDg();
	initPortListSubYDg();
	initPortListSubNDg();
	initPortListSubFDg();
	var opt={width:"220"}
	GenUserHospComp(opt);
});





function initQueryMenu() {
	
	
	GV.HOSPID=$HUI.combogrid("#_HospUserList").getValue() ;
	//$('#_HospUserList').combogrid('panelWidth', '220');
	initInsuType();
	
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
			    //copyText($("#copyInfo").text());
				//upt DingSH 20220708
				var pre = document.getElementById("copyInfo")
				var text = pre.innerText;
				var input =$("<textarea></textarea>");
		    	input.text(text); // �޸��ı��������
		    	input.appendTo(pre);
		    	input.select(); // ѡ���ı�
		    	document.execCommand("copy"); // ִ���������������
		    	input.remove();
		    	//$.messager.alert("��ʾ", "���Ƴɹ�!", 'info');
				$.messager.popover({
				msg: '���Ƴɹ���' ,
				type: 'info',
				timeout: 1000, 		//0���Զ��رա�3000s
				showType: 'slide'  
			});
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
 GV.mainDtlList=$HUI.datagrid('#mainDtlList', {
		fit:true,
		border: false,
		striped: true,
		//singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 30, 40, 50],
		toolbar:[],
		columns: [[
		{
		
				title: 'ck',
				field: 'ck',
				checkbox: true
				},
		         {
					title: '�ϴ���־',
					field: 'TOptFlag',
					align: 'left',
					width: 80,
					formatter: function (value, row, index) {
						//btnstr="<a type='button'  onclick=\"EprListDetail(\'" + row.Did + "\')\" style='width:70px;height:25px;font-size:14px'>"+value+"</a>";
						btnstr="<a type='button'   style='width:70px;height:25px;font-size:14px'>"+value+"</a>";
						return btnstr						
					}
				}, {
					title: '����',
					field: 'TPatName',
					align: 'left',
					width: 80
				},{
					title: '�ǼǺ�',
					field: 'TPatRegNo',
					align: 'left',
					width: 100
				},  {
					title: '������',
					field: 'TMedcasNo',
					align: 'left',
					width: 100
				}, {
					title: 'סԺ����',
					field: 'TDepDesc',
					align: 'left',
					width: 120
				}, {
					title: '��Ժ����',
					field: 'TAdmDate',
					align: 'left',
					width: 100
				}, {
					title: '��Ժ����',
					field: 'TOutDate',
					align: 'left',
					width: 100
				}, {
					title: '��������',
					field: 'TDisDate',
					align: 'left',
					width: 100
				},{
					title: '��Ʊ״̬',
					field: 'TPrtActStus',
					align: 'left',
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
					align: 'left',
					width: 120
				}, {
					title: 'ҽ���Ǽ�id',
					field: 'TInsuZylsh',
					align: 'left',
					width: 160,
					hidden:true
				}, {
					title: 'ҽ������id',
					field: 'TInsuDjlsh',
					align: 'left',
					width: 160,
					hidden:true
				}
				, {
					title: '�ϴ���Ա',
					field: 'TOpter',
					align: 'left',
					width: 100
				}, {
					title: '�ϴ�����',
					field: 'TOptDate',
					align: 'left',
					width: 150
				}, {
					title: 'ҽ������',
					field: 'TInsuType',
					align: 'left',
					width: 80
				}, {
					title: 'Rowid',
					field: 'Did',
					align: 'left',
					width: 60
				}, {
					title: 'AdmDr',
					field: 'AdmDr',
					align: 'left',
					width: 60
				}, {
					title: 'DivDr',
					field: 'DivDr',
					align: 'left',
					width: 60
				}, {
					title: '��������',
					field: 'TAdmType',
					align: 'left',
					width: 80
				}, {
					title: 'ҽԺ',
					field: 'THospID',
					align: 'left',
					width: 60
				}, {
					title: '��ƱDr',
					field: 'TPrtDr',
					align: 'left',
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
		            QryPortListDic(row)
		            
		            
					}
					
			
			
		
	});

}
/*
 * ���ָ��Ԫ�ص�datagird����
 * ClearDatagrid('PortListDic','PortListUL') 
 * ClearDatagrid() ���Ϊ��,���Ĭ����ָ����ȫ��Ԫ��grid����
*/
function ClearDatagrid(){
	   var elms=arguments
	   if (arguments.length==0){
	      elms=['PortListDic','PortListUL','PortListSubY','PortListSubN','PortListSubF']
	   }
	   elms.forEach(function(elm) {
           var dg =$HUI.datagrid('#'+elm)
	      if( typeof dg!="undefined" ){
	          dg.loadData({total:0,rows:[]})
	        }
         });
	}
function loadDataDtlList() {
	setUpbtnAbled("")
	ClearDatagrid();  ///LuJH 2022 10-19
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
		HOSPID: GV.HOSPID || '',
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
	      	param.HospDr =GV.HOSPID ;
	     },
	    columns:[[   
	        {field:'Code',title:'����ID',width:40},  
	        {field:'Desc',title:'����',width:100}
	    ]],
	    fitColumns: true,
	    onSelect:function()
	    {	
	      //$('#mainDtlList').datagrid({data:[]});	 
	      loadDataDtlList(); //LuJH 2022.07.06
		},
	    onLoadSuccess:function(data){
		    if(data.rows.length > 0){
				//$('#InsuType').combogrid('grid').datagrid('selectRow',0);
				$('#InsuType').combogrid('grid').datagrid('selectRecord','00A'); //���޸�
		    }
		}
	}); 	
}


//��ѯ�ϴ��ֵ�
function QryPortListDic(row){

    var queryParams = {
	    ClassName : 'web.DHCINSUDataUL',
	    QueryName : 'QueryPortListDic',
	    PARID:row.Did,
	   OptType:$('#OptType').combobox('getValue'),
	   HospDr:row.THospID,
	   InsuType:row.TInsuType
	    
	}	
    loadDataGridStore('PortListDic',queryParams)

}


//��ʼ���ϴ��ֵ�
function InitPortListDicDg() {
	GV.PortListDic=	$('#PortListDic').datagrid({
		fit:true,
		border:false,
		striped:true,
		//singleSelect: true,
		rownumbers: true,
		pageList: [5,10,30],
		pageSize: 10,
		pagination: true,
		toolbar:[],
		columns: [[
			{
	
				title: 'ck1',
				field: 'ck1',
				checkbox: true,
			},
				{
				title: '���ױ��',
				field: 'TradeNo',
				align: 'left',
				width: 80,
			}, {
				title: '��������',
				field: 'TradeDesc',
				align: 'left',
				width: 150
			},{
				title: '�ϴ���־',
				field: 'UpFlag',
				align: 'left',
				width: 80,
				styler:UpFlagStyle
			}
			
			, {
				title: '�ϴ���',
				field: 'OptUser',

			}, {
				title: '�ϴ�����',
				field: 'OptDate',

			}
			, {
				title: '�ϴ�ʱ��',
				field: 'OptTime',

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
				QryPortListUL(row);
				GV.DPLInfno=row.TradeNo; //DingSH 20220623 
				}
	});
}

//��ѯ�ϴ���¼
function QryPortListUL(row){

	var queryParams = {
	    ClassName : 'web.DHCINSUDataUL',
	    QueryName : 'QueryPortListUL',
	    PARID:row.DParid,
	    TradeNo:row.TradeNo,   
	}	
    loadDataGridStore('PortListUL',queryParams)
}

//��ʼ���ϴ���¼
function InitPortListULDg() {
	GV.PortListUL=	$('#PortListUL').datagrid({
		fit: true,
		border:false,
		striped:true,
		checkOnSelect:true,
		singleSelect: true,
		rownumbers: true,
		pageList: [5,10,30],
		pageSize: 5,
		pagination: true,
		toolbar:[],
		columns: [[
			{
				title: '�ϴ���־',
				field: 'UpFlag',
				align: 'left',
				width: 120,
				styler:UpFlagStyle
			},{
				field:'InptPara',
				title:'�������',
				width:100,
				formatter:setInputInfoFormatter,  //DingSH 20220331
			},{
				field:'OutPara',
				title:'���׳���',
				width:100,
				formatter:setOutputInfoFormatter,
			},{
				title: '�ϴ���',
				field: 'INDPLOpter',
				width:140,
			},{
				title: '�ϴ�����',
				field: 'INDPLOptDate',
				width:140,
			},{
				title: '�ϴ�ʱ��',
				field: 'INDPLOptTime',
				width:140,
			},{
				title: 'Rowid',
				field: 'DPLid',
				hidden:true
			},{
				title: 'ParRowid',
				field: 'DParid',
				hidden:true
			},{
				title: 'TradeNo',
				field: 'TradeNo',
				hidden:true
			}
		]],	
	});
}
///��ʼ����ϸ��ϸ���ϴ��б�
function initPortListSubYDg() {
	$('#PortListSubY').datagrid({
		fit:true,
		border:false,
		striped:true,
		checkOnSelect:true,
		singleSelect: true,
		rownumbers: true,
		pageList: [5,10,30],
		pageSize: 5,
		pagination: true,
		toolbar:[],
		columns: [[
			{
				title: '��Ŀ����',
				field: 'TradeNo',
				align: 'left',
				width:150,
			},{
				title: '��Ŀ����',
				field: 'TradeDesc',
				align: 'left',
				width:150,
			},{
				title: '�ϴ���־',
				field: 'UpFlag',
				align: 'left',
				width:140,
				styler:UpFlagStyle,
			},{
				title: '�ϴ���',
				field: 'OptUser',
				width:140,
			},{
				title: '�ϴ�����',
				field: 'OptDate',
				width:140,
			},{
				title: '�ϴ�ʱ��',
				field: 'OptTime',
				width:140,
			}
		]],    
	});		    
}

//��ʼ����ϸ��ϸδ�ϴ��б�
function initPortListSubNDg() {
	$('#PortListSubN').datagrid({
		fit:true,
		border:false,
		striped:true,
		checkOnSelect:true,
		singleSelect: true,
		rownumbers: true,
		pageList: [5,10,30],
		pageSize: 5,
		pagination: true,
		toolbar:[],
		columns: [[
			{
				title: '��Ŀ����',
				field: 'TradeNo',
				align: 'left',
				width:150,
			},{
				title: '��Ŀ����',
				field: 'TradeDesc',
				align: 'left',
				width:150,
			},{
				title: '�ϴ���־',
				field: 'UpFlag',
				align: 'left',
				width:140,
				styler:UpFlagStyle
			},{
				title: '�ϴ���',
				field: 'OptUser',
				width:140,
			},{
				title: '�ϴ�����',
				field: 'OptDate',
				width:140,
			},{
				title: '�ϴ�ʱ��',
				field: 'OptTime',
				width:140,
			}
		]],    
	});		    
}

//��ʼ����ϸ��ϸ�ϴ�ʧ���б�
function initPortListSubFDg() {
	$('#PortListSubF').datagrid({
		fit: true,
		border:false,
		striped:true,
		checkOnSelect:true,
		singleSelect: true,
		rownumbers: true,
		pageList: [5,10,30],
		pageSize: 5,
		pagination: true,
		toolbar:[],
		columns: [[
			{
				title: '��Ŀ����',
				field: 'TradeNo',
				align: 'left',
				width:150,
			},{
				title: '��Ŀ����',
				field: 'TradeDesc',
				align: 'left',
				width: 150
			},{
				title: '�ϴ���־',
				field: 'UpFlag',
				align: 'left',
				width:140,
				styler:UpFlagStyle
			},{
				title: '�ϴ���',
				field: 'OptUser',
				width:140,
			},{
				title: '�ϴ�����',
				field: 'OptDate',
				width:140,
			},{
				title: '�ϴ�ʱ��',
				field: 'OptTime',
				width:140,
			}
		]],	    
	});			    
}
//�ϴ���¼
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
			if((GV.PortListDic)&&(Infno)) {
				 GV.PortListDic.datagrid("reload")
				 GV.PortListUL.datagrid("reload")
				}
		}
			
			     
			
		 				
	}	
}
//�ϴ���¼����
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
	 var nfhml="<span class='linkinfo' onclick='showInputJson("+"\""+PLRowid+"\""+","+"\""+ULRowid+"\""+","+"\""+TradeNo+"\""+","+"\""+GV.m_AdmDr+"\""+","+"\""+GV.m_DivDr+"\""+","+"\""+UpFlag+"\""+","+"\""+index+"\""+","+"\""+PrtDr+"\""+")' style='text-align:center'>����</span>";
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
	 var nfhml="<span class='linkinfo' onclick='showOutputJson("+"\""+PLRowid+"\""+","+"\""+ULRowid+"\""+","+"\""+TradeNo+"\""+","+"\""+GV.m_AdmDr+"\""+","+"\""+GV.m_DivDr+"\""+","+"\""+UpFlag+"\""+")' style='text-align:center'>����</span>";
	return nfhml;
}
function showInputJson(PLRowid,ULRowid,TradeNo,AdmDr,InDivDr,UpFag,index,PrtDr){
   $("#info").html("");
     var ckval=false;
     if((index)&&(GV.PortListDic.parent().find("div.datagrid-cell-check").children("input[type='checkbox']").eq(index).is(':checked'))){
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
	 var InputInfo=InsuType+"^"+TradeNo+"^"+GV.HOSPID+"^"+GV.m_USERID+"^0^^1^"+AdmDr+"^"+InDivDr+"^^"+PrtDr; //ҽ������^�ӿڱ��^ҽԺID^����ԱID^0^102^1^�����^InsuDivID^optType^PrtDr^�˵���
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

function ClearGrid(gridid){
	$('#' + gridid).datagrid('loadData',{total:0,rows:[]});
}
