/**
 * ҽ��������ϢJS
 * FileName: insulocrecinfo.js
 * DingSH 2018-10-18
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
 var InLocRowid="";
 var InLocRecRowid="";
 var UpFlag ="";
 var HospDr='';
 var GUser=session['LOGON.USERID'];
 var LocRowIndex=-1;
 var LocRecRowIndex=-1;
 $(function()
 {
	$(document).keydown(function (e) {
		banBackSpace(e);
	}); 
	//#1��ʼ��ҽ������	
	InitInsuTypeCmb()	
	//#2��ʼ��ҽ������gd
	InitInLocDg()
		 
	//#3��ʼ��ҽ�����Ҽ�¼gd
	InitInLocRecDg()

	//#4��ʼ��Btn�¼�
	InitBtnClick();   
	  
	//#5����Ԫ��
	 $('#locDlEd').hide();
	 $('#locRecDlEd').hide();     
	 $('#locRecDlBd').hide();            
  	QryInLoc();	
});

//��ʼ��Btn�¼�
function InitBtnClick(){
	
	
	//�ؼ��ֻس��¼�
	$("#KeyWords").keydown(function(e) { 
	KeyWords_onkeydown(e);
	});  
	
	//������Ϣ�༭�� ���水ť�¼�
	 $("#btnS").click(function () {
	        UpdateInLoc();
            QryInLoc();
			
        });
    //������Ϣ�༭�� �رհ�ť�¼�    
   $("#btnC").click(function () {
            //QryInLoc();
			$('#locDlEd').window('close');  
       });       
    //������Ϣ�ϴ��༭�� ���水ť�¼�              
        
  $("#btnS1").click(function () {
            //QryInLoc();
            UpdateInLocRec();
            QryInLocRec();
        });
      //������Ϣ�ϴ��༭�� �رհ�ť�¼�   
   $("#btnC1").click(function () {
            //QrylocRecDlEd();
			$('#locRecDlEd').window('close');  
       });  
     //�ϴ���¼���ɿ� ���ɰ�ť�¼�  
    $("#btnRbd").click(function () {
            ReBuildInLocRec();
        });
        //�ϴ���¼���ɿ� �رհ�ť�¼�  
   $("#btnRbC").click(function () {
            //QrylocRecDlEd();
			$('#locRecDlBd').window('close');  
       });     
        
	
	}

//�ؼ��ֻس��¼�
function KeyWords_onkeydown(e)
{
	if (e.keyCode==13)
	{
		QryInLoc();
		
	}
}

//��ѯ������Ϣ�¼�
function QryInLoc()
{	
    //var stdate=$('#stdate').datebox('getValue');
	//var endate=$('#endate').datebox('getValue');
    var InRowid=""
    var KeyWords=$('#KeyWords').val();
	$('#locdg').datagrid('reload',{
		ClassName:'web.DHCINSULocInfoCtl',
		QueryName:'QryInLocInfo',
		InRowid:InRowid,
		KeyWords:KeyWords,
		HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
	});
	
}



//��ѯҽ�������ϴ���¼�¼�
function QryInLocRec()
{
    var InRowid=""
    var InsuType=$('#InsuType').combobox("getValue")
    //alert("InLocRowid="+InLocRowid)
       $('#locrecdg').datagrid('options').url = $URL
	   $('#locrecdg').datagrid('reload',{
		ClassName:'web.DHCINSULocRecCtl',
		QueryName:'QryInLocRecInfo',
		InLocRowid:InLocRowid,
		InsuType:InsuType,
		HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
		});
	
	
}

//��ʼ��ҽ������
function InitInsuTypeCmb()
{
	//��ʼ��combobox
	$HUI.combobox("#InsuType",{
		valueField:'cCode',
    	textField:'cDesc',
    	panelHeight:100,
    	onSelect: function(rec)
    	{
	      QryInLocRec();
	    	
	    },
	    onLoadSuccess:function(){
			$('#InsuType').combobox('select','00A');
			},
	});
	var comboJson=$.cm({
	    ClassName:"web.INSUDicDataCom",
	    QueryName:"QueryDic",
	    Type:"DLLType",
	    HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
	    Code:""
	 },false)
	$HUI.combobox("#InsuType").loadData(comboJson.rows)
	
	}

//��ʼ��ҽ������gd
function InitInLocDg()
{
	$HUI.datagrid("#locdg",{
		url:$URL,
		fit: true,
		border: false,
		striped:true,
		singleSelect: true,
		frozenColumns:[[
		  { 
		    field:'TOpt',
		    width:40,
		    title:'����',
		    formatter: function (value, row, index) {
				return "<img class='myTooltip' style='width:60' title='������Ϣ�޸�' onclick=\"locEditClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";
			}
		  },{field:'TInd',title:'TInd',width:10,hidden:true},
			{field:'TRowid',title:'TRowid',width:10,hidden:true},
			{field:'TDeptCode',title:'ҽԺ���ұ���',width:140},
			{field:'TDeptDesc',title:'ҽԺ��������',width:180},
			{field:'TDeptType',title:'��������',width:150,hidden:true},
			{field:'TStandDeptCode',title:'���ҿ�������',width:120},
			{field:'TProfessionDeptCode',title:'���ҿ��Ҵ��� ',width:120},
			{field:'TDeptDr',title:'HIS����id',width:50,align:'center',hidden:true}
		]],
		columns:[[
			{field:'TSPBedNum',title:'��׼��λ����',width:100},
			{field:'TSJBedNum',title:'ҽ���Ͽɴ�λ����',width:120},
			{field:'TDeptSetUpDate',title:'���ҳ���ʱ��',width:100},
			{field:'TDoctorNum',title:'ҽʦ����',width:80},
			{field:'TTechnicianNum',title:'��ʦ����',width:80},
			{field:'TPharmacistNum',title:'ҩʦ����',width:80},
			{field:'TNurseNum',title:'��ʿ����',width:80},
			{field:'TDeptHead',title:'���Ҹ�����',width:120},
			{field:'TDeptHeadTelNo',title:'���Ҹ����˵绰',width:120},
			{field:'Titro',title:'���',width:120},
			{field:'Tmedservscp',title:'ҽ�Ʒ���Χ',width:120},
			{field:'Tpoolareano',title:'ͳ�������',width:100},
			{field:'THospCode',title:'ҽԺ��������',width:50,hidden:true},
			{field:'TStDate',title:'��ʼ����',width:100},
			{field:'TStTime',title:'��ʼʱ��',width:50,hidden:true},
			{field:'TEdDate',title:'��������',width:100},
			{field:'TEdTime',title:'����ʱ��',width:50,hidden:true},
			{field:'TActFlag',title:'��Ч��־',width:50,hidden:true},
			{field:'TUserDr',title:'������',width:100,hidden:true},
			{field:'TUserName',title:'������',width:100},
			{field:'TDate',title:'��������',width:140},
			{field:'TTime',title:'����ʱ��',width:140},
			{field:'TRemark',title:'��ע',width:50},
			{field:'TExtStr01',title:'��չ01',width:50,hidden:true},
			{field:'TExtStr02',title:'��չ03',width:50,hidden:true},
			{field:'TExtStr03',title:'��չ03',width:50,hidden:true},
			{field:'TExtStr04',title:'��չ04',width:50,hidden:true},
			{field:'TExtStr05',title:'��չ05',width:50,hidden:true}
			
		]],
		pageSize: 10,
		pageList:[10,20,30],
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
			InLocRowid=rowData.TRowid;
			QryInLocRec();
        },
        onDblClickRow:function(rowIndex, rowData){
	        //initLocFrm(rowIndex, rowData);
	        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
        onLoadSuccess:function(data)
		{
			LocRowIndex=-1;
		}
	});	
}
//��ʼ��ҽ�����Ҽ�¼gd
function InitInLocRecDg()
{
	 //��ʼ��datagrid
	$HUI.datagrid("#locrecdg",{
		///idField:'recdgid',
		//rownumbers:true,
		url:$URL,
		fit:true,
		striped:true,
		singleSelect: true,
		modal:true,
		border:false,
		data: [],
		frozenColumns:[[
		  { 
		    field:'TOpt1',
		    width:40,
		    title:'����',
		    formatter: function (value, row, index) {
						
							return "<img class='myTooltip' style='width:60' title='�ϴ���¼�޸�' onclick=\"locRecEditClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/write_order.png' style='border:0px;cursor:pointer'>";
						
					}
		  }
		
		]],
		columns:[[
			{field:'TInd',title:'TInd',width:10,hidden:true},
			{field:'TRowid',title:'TRowid',width:10,hidden:true},
			{field:'TCTDr',title:'ҽ��������Ϣָ��',width:60,hidden:true},
			{field:'TCenterNo',title:'ͳ��������',width:100},
			{field:'TStates',title:'����������',width:100},
			{field:'TSeriNo',title:'������ˮ��',width:100},
			{field:'TBusiNo',title:'���ͷ�������ˮ��',width:150,hidden:true},
			{field:'TInsuType',title:'ҽ������',width:80,hidden:true},
			{field:'TInsuTypeDesc',title:'ҽ������',width:80,align:'left'},
			{field:'THSPUserDr',title:'ҽԺ������',width:60,hidden:true},
			{field:'THSPUserCode',title:'ҽԺ������',width:60,hidden:true},
			{field:'THSPUserName',title:'ҽԺ������',width:120},
			{field:'THSPFlag',title:'�����ϴ�״̬',width:140},
			{field:'THSPDate',title:'�����ϴ�����',width:140},
			{field:'THSPTime',title:'�����ϴ�ʱ��',width:140},
			{field:'TISPUserDr',title:'�ϴ���',width:140,hidden:true},
			{field:'TISPFlag',title:'ҽ������״̬',width:140},
			{field:'TISPDate',title:'ҽ����������',width:140},
			{field:'TISPTime',title:'ҽ������ʱ��',width:140},
			{field:'TUserDr',title:'������',width:60,hidden:true},
			{field:'TUserCode',title:'������',width:60,hidden:true},
			{field:'TUserName',title:'������',width:100},
			{field:'TDate',title:'��������',width:150},
			{field:'TTime',title:'����ʱ��',width:150},
			{field:'TExtStr01',title:'��չ01',width:50,hidden:true},
			{field:'TExtStr02',title:'��չ03',width:50,hidden:true},
			{field:'TExtStr03',title:'��չ03',width:50,hidden:true},
			{field:'TExtStr04',title:'��չ04',width:50,hidden:true},
			{field:'TExtStr05',title:'��չ05',width:50,hidden:true}
			
		]],
		pageSize: 10,
		pagination:true,
		//rownumbers:true,
        onClickRow:function(rowIndex, rowData) {
	      InLocRecRowid=rowData.TRowid;
	      UpFlag=rowData.THSPFlag
        },
         onDblClickRow:function(rowIndex, rowData){
	       
	        },
        onUnselect: function(rowIndex, rowData) {
        	//alert(rowIndex+"-"+rowData.itemid)
        },
        onLoadSuccess:function(data)
		{
			var index=0;
			if (data.total>0)
			{
			if (LocRecRowIndex>=0){
			   index=LocRecRowIndex
			 }
			$('#locrecdg').datagrid('selectRow',index);
			}
			LocRecRowIndex=-1; 

		}
	});
	

	
}

//���ؿ�����Ϣ
function loadLocPanel(rowIndex, rowData)
{

	$HUI.combobox('#ActFlag', {
		panelHeight: 'auto',
		data: [ {
				value: '1',
				text: '��Ч'
			},{
				value: '0',
				text: '��Ч'
			}
		],
		valueField: 'value',
		textField: 'text',
		onSelect: function (data) {					
		}
	});
	
	
	$HUI.combobox('#DeptType', {
		panelHeight: 'auto',
		data: [ {
				value: '1',
				text: '����'
			},{
				value: '2',
				text: 'סԺ'
			}
		],
		valueField: 'value',
		textField: 'text',
		onSelect: function (data) {					
		}
	});
	$("#StandDeptCode").combogrid({
		panelWidth: 320,
		panelHeight: 350,
		mode:'remote',
		delay:300,
		method: 'GET',
		striped: true,
		fitColumns: true,
		pagination:true,
		editable: true,
		valueField: 'cCode',
		textField: 'cDesc',
		//url:$URL,
		data:[],
		columns:[
		[{
			field:'id',title:'rowid',hidden:true},
			{field:'cCode',title:'����',width:100} ,
			{field:'cDesc',title:'����',width:100},
		]],
		onBeforeLoad:function(param){
				$('#StandDeptCode').combogrid("grid").datagrid("options").url=$URL;
				param.ClassName="web.INSUDicDataCom";
				param.QueryName="QueryDic";
				param.Type="dept00A";
				param.Code=param.q;
		},
		onLoadSuccess:function(data){
		},
		onSelect:function(index,rowData){
			setValueById('ProfessionDeptCode',rowData.cCode);		
			}	
	})
	$("#DeptHead").combogrid({
		panelWidth: 320,
		panelHeight: 350,
		mode:'remote',
		method: 'GET',
		striped: true,
		fitColumns: true,
		pagination:true,
		editable: true,
		valueField: 'Description',
		textField: 'Description',
		url:$URL,
		data:[],
		columns:[
		[{
			field:'HIDDEN',title:'HIDDEN',hidden:true},
			{field:'Code',title:'����',width:100} ,
			{field:'Description',title:'����',width:100},
		]],
		onBeforeLoad:function(param){
			param.ClassName = "web.SSUser";
			param.QueryName= "LookUpActive";
			param.desc = param.q;
			//param.Code=param.q
		},
		onLoadSuccess:function(data){
		},
		onSelect:function(index,rowData){	 
			}	
	})
	setValueById('DeptCode',rowData.TDeptCode)
	setValueById('DeptDesc',rowData.TDeptDesc)
	setValueById('DeptType',rowData.TDeptType)
	setValueById('StandDeptCode',rowData.TStandDeptCode)
	setValueById('ProfessionDeptCode',rowData.TProfessionDeptCode)
	setValueById('DeptDr',rowData.TDeptDr)
	setValueById('SPBedNum',rowData.TSPBedNum)
	setValueById('SJBedNum',rowData.TSJBedNum)
	setValueById('DeptSetUpDate',rowData.TDeptSetUpDate)
	setValueById('DoctorNum',rowData.TDoctorNum)
	setValueById('TechnicianNum',rowData.TTechnicianNum)
	setValueById('PharmacistNum',rowData.TPharmacistNum)
	setValueById('NurseNum',rowData.TNurseNum)
	setValueById('DeptHead',rowData.TDeptHead)
	setValueById('DeptHeadTelNo',rowData.TDeptHeadTelNo)
	setValueById('StDate',rowData.TStDate)
	setValueById('EdDate',rowData.TEdDate)
	setValueById('ActFlag',rowData.TActFlag)
	$('#UserDr').val(rowData.TUserDr)
	$('#UserName').val(rowData.TUserName)
	setValueById('Date',rowData.TDate)
	$('#Time').val(rowData.TTime)
	$('#Remark').val(rowData.TRemark)
//	$('#ExtStr01').val(rowData.TExtStr01)
//	$('#ExtStr02').val(rowData.TExtStr02)
//	$('#ExtStr03').val(rowData.TExtStr03)
//	$('#ExtStr04').val(rowData.TExtStr04)
//	$('#ExtStr05').val(rowData.TExtStr05)
//	$('#Remark').val(rowData.TRemark)
	$('#itro').val(rowData.Titro)
	$('#medservscp').val(rowData.Tmedservscp)
	$('#Rowid').val(rowData.TRowid)
	$('#HospCode').val(rowData.THospCode)

}

function  locEditClick(rowIndex){
	LocRowIndex=rowIndex;
	var rowData=$('#locdg').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');       
	initLocFrm(rowIndex,rowData)
	}

//��ʼ�����ұ༭��
function initLocFrm(rowIndex, rowData)
{      
    loadLocPanel(rowIndex, rowData);
    $('#locDlEd').show(); 
		$HUI.dialog("#locDlEd",{
			title:"������Ϣ�༭",
			height:510,
			width:850,
		    iconCls: 'icon-w-edit',
			modal:true
			//content:initLocFrmC(),
			/*pagination:true,toolbar:[{
					iconCls: 'icon-edit',
					text:'����',
					handler: function(){
						$.m(
							{
							ClassName:"web.INSUMsgInfo",
							MethodName:"update",
							MsgInfoDr:dgobj.getSelected().MsgInfoDr,
							InString:$('#ta').val()
							},
							function(textData){
							//console.dir(txtData);
							//if(textData!="") alert("�޸ĳɹ�,RowId:"+textData);
							//RunQuery();
							$('#locDlEd').window('close');  
						})					
					}
			}] */
		})
	
}

