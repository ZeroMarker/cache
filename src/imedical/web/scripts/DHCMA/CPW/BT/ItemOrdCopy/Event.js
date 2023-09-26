//页面Event
function InitHISUIWinEvent(obj){
	//事件绑定
	obj.LoadEvents = function(arguments){
		obj.CurrTab="",obj.CurrAdmType=""
		$HUI.tabs("#cpwTypeTab",{
			onSelect:function(title,index){
				obj.SelectTab(title,index);	
			}
		})
		
		//复制保存事件
		$('#btnCopySave').on('click', function(){
	     	obj.btnCopySave_click();
     	});
		
		$.parser.parse($("body"));
		$("#workS").show();
		$("#workD").hide();
		
	}
	obj.refreshNode = function(node) {
		//加载子节点数据				
		var subNodes = [];
		$(node.target)
		.next().children().children("div.tree-node").each(function(){   
			var tmp = $('#treeType').tree('getNode',this);
			subNodes.push(tmp);
		});
		//$('#treeType').tree('remove',cArr[i].target);
		for(var i=0;i<subNodes.length;i++)
		{
			$('#treeType').tree('remove',subNodes[i].target);
		}
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathFormSrv",
			QueryName:"QryLocPathVer",
			argNodeID:node.id,
			argLocID:"",
			argHospID:session['DHCMA.HOSPID'],
			ResultSetType:"array", 
			page:1,    
			rows:9999
		},function(rs){   
			$('#treeType').tree('append', {
					parent: node.target,
					data: rs
			});
			$('.hisui-splitbutton').splitbutton({ 
			}); 
		});	
	}
	
	//加载树内容
	obj.LoadPathTree =  function (AdmType)  {
		$('#treeType').tree({
			url:$URL+"?ClassName=DHCMA.CPW.BTS.PathFormSrv&QueryName=QryLocPathVer&argNodeID=-root&argLocID=0&argAdmType="+AdmType+"&argHospID="+session['DHCMA.HOSPID']+"&argDesc="+""+"&argKeyWords="+""+"&ResultSetType=array"	
			,onLoadSuccess:function(node,data)
			{
				//回调
			}
		});	
	}
	
	//路径类型点击
	obj.SelectTab=function(title,index){
		if(title=="住院路径"){
			obj.CurrTab="InCPW";					
			obj.CurrAdmType="I";
		}else if(title=="门诊路径"){
			obj.CurrTab="OutCPW";					
			obj.CurrAdmType="O";
		}else {}
		if ($("#treeType").length>0) {
			$("#treeType").tree('loadData', []);
		}
		$("#InCPW").empty();
		$("#OutCPW").empty();
		$("#"+obj.CurrTab).append('<ul id="treeType" class="hisui-tree" data-options="lines:true"></ul>');
		obj.LoadPathTree(obj.CurrAdmType);
	
		$('#treeType').tree({
			onClick:function(node){	
				obj.treeClick(node);
			}
			,onBeforeExpand:function(node,param){
				var idVal = node.id;
			
				if(idVal.indexOf("Path")>-1)
				{
					var rs=$cm({
						ClassName:"DHCMA.CPW.BTS.PathFormSrv",
						QueryName:"QryLocPathVer",
						argNodeID:node.id,
						argLocID:"",
						ResultSetType:"array", 
						page:1,    
						rows:9999
					},false);
					if(rs==""){
						$.messager.alert("提示","当前路径尚未有版本,请先新建一个版本！");
						return false;
					}
				}
			//参数重置
			}
			,onExpand:function(node)
			{
				obj.refreshNode(node);			
			}
		});	
			
	}
	
	//节点点击
	obj.treeClick = function(node){
		var idVal = node.id;
		obj.selPath = node;
		if(idVal.indexOf("Ver")>-1)
		{
			//第三层 表单层选中
			$("#workS").hide();
			$("#workD").show();
			var valArr = idVal.split("-");
			obj.selVerID = valArr[0];  //路径表单ID
		}
		else{
			//第二层 路径
			$("#workD").hide();
			$("#workS").show();
			obj.selVerID = "";
		}
		
		//Common_SetValue("cboFormEp","","");
		//Common_SetValue("cboOrdItem","","");
		//$("#cboFormEp").combobox("setValue","");
		//$("#cboOrdItem").combobox("setValue","");
		$('#cboFormEp').combobox('clear');
		$('#cboOrdItem').combobox('clear');	
		$('#cboFormEp').combobox('reload');
		$('#cboOrdItem').combobox('loadData', {});
		$("#gridOrdDetail").datagrid("loadData", { total: 0, rows: [] });
		$('#treeType').tree('toggle', node.target);
	}
	
	obj.btnCopySave_click = function (){
		var errMsg=""
		var rows = obj.gridOrdDetail.getRows().length; 		
		if (rows>0) {
		    var length = obj.gridOrdDetail.getChecked().length;
		    if (length>0) {
			    var objRec = obj.gridOrdDetail.getChecked();
				for(var i = 0; i < length; i ++) {
					var sID = "";
					var OrdTypeDr = objRec[i].OrdTypeDr;
					var OrdMastID = objRec[i].OrdMastID;
					var OrdGeneID = objRec[i].OrdGeneID;
					var OrdPriorityID = objRec[i].OrdPriorityID;
					var OrdQty = objRec[i].OrdQty;
					var OrdFreqID = objRec[i].OrdFreqID;
					var OrdDuratID = objRec[i].OrdDuratID;
					var OrdInstrucID = objRec[i].OrdInstrucID;
					var OrdDoseQty = objRec[i].OrdDoseQty;
					var OrdUOMID = objRec[i].OrdUOMID;
					var OrdNote = objRec[i].OrdNote;
					var OrdChkPosID = objRec[i].OrdChkPosID;
					var OrdLnkOrdDr = objRec[i].OrdLnkOrdDr; 
					var OrdIsDefault = objRec[i].OrdIsDefault=="否"?"0":"1"; 
					var OrdIsFluInfu = objRec[i].OrdIsFluInfu=="否"?"0":"1"; 
					var BTIsActive =  objRec[i].OrdIsActive=="否"?"0":"1";
					var OrdOID = "";
					
					var InputStr = OrdItemID+"^"+sID;
					InputStr += "^" + OrdTypeDr;
					InputStr += "^" + OrdMastID;
					InputStr += "^" + OrdGeneID;
					InputStr += "^" + OrdPriorityID;
					InputStr += "^" + OrdQty;
					InputStr += "^" + OrdFreqID;
					InputStr += "^" + OrdDuratID;
					InputStr += "^" + OrdInstrucID;
					InputStr += "^" + OrdDoseQty;
					InputStr += "^" + OrdUOMID;
					InputStr += "^" + OrdNote;
					InputStr += "^" + OrdChkPosID;
					InputStr += "^" + OrdLnkOrdDr;
					InputStr += "^" + OrdIsDefault;
					InputStr += "^" + OrdIsFluInfu;		
					InputStr += "^" + BTIsActive;
					InputStr += "^";
					InputStr += "^";
					InputStr += "^" + session['DHCMA.USERID'];
					InputStr += "^" + OrdOID;
					
					var data = $.cm({ClassName:"DHCMA.CPW.BT.PathFormOrd",MethodName:"Update",
						"aInputStr":InputStr,
						"aSeparete":"^"
					},false);
					if(parseInt(data)<0){
						errMsg="复制医嘱【"+objRec[i].OrdMastIDDesc+"】时失败，请重试!"
						break;
					}
				}
				if (errMsg!=""){
					$.messager.alert("提示", errMsg,'info');
					return;	
				}else{
					//websys_showModal支持多层弹出，使用websys_showModel('close')关闭最近一次界面 ,websys_showModel('options') 拿到最近一次界面的配置
					websys_showModal('close');	
				}
		    }else {
				$.messager.alert("提示", "先选择查询记录,再进行保存!",'info');
				return;
			}
		}else {
			$.messager.alert("确认", "无数据记录,不允许复制", 'info');
		}	
	}
	
}