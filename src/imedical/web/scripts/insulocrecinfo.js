/**
 * ҽ��������ϢJS
 * FileName: insulocrecinfo.js
 * DingSH 2018-10-18
 * �汾��V1.0
 * hisui�汾:0.1.0
 */
 var InLocRowid="";
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
  
});

//��ʼ��Btn�¼�
function InitBtnClick(){
	
	
	//�ؼ��ֻس��¼�
	$("#KeyWords").keydown(function(e) { 
	KeyWords_onkeydown(e);
	});  
	
	
	 $("#btnS").click(function () {
	        UpdateInLoc();
            QryInLoc();
			
        });
        
   $("#btnC").click(function () {
            //QryInLoc();
			$('#locDlEd').window('close');  
       });       
        
        
  $("#btnS1").click(function () {
            //QryInLoc();
            UpdateInLocRec();
            QryInLocRec();
        });
        
   $("#btnC1").click(function () {
            //QrylocRecDlEd();
			$('#locRecDlEd').window('close');  
       });  
       
    $("#btnRbd").click(function () {
            ReBuildInLocRec();
        });
        
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
    $('#locdg').datagrid('options').url = $URL
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
	    	
	    }
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
	 	//{field:'Security',title:'����ͨ��',formatter:function(value,row,index){
			//	return "<span onclick='GV.showMenuSecurityWin("+row.ID+",\""+row.Name+"\",\""+row.Caption+"\")' class='icon-security'>&nbsp;</span>";
			//}}
	 //��ʼ��datagrid
	$HUI.datagrid("#locdg",{
		url:$URL,
		//fit: true,
		border: false,
		//idField:'dgid',
		//iconCls: 'icon-save',
		//rownumbers:true,
		width: '100%',
		striped:true,
		//fitColumns:true,
		singleSelect: true,
		//autoRowHeight:false,
		
		data: [],
		frozenColumns:[[
		  { 
		    field:'TOpt',
		    width:40,
		    title:'����',
		    formatter: function (value, row, index) {
						
							return "<img class='myTooltip' style='width:60' title='������Ϣ�޸�' onclick=\"locEditClick('" + index+"')\" src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_pen.png' style='border:0px;cursor:pointer'>";
						
					}
		  }
		
		]],
		columns:[[
		
		  
			{field:'TInd',title:'TInd',width:10,hidden:true},
			{field:'TRowid',title:'TRowid',width:10,hidden:true},
			{field:'TDeptCode',title:'ҽԺ���ұ���',width:140},
			{field:'TDeptDesc',title:'ҽԺ��������',width:180},
			{field:'TDeptType',title:'��������',width:150},
			{field:'TStandDeptCode',title:'��׼���ұ���',width:140},
			{field:'TProfessionDeptCode',title:'רҵ���Ҵ��� ',width:150,hidden:true},
			{field:'TDeptDr',title:'����Dr',width:50,align:'center',hidden:true},
			{field:'TSPBedNum',title:'��׼��λ����',width:50,hidden:true},
			{field:'TSJBedNum',title:'ʵ�ʿ��Ŵ�λ����',width:50,hidden:true},
			{field:'TDeptSetUpDate',title:'���ҳ���ʱ��',width:50,hidden:true},
			{field:'TDoctorNum',title:'ҽʦ����',width:50,hidden:true},
			{field:'TTechnicianNum',title:'��ʦ����',width:50,hidden:true},
			{field:'TPharmacistNum',title:'ҩʦ����',width:50,hidden:true},
			{field:'TNurseNum',title:'������Ա����',width:50,hidden:true},
			{field:'TDeptHead',title:'���Ҹ�����',width:120},
			{field:'TDeptHeadTelNo',title:'�����˵绰',width:120},
			{field:'TNurseHead',title:'��ʿ��',width:100},
			{field:'TNurseHeadTelNo',title:'��ʿ���绰',width:220},
			{field:'TIsKeyDept',title:'�Ƿ��ص����',width:140},
			{field:'TKeyDeptLevel',title:'�ص���ҵȼ�',width:150,hidden:true},
			{field:'TIsAllowFee',title:'�ÿ����Ƿ�������',width:150,hidden:true},
			{field:'THospCode',title:'ҽԺ��������',width:50,hidden:true},
			{field:'TStDate',title:'��ʼ����',width:50,hidden:true},
			{field:'TStTime',title:'��ʼʱ��',width:50,hidden:true},
			{field:'TEdDate',title:'��������',width:50,hidden:true},
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
		pagination:true,
        onClickRow : function(rowIndex, rowData) {
	        
			//alert("rowData="+rowData.TRowid)   
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
			var index=0;
			if (data.total>0)
			{
			 if (LocRowIndex>=0){
			   index=LocRowIndex
			 }
			  $('#locdg').datagrid('selectRow',index);
			}
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
		width: '100%',
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
			{field:'THSPFlag',title:'ҽԺ����״̬',width:140},
			{field:'THSPDate',title:'ҽԺ��������',width:140},
			{field:'THSPTime',title:'ҽԺ����ʱ��',width:140},
			{field:'TISPUserDr',title:'ҽ��������',width:140,hidden:true},
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
	$('#DeptCode').val(rowData.TDeptCode)
	$('#DeptDesc').val(rowData.TDeptDesc)
	$('#DeptType').val(rowData.TDeptType)
	$('#StandDeptCode').val(rowData.TStandDeptCode)
	$('#ProfessionDeptCode').val(rowData.TProfessionDeptCode)
	$('#DeptDr').val(rowData.TDeptDr)
	$('#SPBedNum').val(rowData.TSPBedNum)
	$('#SJBedNum').val(rowData.TSJBedNum)
	$('#DeptSetUpDate').val(rowData.TDeptSetUpDate)
	$('#DoctorNum').val(rowData.TDoctorNum)
	$('#TechnicianNum').val(rowData.TTechnicianNum)
	$('#PharmacistNum').val(rowData.TPharmacistNum)
	$('#NurseNum').val(rowData.NurseNum)
	$('#DeptHead').val(rowData.TDeptHead)
	$('#DeptHeadTelNo').val(rowData.TDeptHeadTelNo)
	$('#NurseHead').val(rowData.TNurseHead)
	$('#NurseHeadTelNo').val(rowData.TNurseHeadTelNo)
	$('#IsKeyDept').val(rowData.TIsKeyDept)
	$('#KeyDeptLevel').val(rowData.TKeyDeptLevel)
	$('#IsAllowFee').val(rowData.TIsAllowFee)
	$('#HospCode').val(rowData.THosp)
	$('#StDate').val(rowData.TStDate)
	$('#StTime').val(rowData.TStTime)
	$('#EdDate').val(rowData.TEdDate)
	$('#EdTime').val(rowData.TEdTime)
	$('#ActFlag').val(rowData.TActFlag)
	$('#UserDr').val(rowData.TUserDr)
	$('#UserName').val(rowData.TUserName)
	$('#Date').val(rowData.TDate)
	$('#Time').val(rowData.TTime)
	$('#Remark').val(rowData.TRemark)
	$('#ExtStr01').val(rowData.TExtStr01)
	$('#ExtStr02').val(rowData.TExtStr02)
	$('#ExtStr03').val(rowData.TExtStr03)
	$('#ExtStr04').val(rowData.TExtStr04)
	$('#ExtStr05').val(rowData.TExtStr05)
	$('#Rowid').val(rowData.TRowid)

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
			height:550,
			width:870,
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
	$('#RCTDr').val(rowData.TCTDr);
	$('#RCenterNo').val(rowData.TCenterNo);
	$('#RStates').val(rowData.TStates);
	$('#RSeriNo').val(rowData.TSeriNo);
	$('#RBusiNo').val(rowData.TBusiNo);
	$('#RInsuType').val(rowData.TInsuType);
	$('#RInsuTypeDesc').val(rowData.TInsuTypeDesc);
	$('#RHSPUserName').val(rowData.THSPUserName);
	$('#RHSPUserDr').val(rowData.THSPUserDr);
	$('#RHSPFlag').val(rowData.THSPFlag);
	$('#RHSPDate').val(rowData.THSPDate);
	$('#RHSPTime').val(rowData.THSPTime);
	$('#RISPUserDr').val(rowData.TISPUserDr);
	$('#RISPFlag').val(rowData.TISPFlag);
	$('#RISPDate').val(rowData.TISPDate);
	$('#RISPTime').val(rowData.TISPTime);
	$('#RUserDr').val(rowData.TUserDr);
	$('#RUserName').val(rowData.TUserName);
	$('#RDate').val(rowData.TDate);
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
			height:465,
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
	var InStr=$('#Rowid').val()
	InStr=InStr+"^"+$('#DeptCode').val()
	InStr=InStr+"^"+$('#DeptDesc').val()
	InStr=InStr+"^"+$('#DeptType').val()
	InStr=InStr+"^"+$('#StandDeptCode').val()
	InStr=InStr+"^"+$('#ProfessionDeptCode').val()
	InStr=InStr+"^"+$('#DeptDr').val()
	InStr=InStr+"^"+$('#SPBedNum').val()
	InStr=InStr+"^"+$('#SJBedNum').val()
	InStr=InStr+"^"+$('#DeptSetUpDate').val()
	InStr=InStr+"^"+$('#DoctorNum').val()
	InStr=InStr+"^"+$('#TechnicianNum').val()
	InStr=InStr+"^"+$('#PharmacistNum').val()
	InStr=InStr+"^"+$('#NurseNum').val()
	InStr=InStr+"^"+$('#DeptHead').val()
	InStr=InStr+"^"+$('#DeptHeadTelNo').val()
	InStr=InStr+"^"+$('#NurseHead').val()
	InStr=InStr+"^"+$('#NurseHeadTelNo').val()
	InStr=InStr+"^"+$('#IsKeyDept').val()
	InStr=InStr+"^"+$('#KeyDeptLevel').val()
	InStr=InStr+"^"+$('#IsAllowFee').val()
	InStr=InStr+"^"+$('#HospCode').val()
	InStr=InStr+"^"+$('#StDate').val()
	InStr=InStr+"^"+$('#StTime').val()
	InStr=InStr+"^"+$('#EdDate').val()
	InStr=InStr+"^"+$('#EdTime').val()
	InStr=InStr+"^"+$('#ActFlag').val()
	InStr=InStr+"^"+$('#UserDr').val()
	InStr=InStr+"^"+$('#Date').val()
	InStr=InStr+"^"+$('#Time').val()
	InStr=InStr+"^"+$('#Remark').val()
	InStr=InStr+"^"+$('#ExtStr01').val()
	InStr=InStr+"^"+$('#ExtStr02').val()
	InStr=InStr+"^"+$('#ExtStr03').val()
	InStr=InStr+"^"+$('#ExtStr04').val()
	InStr=InStr+"^"+$('#ExtStr05').val()
	
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
	var InStr=$('#RRowid').val()
	InStr=InStr+"^"+$('#RCTDr').val()
	InStr=InStr+"^"+$('#RCenterNo').val()
	InStr=InStr+"^"+$('#RStates').val()
	InStr=InStr+"^"+$('#RSeriNo').val()
	InStr=InStr+"^"+$('#RBusiNo').val()
	InStr=InStr+"^"+$('#RInsuType').val()
	InStr=InStr+"^"+$('#RHSPUserDr').val()
	InStr=InStr+"^"+$('#RHSPFlag').val()
	InStr=InStr+"^"+$('#RHSPDate').val()
	InStr=InStr+"^"+$('#RHSPTime').val()
	InStr=InStr+"^"+$('#RISPUserDr').val()
	InStr=InStr+"^"+$('#RISPFlag').val()
	InStr=InStr+"^"+$('#RISPDate').val()
	InStr=InStr+"^"+$('#RISPTime').val()
	InStr=InStr+"^"+$('#RUserDr').val()
	InStr=InStr+"^"+$('#RDate').val()
	InStr=InStr+"^"+$('#RTime').val()
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
			height:255,
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



function ReBuildInLocRec()
{

	var InsuTypeDesc=$("#RdInsuTypeDesc").val();
	var InsuType=$("#RdInsuType").val();
	var ExpStr=$("#RdCenter").val()+"^"+$("#RdStates").val()+"^^^^^"
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
	         $.messager.alert("���ɼ�¼��ʾ", rtn, 'info');  
	         setTimeout('$.messager.progress("close");', 2 * 1000);
	         //QryInLoc();
		});	
		 //setTimeout('$.messager.progress("close");', 2 * 1000);
	 } 
		
});
	
}

//�������ɿ�����Ϣ 
function ReBuildInLoc()
{
	
$.messager.confirm("����", "ȷ���������ɿ�����Ϣ?", function (r) {
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
			  ExpStr:"^^^^^"
			  
			  },
			  function(rtn){
			
	         $.messager.alert("��ʾ", rtn, 'info');  
	         setTimeout('$.messager.progress("close");', 2 * 1000);
	         QryInLoc();
		});	
		
		
	 } 
		
});

			
	
}


//�����ϴ�
function InLocUL(){
	var InsuType=$("#InsuType").combobox('getValue');
	if (""==InsuType){ 
	$.messager.alert("��ʾ", "��ѡ��ҽ������", 'info');  return;}
	var ExpStr=InsuType+"^^"+InLocRowid

	var RtnFLag=InsuDicCTLocUL(0,GUser,ExpStr); //DHCINSUPort.js
	}

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
	QryInLoc();
	QryInLocRec();
}