//���ؿ�����Ϣ
function loadLocRecPanel(rowIndex, rowData)
{
	$HUI.combobox('#RHSPFlag', {
		panelHeight: 'auto',
		data: [{
				value: '',
				text: 'δ�ϴ�',
				'selected':true
			}, {
				value: '1',
				text: '���ϴ�'
			},{
				value: '2',
				text: '�ѱ��'
			},{
				value: '0',
				text: '�ѳ���'
			}
		],
		valueField: 'value',
		textField: 'text',
		onSelect: function (data) {					
		}
	});
	$('#RCTDr').val(rowData.TCTDr);
	$('#RCenterNo').val(rowData.TCenterNo);
	$('#RStates').val(rowData.TStates);
	$('#RSeriNo').val(rowData.TSeriNo);
	$('#RBusiNo').val(rowData.TBusiNo);
	$('#RInsuType').val(rowData.TInsuType);
	$('#RInsuTypeDesc').val(rowData.TInsuTypeDesc);
	$('#RHSPUserName').val(rowData.THSPUserName);
	$('#RHSPUserDr').val(rowData.THSPUserDr);
	//$('#RHSPFlag').val(rowData.THSPFlag);
	setValueById('RHSPFlag',rowData.THSPFlag)
	//$('#RHSPDate').val(rowData.THSPDate);
	setValueById('RHSPDate',rowData.THSPDate)
	$('#RHSPTime').val(rowData.THSPTime);
	$('#RISPUserDr').val(rowData.TISPUserDr);
	$('#RISPFlag').val(rowData.TISPFlag);
	//$('#RISPDate').val(rowData.TISPDate);
	setValueById('RISPDate',rowData.TISPDate)
	$('#RISPTime').val(rowData.TISPTime);
	$('#RUserDr').val(rowData.TUserDr);
	$('#RUserName').val(rowData.TUserName);
	//$('#RDate').val(rowData.TDate);
	setValueById('RDate',rowData.TDate)
	$('#RTime').val(rowData.TTime);
	$('#RExtStr01').val(rowData.TExtStr01);
	$('#RExtStr02').val(rowData.TExtStr02);
	$('#RExtStr03').val(rowData.TExtStr03);
	$('#RExtStr04').val(rowData.TExtStr04);
	$('#TExtStr05').val(rowData.TExtStr05);
	$('#RRowid').val(rowData.TRowid);
}	
	
	
function  locRecEditClick(rowIndex){
	LocRecRowIndex=rowIndex;
	var rowData=$('#locrecdg').datagrid("getRows")[rowIndex]; //$('#dg').datagrid('fixColumnSize');       
	initLocRecFrm(rowIndex,rowData)
	
	}	
	
	
