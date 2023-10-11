//页面Event
function InitHISUIWinEvent(obj){
	
	//事件绑定
	obj.LoadEvents = function(arguments){
		
		// 加载路径信息
		obj.LoadPathInfo();
		
		//准入提示信息-增加按钮
		$("#addIconMrg").on('click',function(){
			// 如果有编辑行，直接退出
			if (obj.gridPathAdmitEditIndex>-1){
				$.messager.alert("提示","请先保存当前编辑行！");
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
				BTIsICDAcc:"否",
				BTIsOperAcc:"否",
				BTIsActive:"是"
			});
			var rowIndex=$("#gridPathAdmit").datagrid("getRows").length - 1;
			$('#gridPathAdmit').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		});
		
		//准入提示信息-取消按钮
		$("#cancelIconMrg").on('click',function(){
			if (obj.gridPathAdmitEditIndex>-1){
				$('#gridPathAdmit').datagrid("cancelEdit", obj.gridPathAdmitEditIndex);  //结束行编辑
				obj.gridPathAdmit.load({
					ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
					QueryName:"QryPathAdmit",
					aBTPathDr:obj.FormPathID 
				}); 
			} else {
				$.messager.alert("提示","无编辑行！");
				obj.gridPathAdmit.load({
					ClassName:"DHCMA.CPW.BTS.PathAdmitSrv",
					QueryName:"QryPathAdmit",
					aBTPathDr:obj.FormPathID 
				}); 
			}
		});
		
		//准入提示信息-保存按钮
		$("#editIconMrg").on('click',function(){
			debugger
			if (obj.gridPathAdmitEditIndex>-1){
				var rowIndex = obj.gridPathAdmitEditIndex;
				$('#gridPathAdmit').datagrid("endEdit", obj.gridPathAdmitEditIndex);  //结束行编辑
				var rowData  = $('#gridPathAdmit').datagrid('getRows')[rowIndex];  //获取编辑行数据
				var rowID    = obj.savegridPathAdmitRow(rowData);  //保存编辑行数据
				$('#gridPathAdmit').datagrid('reload');  //重新加载Grid数据
			} else {
				$.messager.alert("提示","无编辑行！");
			}
		});
		
		//准入提示信息-删除按钮
		$("#delIconMrg").on('click',function(){
			obj.deletegridPathAdmitRow();
		});
		
		// 保存路径信息
		$("#btnSaveInfo").on('click',function(){
			obj.SavePathInfo();	
		});
		
		//排除诊断搜索
		$('#MdiagSearch').searchbox({
		    searcher:function(value){
			    obj.type="";
			    obj.LoadMDiagDic();
		    },
		});
		
		//排除手术搜索
		$('#OperSearch').searchbox({
		    searcher:function(value){
			    obj.type="";
			    obj.LoadOperDic();
		    },
		});
		//排除诊断已维护查询
	     $('#btnMDFin').on('click', function(){
		     Common_SetValue('MdiagSearch',"");
		     obj.type="Y";
			 obj.LoadMDiagDic();
	     });
	     
	     //排除手术已维护查询
	     $('#btnOpFin').on('click', function(){
		     Common_SetValue('OperSearch',"");
		     obj.type="Y";
			 obj.LoadOperDic("");
	     });
			
	};	
	
	
	// 加载路径信息
	obj.LoadPathInfo = function(){
		//路径信息
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
		
		//审核角色只有制度权限，（项目实施中有具体要求可修改此处代码改变权限）
		if (1) {
			//路径信息
			$("input").attr("disabled", "disabled");
			$("#cboTypeDr,#cboEntityDr,#cboPCEntityDr,#cboQCEntityDr").combobox('disable');
			$("#txtIsActive").switchbox('setActive',false);
			$("#btnSaveInfo").linkbutton("disable");
			
			//准入规则
			$("#addIconMrg,#cancelIconMrg,#editIconMrg,#delIconMrg").linkbutton("disable");
			
			//排除规则
			$("#MdiagSearch,#OperSearch").searchbox("disable");
			$('#gridSlectMDiagOrds').datagrid('hideColumn', 'checked'); 
			$('#gridSlectOperOrds').datagrid('hideColumn', 'checked'); 
			
		}
	};
	
	//准入提示信息--保存编辑行
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
		
		BTIsICDAcc = (BTIsICDAcc =="是"?"1":"0");
		BTIsOperAcc = (BTIsOperAcc =="是"?"1":"0");
		BTIsActive = (BTIsActive =="是"?"1":"0");
		if(BTTypeDr==""){
			$.messager.alert("提示","类型不可以为空！");
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
		//同步调用
		var ret = $.cm({ClassName:"DHCMA.CPW.BT.PathAdmit",MethodName:"Update",
				"aInputStr":InputStr,
				"aSeparete":"^"
			},false);
		if(parseInt(ret)<0){
			$.messager.popover({msg:"保存失败",type:'error',style:{top:250,left:600}});
			return "";
		}else{
			$.messager.popover({msg:"保存成功",type:'success',style:{top:250,left:600}});			
		}
		return ret; //保存成功返回rowID、保存失败返回空
	};
	
	//准入提示信息--删除选中行
	obj.deletegridPathAdmitRow= function(){
		if (obj.gridPathAdmitRecRowID!=""){
			$.messager.confirm("确认","确定删除?",function(r){
				if(r){					
					$.cm({ClassName:'DHCMA.CPW.BT.PathAdmit',MethodName:'DeleteById','aId':obj.gridPathAdmitRecRowID},function(data){
						//debugger;
						if(parseInt(data)<0){
							$.messager.alert("提示","失败！");  //data.msg
						}else{							
							//重新加载datagrid的数据  
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
			$.messager.alert("提示","请先选中行，再执行删除操作！")
		}
	};
	
	// 保存路径信息事件
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
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}	
		var IsCheck = $m({
			ClassName:"DHCMA.CPW.BT.PathMast",
			MethodName:"CheckPTCode",
			aCode:Code,
			aID:obj.FormPathID
		},false);
		if(IsCheck>=1) {
			errinfo = errinfo + "代码与列表中现有项目重复，请检查修改!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
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
					$.messager.alert("错误提示", "参数错误!" , 'info');
				}else if (parseInt(flg) == -2) {
					$.messager.alert("错误提示", "数据重复!" , 'info');
				} else {
					$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
				}
			}else {
				$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
				return;
			}	
	}
	
	//保存选中的诊断
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
				$.messager.alert("错误提示", "数据加载错误!", 'info');	
			}
			else{
				$.messager.popover({msg: '修改ICD诊断成功！',type:'success',timeout: 1000});
				obj.LoadMDiagDic() ;//刷新当前页
				}
			})
	}
	//保存选中的手术
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
				$.messager.alert("错误提示", "数据加载错误!", 'info');	
			}
			else{
				$.messager.popover({msg: '修改手术信息成功！',type:'success',timeout: 1000});
				obj.LoadOperDic() ;//刷新当前页
				}
			})
	}
	//加载诊断icd
	obj.LoadMDiagDic=function(){
		if(obj.type!="Y"){
			if (!obj.gridPathAdmitRecRowID){
				$.messager.alert("提示", "请先在左侧选择一条准入记录!", 'error');
				return;	
			}
			if (!Common_GetValue('MdiagSearch')){
				$.messager.alert("提示", "请在搜索框中输入要查询的内容!", 'error');
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
	//加载手术icd
	obj.LoadOperDic=function(){
		if(obj.type!="Y"){
			if (!obj.gridPathAdmitRecRowID){
				$.messager.alert("提示", "请先在左侧选择一条准入记录!", 'error');
				return;	
			}
			if (!Common_GetValue('OperSearch')){
				$.messager.alert("提示", "请在搜索框中输入要查询的内容!", 'error');
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

