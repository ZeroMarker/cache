//ҳ��Event
function InitHISUIWinEvent(obj){
	
	//�¼���
	obj.LoadEvents = function(arguments){
		
		// ����·����Ϣ
		obj.LoadPathInfo();
		
		//׼����ʾ��Ϣ-���Ӱ�ť
		$("#addIconMrg").on('click',function(){
			// ����б༭�У�ֱ���˳�
			if (obj.gridPathAdmitEditIndex>-1){
				$.messager.alert("��ʾ","���ȱ��浱ǰ�༭�У�");
				return;
			}
			$("#gridPathAdmit").datagrid("appendRow", {
				ID:"",
				BTPathDr: $("#pathMastID").val(),
				BTTypeDr: "",
				BTTypeDrDesc: "",
				BTICD10: "",
				BTICDKeys: "",
				BTOperICD:"",
				BTOperKeys:"",
				BTIsICDAcc:"��",
				BTIsOperAcc:"��",
				BTIsActive:"��"
			});
			var rowIndex=$("#gridPathAdmit").datagrid("getRows").length - 1;
			$('#gridPathAdmit').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		});
		
		//׼����ʾ��Ϣ-ȡ����ť
		$("#cancelIconMrg").on('click',function(){
			if (obj.gridPathAdmitEditIndex>-1){
				$('#gridPathAdmit').datagrid("cancelEdit", obj.gridPathAdmitEditIndex);  //�����б༭
				obj.gridPathAdmit.load({
					ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
					QueryName:"QryPathAdmit",
					aBTPathDr:obj.FormPathID 
				}); 
			} else {
				$.messager.alert("��ʾ","�ޱ༭�У�");
				obj.gridPathAdmit.load({
					ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
					QueryName:"QryPathAdmit",
					aBTPathDr:obj.FormPathID 
				}); 
			}
		});
		
		//׼����ʾ��Ϣ-���水ť
		$("#editIconMrg").on('click',function(){
			debugger
			if (obj.gridPathAdmitEditIndex>-1){
				var rowIndex = obj.gridPathAdmitEditIndex;
				$('#gridPathAdmit').datagrid("endEdit", obj.gridPathAdmitEditIndex);  //�����б༭
				var rowData  = $('#gridPathAdmit').datagrid('getRows')[rowIndex];  //��ȡ�༭������
				var rowID    = obj.savegridPathAdmitRow(rowData);  //����༭������
				$('#gridPathAdmit').datagrid('reload');  //���¼���Grid����
			} else {
				$.messager.alert("��ʾ","�ޱ༭�У�");
			}
		});
		
		//׼����ʾ��Ϣ-ɾ����ť
		$("#delIconMrg").on('click',function(){
			obj.deletegridPathAdmitRow();
		});
		
		// ����·����Ϣ
		$("#btnSaveInfo").on('click',function(){
			obj.SavePathInfo();	
		});
		
		//�ų��������
		$('#MdiagSearch').searchbox({
		    searcher:function(value){
			    obj.type="";
			    obj.LoadMDiagDic();
		    },
		});
		
		//�ų���������
		$('#OperSearch').searchbox({
		    searcher:function(value){
			    obj.type="";
			    obj.LoadOperDic();
		    },
		});
		//�ų������ά����ѯ
	     $('#btnMDFin').on('click', function(){
		     Common_SetValue('MdiagSearch',"");
		     obj.type="Y";
			 obj.LoadMDiagDic();
	     });
	     
	     //�ų�������ά����ѯ
	     $('#btnOpFin').on('click', function(){
		     Common_SetValue('OperSearch',"");
		     obj.type="Y";
			 obj.LoadOperDic("");
	     });
			
	};	
	
	
	// ����·����Ϣ
	obj.LoadPathInfo = function(){
		//·����Ϣ
		var jsonPath = $cm({ClassName:"DHCMA.CPW.BT.PathMast",MethodName:"GetObjById",aId:obj.FormPathID},false);
		
		$("#txtPathCode").val(jsonPath.BTCode);
		$("#txtPathDesc").val(jsonPath.BTDesc);
		$('#cboTypeDr').combobox('setValue',jsonPath.BTTypeDr);
		$('#cboEntityDr').combobox('setValue',jsonPath.BTEntityDr);
		$('#cboPCEntityDr').combobox('setValue',jsonPath.BTPCEntityDr);
		$('#cboQCEntityDr').combobox('setValue',jsonPath.BTQCEntityDr);
		if(jsonPath.BTIsActive=="1"){
			$("#txtIsActive").switchbox('setValue',true);
		}else{
			$("#txtIsActive").switchbox('setValue',false);
		}
		
		$("#txtFormCost").val(obj.jsonForm.FormCost);
		$("#txtFormDays").val(obj.jsonForm.FormDays);
		
		//��˽�ɫֻ���ƶ�Ȩ�ޣ�����Ŀʵʩ���о���Ҫ����޸Ĵ˴�����ı�Ȩ�ޣ�
		if (1) {
			//·����Ϣ
			$("input").attr("disabled", "disabled");
			$("#cboTypeDr,#cboEntityDr,#cboPCEntityDr,#cboQCEntityDr").combobox('disable');
			$("#txtIsActive").switchbox('setActive',false);
			$("#btnSaveInfo").linkbutton("disable");
			
			//׼�����
			$("#addIconMrg,#cancelIconMrg,#editIconMrg,#delIconMrg").linkbutton("disable");
			
			//�ų�����
			$("#MdiagSearch,#OperSearch").searchbox("disable");
			$('#gridSlectMDiagOrds').datagrid('hideColumn', 'checked'); 
			$('#gridSlectOperOrds').datagrid('hideColumn', 'checked'); 
			
		}
	};
	
	//׼����ʾ��Ϣ--����༭��
	obj.savegridPathAdmitRow=function(rowData){
		var ID          = rowData["ID"];
		var BTPathDr    = rowData["BTPathDr"];
		if (BTPathDr=="") BTPathDr=obj.FormPathID;
		var BTTypeDr    = rowData["BTTypeDr"];
		var BTICD10     = rowData["BTICD10"];
		var BTICDKeys   = rowData["BTICDKeys"];
		var BTOperICD   = rowData["BTOperICD"];
		var BTOperKeys  = rowData["BTOperKeys"];
		var BTIsICDAcc  = rowData["BTIsICDAcc"];
		var BTIsOperAcc = rowData["BTIsOperAcc"];
		var BTIsActive  = rowData["BTIsActive"];
		
		BTIsICDAcc = (BTIsICDAcc =="��"?"1":"0");
		BTIsOperAcc = (BTIsOperAcc =="��"?"1":"0");
		BTIsActive = (BTIsActive =="��"?"1":"0");
		if(BTTypeDr==""){
			$.messager.alert("��ʾ","���Ͳ�����Ϊ�գ�");
			return "";
		}
		
		var InputStr = ID;
		InputStr += "^" + BTPathDr;
		InputStr += "^" + BTTypeDr;
		InputStr += "^" + BTICD10;
		InputStr += "^" + BTICDKeys;
		InputStr += "^" + BTOperICD;
		InputStr += "^" + BTOperKeys;
		InputStr += "^" + BTIsICDAcc;
		InputStr += "^" + BTIsOperAcc;
		InputStr += "^" + BTIsActive;
		InputStr += "^";
		InputStr += "^";
		InputStr += "^" + session['DHCMA.USERID'];
		//ͬ������
		var ret = $.cm({ClassName:"DHCMA.CPW.BT.PathAdmit",MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^"
			},false);
		if(parseInt(ret)<0){
			$.messager.popover({msg:"����ʧ��",type:'error',style:{top:250,left:600}});
			return "";
		}else{
			$.messager.popover({msg:"����ɹ�",type:'success',style:{top:250,left:600}});			
		}
		return ret; //����ɹ�����rowID������ʧ�ܷ��ؿ�
	};
	
	//׼����ʾ��Ϣ--ɾ��ѡ����
	obj.deletegridPathAdmitRow= function(){
		if (obj.gridPathAdmitRecRowID!=""){
			$.messager.confirm("ȷ��","ȷ��ɾ��?",function(r){
				if(r){					
					$.cm({ClassName:'DHCMA.CPW.BT.PathAdmit',MethodName:'DeleteById','aId':obj.gridPathAdmitRecRowID},function(data){
						//debugger;
						if(parseInt(data)<0){
							$.messager.alert("��ʾ","ʧ�ܣ�");  //data.msg
						}else{							
							//���¼���datagrid������  
							obj.gridPathAdmit.load({
								ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
								QueryName:"QryPathAdmit",
								aBTPathDr:obj.FormPathID 
							}); 
						}
					});
				}
			});
		}else{
			$.messager.alert("��ʾ","����ѡ���У���ִ��ɾ��������")
		}
	};
	
	// ����·����Ϣ�¼�
	obj.SavePathInfo = function(){
		var Code = $('#txtPathCode').val();
		var Desc = $('#txtPathDesc').val();
		var BTTypeDr   =$('#cboTypeDr').combobox('getValue');
		var BTEntityDr = $('#cboEntityDr').combobox('getValue');
		var BTPCEntityDr = $('#cboPCEntityDr').combobox('getValue');
		var BTQCEntityDr = $('#cboQCEntityDr').combobox('getValue');
		var IsActive = $("#txtIsActive").switchbox('getValue')?1:0;
		var BTActDate ='';
		var BTActTime='';
		var BTActUserID="";
		if(session['DHCMA.USERID']) BTActUserID=session['DHCMA.USERID'];
		
		//var BTAdmType=$('#cboAdmType').combobox('getValue');
		//var BTIsOper = $("#txtIsOper").switchbox('getValue')?1:0;
		
		var errinfo = "";
		if (!Code) {
			errinfo = errinfo + "����Ϊ��!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "����Ϊ��!<br>";
		}	
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.PathMast",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.FormPathID
		},false);
		if(IsCheck>=1) {
			errinfo = errinfo + "�������б���������Ŀ�ظ��������޸�!<br>";
		}
		if (errinfo) {
			$.messager.alert("������ʾ", errinfo, 'info');
			return;
		}
			
		var inputStr = obj.FormPathID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + BTTypeDr;
		inputStr = inputStr + CHR_1 + BTEntityDr;
		inputStr = inputStr + CHR_1 + BTPCEntityDr;
		inputStr = inputStr + CHR_1 + BTQCEntityDr;
		inputStr = inputStr + CHR_1 + IsActive;
		inputStr = inputStr + CHR_1 + BTActDate;
		inputStr = inputStr + CHR_1 + BTActTime;
		inputStr = inputStr + CHR_1 + BTActUserID;
		inputStr = inputStr + CHR_1 + "I";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
		inputStr = inputStr + CHR_1 + "";
			
		var flg = $m({
			ClassName:"DHCMA.CPW.BT.PathMast",
			MethodName:"Update",
			aInputStr:inputStr,
			aSeparete:CHR_1
			},false);
			if (parseInt(flg) <= 0) {
				if (parseInt(flg) == 0) {
					$.messager.alert("������ʾ", "��������!" , 'info');
				}else if (parseInt(flg) == -2) {
					$.messager.alert("������ʾ", "�����ظ�!" , 'info');
				} else {
					$.messager.alert("������ʾ", "�������ݴ���!Error=" + flg, 'info');
				}
			}else {
				$.messager.popover({msg: '����ɹ���',type:'success',timeout: 1000});
				return;
			}	
	}
	
	//����ѡ�е����
	obj.btnMDiagMatch_click = function() {
		var chkRows=obj.gridSlectMDiagOrds.getChecked();
		var orderIDStr="",ICDStr=""
		for (var i=0;i<chkRows.length;i++) {
				var tmprow=chkRows[i]
				if (obj.gridPathAdmitRecRowID!=tmprow.AdmitID){
					continue
				}
				var orderID=tmprow.BTID
				var ICD=tmprow.ICD
				orderIDStr+=orderID+","
				ICDStr+=ICD+","
		}
		var inputStr = ""
		inputStr = obj.gridPathAdmitRecRowID;
		inputStr = inputStr + "^"+ "";
		inputStr = inputStr + "^"+ orderIDStr;
		inputStr = inputStr + "^"+ ICDStr;
		inputStr = inputStr + "^"+ "M";
		$m({
			ClassName:'DHCMA.CPW.BT.PathAdmitOrds',
			MethodName:'Update',
			aInputStr:inputStr	
		},function(flg){
			if (parseInt(flg)<1) {
				$.messager.alert("������ʾ", "���ݼ��ش���!", 'info');	
			}
			else{
				$.messager.popover({msg: '�޸�ICD��ϳɹ���',type:'success',timeout: 1000});
				obj.LoadMDiagDic() ;//ˢ�µ�ǰҳ
				}
			})
	}
	//����ѡ�е�����
	obj.btnOperMatch_click = function() {
		var OperchkRows=obj.gridSlectOperOrds.getChecked();
		var OporderIDStr="",OpICDStr=""
		for (var i=0;i<OperchkRows.length;i++) {
				var Optmprow=OperchkRows[i]
				var OporderID=Optmprow.BTID
				if (obj.gridPathAdmitRecRowID!=Optmprow.AdmitID){
					continue
				}
				var OpICD=Optmprow.ICD
				OporderIDStr+=OporderID+","
				OpICDStr+=OpICD+","
		}
		var inputStr = ""
		inputStr = obj.gridPathAdmitRecRowID;
		inputStr = inputStr + "^"+ "";
		inputStr = inputStr + "^"+ OporderIDStr;
		inputStr = inputStr + "^"+ OpICDStr;
		inputStr = inputStr + "^"+ "O";
		$m({
			ClassName:'DHCMA.CPW.BT.PathAdmitOrds',
			MethodName:'Update',
			aInputStr:inputStr	
		},function(flg){
			if (parseInt(flg)<1) {
				$.messager.alert("������ʾ", "���ݼ��ش���!", 'info');	
			}
			else{
				$.messager.popover({msg: '�޸�������Ϣ�ɹ���',type:'success',timeout: 1000});
				obj.LoadOperDic() ;//ˢ�µ�ǰҳ
				}
			})
	}
	//�������icd
	obj.LoadMDiagDic=function(){
		if(obj.type!="Y"){
			if (!obj.gridPathAdmitRecRowID){
				$.messager.alert("��ʾ", "���������ѡ��һ��׼���¼!", 'error');
				return;	
			}
			if (!Common_GetValue('MdiagSearch')){
				$.messager.alert("��ʾ", "����������������Ҫ��ѯ������!", 'error');
				return;		
			}
		}
		$cm ({
				ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",
				QueryName:"QryMDiag",
				ResultSetType:"array",
				argArea:Common_GetValue('MdiagSearch'),
				Parref:obj.gridPathAdmitRecRowID,
				aType:obj.type,
				page:1,
				rows:999999
			},function(rs){
				$('#gridSlectMDiagOrds').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			});
	}
	//��������icd
	obj.LoadOperDic=function(){
		if(obj.type!="Y"){
			if (!obj.gridPathAdmitRecRowID){
				$.messager.alert("��ʾ", "���������ѡ��һ��׼���¼!", 'error');
				return;	
			}
			if (!Common_GetValue('OperSearch')){
				$.messager.alert("��ʾ", "����������������Ҫ��ѯ������!", 'error');
				return;		
			}	
		}
		
		$cm ({
				ClassName:"DHCMA.CPW.BTS.LinkArcimSrv",
				QueryName:"QryODiag",
				ResultSetType:"array",
				argArea:Common_GetValue('OperSearch'),
				Parref:obj.gridPathAdmitRecRowID,
				aType:obj.type,
				page:1,
				rows:999999
			},function(rs){
				$('#gridSlectOperOrds').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			});
	}
	
}