//��ʼ��ҽ���ϴ���¼�༭��
function initLocRecFrm(rowIndex, rowData)
{       
    loadLocRecPanel(rowIndex, rowData);
    $('#locRecDlEd').show(); 
		$HUI.dialog("#locRecDlEd",{
			title:"ҽ���ϴ���¼�༭",
			height:320,
			width:880,
			iconCls:'icon-w-edit',
			//content:initLocFrmC(),
			/*pagination:true,toolbar:[{
					iconCls: 'icon-edit',
					text:'����',
					handler: function(){
						$.m(
							{
							ClassName:"web.INSUMsgInfo",
							MethodName:"update",
							MsgInfoDr:dgobj.getSelected().MsgInfoDr,
							InString:$('#ta').val()
							},
							function(textData){
							//console.dir(txtData);
							//if(textData!="") alert("�޸ĳɹ�,RowId:"+textData);
							//RunQuery();
							$('#locDlEd').window('close');  
						})					
					}
			}] */
		})
	
}


//���������Ϣ
function UpdateInLoc()
{
	var InStr=BuildInLoc();
	//alert("InStr="+InStr)
	//var rtn=tkMakeServerCall("web.DHCINSULocInfoCtl","Save",InStr)
		$.m({
			  ClassName:"web.DHCINSULocInfoCtl",
			  MethodName:"Save",
			  InString:InStr
			  },
			  function(rtn){
			if(eval(rtn.split("^")[0])>0)
			  {
	                  $.messager.alert("��ʾ", "����ɹ�", 'info');  
	           }else{
		              $.messager.alert("��ʾ", "����ʧ��"+rtn, 'info');  
	                }
			$('#locDlEd').window('close');  
		});		
	
}
//��ȡ�����������Ϣ��
function BuildInLoc()
{
	var InStr=getValueById('Rowid')                    // getValueById('Rowid')
	InStr=InStr+"^"+getValueById('DeptCode')           // getValueById('DeptCode')
	InStr=InStr+"^"+getValueById('DeptDesc')           // getValueById('DeptDesc')
	var type=getValueById('DeptType')
	if(type=="����"){type="1"}else{type="2"}
	InStr=InStr+"^"+type           // getValueById('DeptType')
	InStr=InStr+"^"+getValueById('StandDeptCode')      // getValueById('StandDeptCode')
	//InStr=InStr+"^"+getValueById('ProfessionDeptCode') // getValueById('ProfessionDeptCode')
	var ProfessionDeptCode=getValueById('ProfessionDeptCode');
	if(ProfessionDeptCode == "")
	{
		$.messager.alert("��ܰ��ʾ","�Ʊ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+ProfessionDeptCode
	InStr=InStr+"^"+getValueById('DeptDr')         // getValueById('DeptDr')
	InStr=InStr+"^"+getValueById('SPBedNum')       // getValueById('SPBedNum')
	InStr=InStr+"^"+getValueById('SJBedNum')  // getValueById('SJBedNum')
	//InStr=InStr+"^"+getValueById('DeptSetUpDate')     // getValueById('DeptSetUpDate')
	var DeptSetUpDate=getValueById('DeptSetUpDate');
	if(DeptSetUpDate == "")
	{
		$.messager.alert("��ܰ��ʾ","���ҳ������ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+DeptSetUpDate
	InStr=InStr+"^"+getValueById('DoctorNum')      // getValueById('DoctorNum')
	InStr=InStr+"^"+getValueById('TechnicianNum')  // getValueById('TechnicianNum')
	InStr=InStr+"^"+getValueById('PharmacistNum')  // getValueById('PharmacistNum')
	InStr=InStr+"^"+getValueById('NurseNum')       // getValueById('NurseNum')
	//InStr=InStr+"^"+getValueById('DeptHead')       // getValueById('DeptHead')
	var DeptHead=getValueById('DeptHead');
	if(DeptHead == "")
	{
		$.messager.alert("��ܰ��ʾ","���Ҹ����˲���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+DeptHead
	//InStr=InStr+"^"+getValueById('DeptHeadTelNo')  // getValueById('DeptHeadTelNo')
	var DeptHeadTelNo=getValueById('DeptHeadTelNo');
	if(DeptHeadTelNo == "")
	{
		$.messager.alert("��ܰ��ʾ","�����˵绰����Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+DeptHeadTelNo
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	//InStr=InStr+"^"+""
	InStr=InStr+"^"+getValueById('HospCode')		// getValueById('HospCode')
	//InStr=InStr+"^"+getValueById('StDate')		// getValueById('StDate')
	var StDate=getValueById('StDate');
	if(StDate == "")
	{
		$.messager.alert("��ܰ��ʾ","��ʼ���ڲ���Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+StDate
	InStr=InStr+"^"+""
	InStr=InStr+"^"+getValueById('EdDate')		// getValueById('EdDate')
	InStr=InStr+"^"+""
	InStr=InStr+"^"+getValueById('ActFlag')
	InStr=InStr+"^"+getValueById('UserDr')		// getValueById('UserDr')
	InStr=InStr+"^"+getValueById('Date')		// getValueById('Date')
	InStr=InStr+"^"+getValueById('Time')		// getValueById('Time')
	InStr=InStr+"^"+getValueById('Remark')		// getValueById('Remark')
	//InStr=InStr+"^"+getValueById('itro')		// getValueById('ExtStr01')
	var itro=getValueById('itro');
	if(itro == "")
	{
		$.messager.alert("��ܰ��ʾ","��鲻��Ϊ��!", 'info');
		return ;
	}
	InStr=InStr+"^"+itro						// getValueById('ExtStr01')
	//InStr=InStr+"^"+getValueById('ExtStr02'	 // getValueById('ExtStr02')
	InStr=InStr+"^"+getValueById('medservscp')	// getValueById('ExtStr02')
	InStr=InStr+"^"+getValueById('ExtStr03')	// getValueById('ExtStr03')
	InStr=InStr+"^"+getValueById('ExtStr04')	// getValueById('ExtStr04')
	InStr=InStr+"^"+getValueById('ExtStr05')	// getValueById('ExtStr05')
	InStr=InStr+"^"+session['LOGON.HOSPID']
	return InStr
}






//����ҽ���ϴ���¼��Ϣ
function UpdateInLocRec()
{
	var InStr=BuildInLocRec();
		$.m({
			  ClassName:"web.DHCINSULocRecCtl",
			  MethodName:"Save",
			  InString:InStr
			  },
			  function(rtn){
			if(eval(rtn.split("^")[0])>0)
			  {
	                  $.messager.alert("��ʾ", "����ɹ�", 'info');  
	           }else{
		              $.messager.alert("��ʾ", "����ʧ��"+rtn, 'info');  
	                }
			$('#locRecDlEd').window('close');  
		});		
	
}
//��ȡ������ҽ���ϴ���¼��
function BuildInLocRec()
{
	var InStr=getValueById('RRowid')              // getValueById('RRowid')
	InStr=InStr+"^"+getValueById('RCTDr')          // getValueById('RCTDr')
	InStr=InStr+"^"+getValueById('RCenterNo')     // getValueById('RCenterNo')
	InStr=InStr+"^"+getValueById('RStates')        // getValueById('RStates')
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+getValueById('RInsuType')      // getValueById('RInsuType')
	InStr=InStr+"^"+getValueById('RHSPUserDr')     // getValueById('RHSPUserDr')
	InStr=InStr+"^"+getValueById('RHSPFlag')       // getValueById('RHSPFlag')
	InStr=InStr+"^"+getValueById('RHSPDate')       // getValueById('RHSPDate')
	InStr=InStr+"^"+getValueById('RHSPTime')      // getValueById('RHSPTime')
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+""
	InStr=InStr+"^"+getValueById('RUserDr')       // getValueById('RUserDr')
	InStr=InStr+"^"+getValueById('RDate')          // getValueById('RDate')
	InStr=InStr+"^"+getValueById('RTime')          // getValueById('RTime')
	InStr=InStr+"^"+$('#RExtStr01').val()
	InStr=InStr+"^"+$('#RExtStr02').val()
	InStr=InStr+"^"+$('#RExtStr03').val()
	InStr=InStr+"^"+$('#RExtStr04').val()
	InStr=InStr+"^"+$('#RExtStr05').val()
	
	return InStr
}




//��ʼ��ҽ���ϴ���¼���ɿ�
function initLocRecRbFrm()
{       
    $('#RdInsuTypeDesc').val($("#InsuType").combobox('getText'));
    $('#RdInsuType').val($("#InsuType").combobox('getValue'));
    
    $('#locRecDlBd').show(); 
		$HUI.dialog("#locRecDlBd",{
			title:"ҽ���ϴ���¼����",
			height:260,
			width:300,
			iconCls: 'icon-w-batch-add',
			modal:true
			//content:initLocFrmC(),
			/*pagination:true,toolbar:[{
					iconCls: 'icon-edit',
					text:'����',
					handler: function(){
						$.m(
							{
							ClassName:"web.INSUMsgInfo",
							MethodName:"update",
							MsgInfoDr:dgobj.getSelected().MsgInfoDr,
							InString:$('#ta').val()
							},
							function(textData){
							//console.dir(txtData);
							//if(textData!="") alert("�޸ĳɹ�,RowId:"+textData);
							//RunQuery();
							$('#locDlEd').window('close');  
						})					
					}
			}] */
		})
	
}

function FrmRbdResShw()
{
	if (""==$("#InsuType").combobox('getValue')){ 
	$.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');  return;}
	$("#RdInsuTypeDesc").val("");
	$("#RdInsuType").val("");
	initLocRecRbFrm();

	
}



///******************************************************************
///����˵��
///���ɴ��ϴ���¼
function ReBuildInLocRec()
{

	var InsuTypeDesc=$("#RdInsuTypeDesc").val();
	var InsuType=$("#RdInsuType").val();
	var ExpStr=$("#RdCenter").val()+"^"+$("#RdCenter").val()+"^^^^^"
	$.messager.confirm("����", "ȷ����������"+InsuTypeDesc+"�����ϴ���¼?", function (r) {
		if (r)
		 {
			 $.messager.progress({
				title: "��ʾ",
				msg: '����ͬ�����ϴ�����',
				text: 'ͬ����....',
			    iconCls:'icon-reset'
			});
			$.m({
			  ClassName:"web.DHCINSULocRecCtl",
			  MethodName:"BuildINLocRecInfo",
			  InRowid:"",
			  InsuType:InsuType,
			  UserDr:GUser,
			  HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
			  ExpStr:ExpStr
			  
			  },
			  function(rtn){
	         $.messager.alert("���ɼ�¼��ʾ", rtn.split("!")[1], 'info');  
	         setTimeout('$.messager.progress("close");', 2 * 1000);
	         //QryInLoc();
		});	
		 //setTimeout('$.messager.progress("close");', 2 * 1000);
	 } 
		
});
	
}
///******************************************************************

///******************************************************************
///����˵����
//������Ϣ����ӿڵ��� 
//�����ϴ�3401
function InLocUL(){
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');  return;}
	var ExpStr=InsuType+"^^^3401^"+InLocRecRowid
	//alert(InLocRecRowid)
	if (InLocRecRowid==""){
		//$.messager.alert("��ʾ", "�����ϴ�,���ν��ϴ����еĴ��ϴ����Ҽ�¼", 'info'); 	
		}else{
			if(UpFlag=="���ϴ�" || UpFlag=="�ѱ��") {$.messager.alert("��ʾ", "���ұ���ϴ�,�ü�¼�����ظ��ϴ�", 'info');return ;}
			//$.messager.alert("��ʾ", "�����ϴ�,���ν�ֻ�ϴ������ϴ���¼��RowidΪ��" +InLocRecRowid+"������", 'info'); 
			}
	var RtnFLag=InsuDicCTLocUL(0,GUser,ExpStr); //DHCINSUPort.js
	if(RtnFLag.split("^")[0]<0){
		 $.messager.alert("��ʾ", "�����ϴ�ʧ��", 'info');  
		}else{
		$.messager.alert("��ʾ", "�����ϴ��ɹ�", 'info');  
	}
}
//���ұ��3402
function InLocULMod()
{
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');  return;}
	var Rowid=InLocRecRowid;
	if(Rowid==""){$.messager.alert("��ʾ", "���ұ��ʧ��,��ѡ��һ���ϴ���¼", 'info');  return;}
	ExpStr=InsuType+"^^^3402^"
	if(UpFlag!="���ϴ�" && UpFlag!="�ѱ��") {$.messager.alert("��ʾ", "���ұ��ʧ��,�ü�¼��δ�ϴ�����,�޷����", 'info');return ;}
	var RtnFLag=InsuDicCTLocULMod(0,GUser,Rowid,ExpStr); //DHCINSUPort.js
	if(RtnFLag.split("^")[0]<0){
		 $.messager.alert("��ʾ", "���ұ��ʧ��", 'info');  
		}else{
		$.messager.alert("��ʾ", "���ұ���ɹ�", 'info');  
	}
}
//���������ϴ�3401A
function InLocPLUL()
{
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');  return;}
	var ExpStr=InsuType+"^^^3401A^"+""
	var RtnFLag=InsuDicCTLocUL(0,GUser,ExpStr); //DHCINSUPort.js
	if(RtnFLag.split("^")[0]<0){
		 $.messager.alert("��ʾ", "���������ϴ�ʧ��", 'info');  
		}else{
		$.messager.alert("��ʾ", "���������ϴ��ɹ�", 'info');  
	}
}
//���ҳ���3403
function InLocULCancel()
{
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');  return;}
	var Rowid=InLocRecRowid;
	if(Rowid==""){$.messager.alert("��ʾ", "���ҳ���ʧ��,��ѡ��һ���ϴ���¼", 'info');  return;}
	ExpStr=InsuType+"^^^3403^"
	if(UpFlag!="���ϴ�" && UpFlag!="�ѱ��") {$.messager.alert("��ʾ", "���ҳ���ʧ��,�ü�¼��δ�ϴ�����,�޷�����", 'info');return ;}
	var RtnFLag=InsuDicCTLocULCancel(0,GUser,Rowid,ExpStr); //DHCINSUPort.js
	if(RtnFLag.split("^")[0]<0){
		 $.messager.alert("��ʾ", "���ҳ���ʧ��", 'info');  
		}else{
		$.messager.alert("��ʾ", "���ҳ����ɹ�", 'info');  
	}
}
///******************************************************************
///******************************************************************
///����˵����
//ͬ��������Ϣ 
///******************************************************************
function ReBuildInLoc()
{	
var InsuType=$("#InsuType").combobox('getValue');
$.messager.confirm("����", "ȷ������ͬ��������Ϣ?", function (r) {
		if (r)
		 {
			$.messager.progress({
				title: "��ʾ",
				msg: '����ͬ����������',
				text: 'ͬ����....',
			    iconCls:'icon-reset'
			});
			$.m({
			  ClassName:"web.DHCINSULocInfoCtl",
			  MethodName:"SynBuildINLocInfo",
			  InRowid:"",
			  LocCode:"",
			  LocDesc:"",
			  UserDr:GUser,
			  HospDr:PUBLIC_CONSTANT.SESSION.HOSPID,
			  ExpStr:"^^^^^",
			  InsuType:InsuType
			  },
			  function(rtn){
			
	         $.messager.alert("��ʾ", rtn.split("!")[1], 'info');  
	         setTimeout('$.messager.progress("close");', 2 * 1000);
	         QryInLoc();
		});	
		
		
	 } 
		
});

			
	
}

/*
//�����ϴ�
function InLocUL(){
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');  return;}
	var ExpStr=InsuType+"^^"+InLocRowid

	var RtnFLag=InsuDicCTLocUL(0,GUser,ExpStr); //DHCINSUPort.js
	}
*/
//��������
function InLocDL(){
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');  return;}
	var ExpStr=InsuType+"^^"+InLocRowid
	var RtnFLag=InsuDicCTLocDL(0,GUser,ExpStr); //DHCINSUPort.js
	}

//���ҵ���
function InLocImpt()
{

			
			importDiag();
			
			
			
}


///******************************************************************
///����˵����
///          ���ݵ���
///******************************************************************
function importDiag()
{
	try{
		
	   //var fd = new ActiveXObject("MSComDlg.CommonDialog");
      // fd.Filter = "*.xls"; //�����ļ����
      //fd.FilterIndex = 2;
      //fd.MaxFileSize = 128;
	 //fd.ShowSave();//�������Ҫ�򿪵Ļ�����Ҫ��fd.ShowOpen();
    //fd.ShowOpen();
    //filePath=fd.filename;//fd.filename���û���ѡ��·��
   var filePath="";
	filePath=FileOpenWindow();
	
	$.messager.progress({
				title: "��ʾ",
				msg: '���ڵ����������',
				text: '������....'
			}
			);
			
			
			
   if(filePath=="")
    {
	   $.messager.alert('��ʾ','��ѡ���ļ���','info')
	    return ;
     }
   
   
    
    var ErrMsg="";     //��������
    var errRowNums=0;  //��������
    var sucRowNums=0;  //����ɹ�������
    
	xlApp = new ActiveXObject("Excel.Application"); 
	xlBook = xlApp.Workbooks.open(filePath); 
	xlBook.worksheets(1).select(); 
    var xlsheet = xlBook.ActiveSheet;
    
    var rows=xlsheet.usedrange.rows.count;
    var columns=xlsheet.usedRange.columns.count;

	try{

		for(i=2;i<=rows;i++){
			var pym="";
			var UpdateStr=buildImportStr(xlsheet,i);
			var savecode=tkMakeServerCall("web.DHCINSULocInfoCtl","Save",UpdateStr)
			if(savecode==null || savecode==undefined) savecode=-1
			if(eval(savecode)>=0){
				sucRowNums=sucRowNums+1;
				
		
			}else{
				errRowNums=errRowNums+1; 
				if(ErrMsg==""){
					ErrMsg=i;
				}else{
					ErrMsg=ErrMsg+"\t"+i;
				}
			}
		}
		
		if(ErrMsg==""){
			setTimeout('$.messager.progress("close");', 1 * 1000);
			$.messager.alert('��ʾ','������ȷ�������','info');
		}else{
			setTimeout('$.messager.progress("close");', 1 * 1000);
			var tmpErrMsg="�ɹ����롾"+sucRowNums+"/"+(rows-1)+"��������";
			tmpErrMsg=tmpErrMsg+"ʧ�������к����£�\n\n"+ErrMsg;
			$.messager.alert('������ʾ',tmpErrMsg,'error');   
		}
	}
	catch(e){
		$.messager.alert('������ʾ',"����ʱ�����쳣0��ErrInfo��"+e.message,'info');  
	}
	finally{
		xlBook.Close (savechanges=false);
		xlApp.Quit();
		xlApp=null;
		xlsheet=null;
	}
	
 }
catch(e){
	$.messager.alert('��ʾ',"����ʱ�����쳣1��"+e.message);
	
}
finally{
	setTimeout('$.messager.progress("close");', 1 * 1000);
}    
   
}
function buildImportStr(xlsheet,rowindex){
	var tmpVal="";
	
	//Rowid^���Ҵ���^��������^��������^��׼���Ҵ���^רҵ���Ҵ���^����Dr^������λ��^ʵ�ʴ�λ��^���ҳ���ʱ��^ҽʦ����^��ʦ����^ҩʦ����^��ʦ����^���Ҹ�����^���Ҹ����˵绰^������ʿ��^������ʿ���绰^�Ƿ��ص����^�ص���ҵȼ�^�����Ƿ�������^ҽԺ��������^��ʼ����^��ʼʱ��^��������^����ʱ��^��Ч��ʶ^������Dr^��������^����ʱ��^��ע^��չ01^��չ02^��չ03^��չ04^��չ05
	
	//1-5 Rowid^���Ҵ���^��������^��������^��׼���Ҵ���^
	var updateStr="";
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,1).value);                     //����
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,2).value);       
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,3).value);       
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,4).value);       
	//6-10 רҵ���Ҵ���^����Dr^������λ��^ʵ�ʴ�λ��^���ҳ���ʱ��^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,5).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,6).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,7).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,8).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,9).value);		//

	//11-15 ҽʦ����^��ʦ����^ҩʦ����^��ʦ����^���Ҹ�����^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,10).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,11).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,12).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,13).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,14).value);		//

	//16-20 ���Ҹ����˵绰^������ʿ��^������ʿ���绰^�Ƿ��ص����^�ص���ҵȼ�^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,15).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,16).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,17).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,18).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,19).value);		//

	//21-25 �����Ƿ�������^ҽԺ��������^��ʼ����^��ʼʱ��^��������^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,20).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,21).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,22).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,23).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,24).value);		//

	//26-30 ����ʱ��^��Ч��ʶ^������Dr^��������^����ʱ��^
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,25).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,26).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,27).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,28).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,29).value);		//

	//31-36 ��ע^��չ01^��չ02^��չ03^��չ04^��չ05
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,30).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,31).value);       //
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,32).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,33).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,34).value);		//
	updateStr=updateStr+"^"+SetValue(xlsheet.Cells(rowindex,35).value);		//
	
	return updateStr;
}
function SetValue(value)
{
	if(value == undefined)
	{
		value="" ;
	}
	
	value=value.toString().replace(/\"/g, "");
	value=value.toString().replace(/\?/g,"");
	return value;
}

//���ҵ���
function InLocEpot()
{
	try
	{
	var rtn = $cm({
	dataType:'text',
	ResultSetType:"Excel",
	ExcelName:"������Ϣά��", //Ĭ��DHCCExcel
	ClassName:"web.DHCINSULocInfoCtl",
	QueryName:"QryInLocInfo",
	InRowid:"",
	KeyWords:$('#KeyWords').val(),
	HospDr:PUBLIC_CONSTANT.SESSION.HOSPID
     },false);
     location.href = rtn;
	$.messager.progress({
				title: "��ʾ",
				msg: '���ڵ�����������',
				text: '������....'
			});
	setTimeout('$.messager.progress("close");', 3 * 1000);	
		
		return;
	} catch(e) {
		$.messager.alert("����",e.message);
		$.messager.progress('close');
	};
	
	
	}






function FileOpenWindow(){
	if($('#FileWindowDiv').length==0){
		$('#FileWindowDiv').empty();
		
		$FileWindowDiv=$("<a id='FileWindowDiv' class='FileWindow' style='display:none'>&nbsp;</a>");
		$("body").append($FileWindowDiv);
		$FileWindow=$("<input id='FileWindow' type='file' name='upload'/>");
		$("#FileWindowDiv").append($FileWindow);
	}
	$('#FileWindow').val("");
	$('#FileWindow').select();
	$(".FileWindow input").click();
	var FilePath=$('#FileWindow').val();
	//alert(FilePath);
	return FilePath;
}

$(".FileWindow").on("change","input[type='file']",function(){
	//alert(3233);
	var filePath=$(this).val();
	//alert("filePath="+filePath);
});
function selectHospCombHandle(){
	$('#InsuType').combobox('reload');
	//QryInLoc();
	//QryInLocRec();
}
