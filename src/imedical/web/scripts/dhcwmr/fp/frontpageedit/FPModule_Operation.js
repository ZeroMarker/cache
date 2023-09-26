function InitFPOperation(obj){
	obj.FPO_RowIndex = 0;
	obj.FPO_RowEditor = new Object();
	obj.FPO_DSQuery = new Array();
	obj.FPO_FPQuery = new Array();
	
	obj.FPO_InitView = function(){
		obj.FPO_RowEditor.No = FP_NumberField("FPO_RowEditor_No","序号");
		obj.FPO_RowEditor.Type = FP_ComboDic("FPO_RowEditor_Type","类型","FPOpeType");
		obj.FPO_RowEditor.ICD10 = FP_TextField("FPO_RowEditor_ICD10","ICD10");
		obj.FPO_RowEditor.ICD = FP_ICDSelect("FPO_RowEditor_ICD","手术名称",obj.FrontPage.FPItemID,"FPO_RowEditor_Type");
		obj.FPO_RowEditor.ICDId = '';
		obj.FPO_RowEditor.ICDTxt = '';
		obj.FPO_RowEditor.OperDate = FP_DateField("FPO_RowEditor_OperDate","手术日期");
		obj.FPO_RowEditor.Operator = FP_SSUserSelect("FPO_RowEditor_Operator","术者","OPRDOC");
		obj.FPO_RowEditor.OperatorId = '';
		obj.FPO_RowEditor.OperatorTxt = '';
		obj.FPO_RowEditor.Ass1 = FP_SSUserSelect("FPO_RowEditor_Ass1","1助","OPRASS");
		obj.FPO_RowEditor.Ass1Id = '';
		obj.FPO_RowEditor.Ass1Txt = '';
		obj.FPO_RowEditor.Ass2 = FP_SSUserSelect("FPO_RowEditor_Ass2","2助","OPRASS");
		obj.FPO_RowEditor.Ass2Id = '';
		obj.FPO_RowEditor.Ass2Txt = '';
		obj.FPO_RowEditor.NarType = FP_ComboDic("FPO_RowEditor_NarType","麻醉方式","NarcosisType");
		obj.FPO_RowEditor.NarDoc = FP_SSUserSelect("FPO_RowEditor_NarDoc","麻醉医师","NARDOC");
		obj.FPO_RowEditor.NarDocId = '';
		obj.FPO_RowEditor.NarDocTxt = '';
		obj.FPO_RowEditor.CutType = FP_ComboDic("FPO_RowEditor_CutType","切口类型","FPCutType");
		obj.FPO_RowEditor.Healing = FP_ComboDic("FPO_RowEditor_Healing","愈合情况","FPHealing");
		obj.FPO_RowEditor.OperLevel = FP_ComboDic("FPO_RowEditor_OperLevel","手术等级","OperationRank");
		obj.FPO_RowEditor.No.setDisabled(true);
		obj.FPO_RowEditor.ICD10.setDisabled(true);
		obj.FPO_RowEditor.ICD.on('select',obj.FPO_RowEditor_ICD_select,obj);
		obj.FPO_RowEditor.Operator.on('select',obj.FPO_RowEditor_Operator_select,obj);
		obj.FPO_RowEditor.Ass1.on('select',obj.FPO_RowEditor_Ass1_select,obj);
		obj.FPO_RowEditor.Ass2.on('select',obj.FPO_RowEditor_Ass2_select,obj);
		obj.FPO_RowEditor.NarDoc.on('select',obj.FPO_RowEditor_NarDoc_select,obj);
		
		obj.FPO_btnSave = new Ext.Button({
			id : 'FPO_btnSave'
			,icon: '../scripts/dhcwmr/img/update.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">保存</span>'
			,renderTo : 'FPO_btnSave'
			,width : 70
			,anchor : '100%'
		});
		obj.FPO_btnCopy = new Ext.Button({
			id : 'FPO_btnCopy'
			,icon: '../scripts/dhcwmr/img/copy.ico'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">复制</span>'
			,renderTo : 'FPO_btnCopy'
			,width : 70
			,anchor : '100%'
		});
		obj.FPO_btnDelete = new Ext.Button({
			id : 'FPO_btnDelete'
			,icon: '../scripts/dhcwmr/img/delete.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">删除</span>'
			,renderTo : 'FPO_btnDelete'
			,width : 70
			,anchor : '100%'
		});
		obj.FPO_btnMoveUp = new Ext.Button({
			id : 'FPO_btnMoveUp'
			,icon: '../scripts/dhcwmr/img/moveup.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">上移</span>'
			,renderTo : 'FPO_btnMoveUp'
			,width : 70
			,anchor : '100%'
		});
		obj.FPO_btnMoveDown = new Ext.Button({
			id : 'FPO_btnMoveDown'
			,icon: '../scripts/dhcwmr/img/movedown.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">下移</span>'
			,renderTo : 'FPO_btnMoveDown'
			,width : 70
			,anchor : '100%'
		});
		obj.FPO_btnFindICD = new Ext.Button({
			id : 'FPO_btnFindICD'
			,icon: '../scripts/dhcwmr/img/find.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">ICD检索</span>'
			,renderTo : 'FPO_btnFindICD'
			,width : 90
			,anchor : '100%'
		});
		
		obj.FPO_btnFindICD.on('click',obj.FPO_btnFindICD_onclick,obj);
		obj.FPO_btnSave.on('click',obj.FPO_btnSave_onclick,obj);
		obj.FPO_btnCopy.on('click',obj.FPO_btnCopy_onclick,obj);
		obj.FPO_btnDelete.on('click',obj.FPO_btnDelete_onclick,obj);
		obj.FPO_btnMoveUp.on('click',obj.FPO_btnMoveUp_onclick,obj);
		obj.FPO_btnMoveDown.on('click',obj.FPO_btnMoveDown_onclick,obj);
		Common_SetDisabled("FPO_btnDelete",true);
		Common_SetDisabled("FPO_btnMoveUp",true);
		Common_SetDisabled("FPO_btnMoveDown",true);
		
		obj.FPO_LoadDSQuery();	//加载首页手术列表
		obj.FPO_LoadFPQuery();	//加载编目手术列表
		if (obj.FrontPage.FrontPageID == ''){
			for (var row = 0; row < obj.FPO_DSQuery.length; row++){
				var record = obj.FPO_DSQuery[row];
				var newIndex = obj.FPO_FPQuery.length;
				obj.FPO_FPQuery[newIndex]=record;
			}
		}
		obj.FPO_DSTemplate.overwrite("divOperation-DS",obj.FPO_DSQuery);	//显示首页手术列表
		obj.FPO_FPTemplate.overwrite("divOperation-FP",obj.FPO_FPQuery);	//显示编目手术列表
	}
	
	obj.FPO_DSTemplate = new Ext.XTemplate(
		'<table id="FPO_DSTable" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#00AEAE;text-align:center;width:100%;">',
			'<tr style="font-size:13px;height:30px;font-weight:bold;">',
				'<td align="center" width="4%">序号</td>',
				'<td align="center" width="4%">类型</td>',
				'<td align="center" width="6%">ICD10</td>',
				'<td align="center" width="30%">手术名称</td>',
				'<td align="center" width="8%">手术日期</td>',
				'<td align="center" width="6%">术者</td>',
				'<td align="center" width="6%">1助</td>',
				'<td align="center" width="6%">2助</td>',
				'<td align="center" width="8%">麻醉方式</td>',
				'<td align="center" width="6%">麻醉医师</td>',
				'<td align="center" width="4%">切口类型</td>',
				'<td align="center" width="4%">愈合情况</td>',
				'<td align="center" width="8%">手术等级</td>',
			'</tr>',
			'<tbody>',
				'<tpl for=".">',
					'<tr {[this.trEvent()]} class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">',
						'<td {[this.tdEvent()]} align="center">{[xindex]}</td>',
						'<td {[this.tdEvent()]} align="center">{TypeDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{ICD10}</td>',
						'<td {[this.tdEvent()]} align="left">{ICDDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{OperSttDate}</td>',
						'<td {[this.tdEvent()]} align="center">{OperatorName}</td>',
						'<td {[this.tdEvent()]} align="center">{Ass1Name}</td>',
						'<td {[this.tdEvent()]} align="center">{Ass2Name}</td>',
						'<td {[this.tdEvent()]} align="center">{NarTypeDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{NarDocName}</td>',
						'<td {[this.tdEvent()]} align="center">{CutTypeDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{HealingDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{OperLevelDesc}</td>',
					'</tr>',
				'</tpl>',
			'</tbody>',
		'</table>',
		{
			trEvent : function(){
				var tabEv = '';
				tabEv += ' ondblclick="objScreen.FPO_DSTable_Rowdblclick(this);"'
				tabEv += ' style="font-size:13px;height:30px;"'
				return tabEv;
			},
			tdEvent : function(){
				var tabEv = '';
				tabEv += ' style="border:1px solid #DAE0EF;"'
				return tabEv;
			}
		}
	);
	
	obj.FPO_FPTemplate = new Ext.XTemplate(
		'<table id="FPO_FPTable" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;width:100%;">',
			'<tr style="font-size:13px;height:30px;font-weight:bold;">',
				'<td align="center" width="4%">序号</td>',
				'<td align="center" width="4%">类型</td>',
				'<td align="center" width="6%">ICD10</td>',
				'<td align="center" width="30%">手术/操作名称</td>',
				'<td align="center" width="8%">手术日期</td>',
				'<td align="center" width="6%">术者</td>',
				'<td align="center" width="6%">1助</td>',
				'<td align="center" width="6%">2助</td>',
				'<td align="center" width="8%">麻醉方式</td>',
				'<td align="center" width="6%">麻醉医师</td>',
				'<td align="center" width="4%">切口类型</td>',
				'<td align="center" width="4%">愈合情况</td>',
				'<td align="center" width="8%">手术等级</td>',
			'</tr>',
			'<tbody>',
				'<tpl for=".">',
					'<tr {[this.trEvent()]} class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">',
						'<td {[this.tdEvent()]} align="center">{[xindex]}</td>',
						'<td {[this.tdEvent()]} align="center">{[this.tdError(values.TypeID,values.TypeDesc)]} {TypeDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{[this.tdError(values.ICDID,values.ICD10)]} {ICD10}</td>',
						'<td {[this.tdEvent()]} align="left">{[this.tdError(values.ICDID,values.ICDDesc)]} {ICDDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{OperSttDate}</td>',
						'<td {[this.tdEvent()]} align="center">{OperatorName}</td>',
						'<td {[this.tdEvent()]} align="center">{Ass1Name}</td>',
						'<td {[this.tdEvent()]} align="center">{Ass2Name}</td>',
						'<td {[this.tdEvent()]} align="center">{[this.tdError(values.NarTypeID,values.NarTypeDesc)]} {NarTypeDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{NarDocName}</td>',
						'<td {[this.tdEvent()]} align="center">{[this.tdError(values.CutTypeID,values.CutTypeDesc)]} {CutTypeDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{[this.tdError(values.HealingID,values.HealingDesc)]} {HealingDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{[this.tdError(values.OperLevelID,values.OperLevelDesc)]} {OperLevelDesc}</td>',
					'</tr>',
				'</tpl>',
				'<tr class="RowEven" style="border-bottom:1px #BDBDBD solid;">',
					'<td align="center"><div id="Cmp_FPO_RowEditor_No" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_Type" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_ICD10" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="left"><div id="Cmp_FPO_RowEditor_ICD" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_OperDate" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_Operator" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_Ass1" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_Ass2" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_NarType" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_NarDoc" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_CutType" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_Healing" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPO_RowEditor_OperLevel" style="width:100%;overflow:hidden;"></div></td>',
				'</tr>',
			'</tbody>',
		'</table>',
		{
			trEvent : function(){
				var tabEv = '';
				tabEv += ' onclick="objScreen.FPO_FPTable_Rowclick(this);"'
				tabEv += ' onmousedown="objScreen.FPO_RowMouseDown(this);"'
				//tabEv += ' onmousemove="objScreen.FPO_RowMouseMove(this);"'
				tabEv += ' onmouseup="objScreen.FPO_RowMouseUp(this);"'
				tabEv += ' style="font-size:13px;height:30px;"'
				return tabEv;
			},
			tdEvent : function(){
				var tabEv = '';
				tabEv += ' style="border:1px solid #DAE0EF;"'
				return tabEv;
			},
			tdError : function(val1,val2){
				return (((val1 == '')&&(val2 != '')) ? '@' : '');
			}
		}
	);
	
	obj.FPO_LoadDSQuery = function(){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FPService.FPOperationSrv'
		url += '&QueryName=' + 'QryICDList'
		url += '&Arg1=' + ''
		url += '&Arg2=' + obj.FrontPage.VolumeID
		url += '&Arg3=' + obj.FrontPage.FPItemID
		url += '&ArgCnt=' + 3
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var arryData = new Array();
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				arryData[arryData.length] = objItem;
			}
			
			obj.FPO_DSQuery.length = 0;
			obj.FPO_DSQuery = arryData;
			return true;
		} else {
			ExtTool.alert("提示","加载手术数据错误!");
			return false;
		}
	}
	
	obj.FPO_LoadFPQuery = function(){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FPService.FPOperationSrv'
		url += '&QueryName=' + 'QryICDList'
		url += '&Arg1=' + obj.FrontPage.FrontPageID
		url += '&Arg2=' + ''
		url += '&Arg3=' + ''
		url += '&ArgCnt=' + 3
		url += '&2=2'
        conn.open("post",url,false);
		conn.send(null);
		
		if (conn.status == "200") {
			var objData = Ext.decode(conn.responseText);
			var arryData = new Array();
			var objItem = null;
			for(var i = 0; i < objData.total; i ++)
			{
				objItem = objData.record[i];
				arryData[arryData.length] = objItem;
			}
			
			obj.FPO_FPQuery.length = 0;
			obj.FPO_FPQuery = arryData;
			return true;
		} else {
			ExtTool.alert("提示","加载手术数据错误!");
			return false;
		}
	}
	
	obj.FPO_AddNewTableRow = function(record){
		var _table = document.getElementById("FPO_FPTable");
		var _row = _table.insertRow(-1);
		_row.setAttribute("class", (_row.rowIndex % 2 === 1 ? "RowEven" : "RowOdd"));
		_row.setAttribute("className", (_row.rowIndex % 2 === 1 ? "RowEven" : "RowOdd"));
		_row.style.backgroundColor = '';
		_row.style.fontsize = '13px';
		_row.style.height = '30px';
		_row.onclick = function(){obj.FPO_FPTable_Rowclick(this);};
		_row.onmousedown = function(){obj.FPO_RowMouseDown(this);};
		_row.onmousemove = function(){obj.FPO_RowMouseMove(this);};
		_row.onmouseup = function(){obj.FPO_RowMouseUp(this);};
		
		var _cells = _table.rows[1].cells;
		for (var col = 0; col < _cells.length; col++){
			var _cell = _row.insertCell();
			_cell.innerHTML = _cells[col].innerHTML;
			_cell.innerText = _cells[col].innerText;
			_cell.style.border = '1px solid #DAE0EF';
			_cell.align = _cells[col].align;
		}
		
		_row.cells[1].innerHTML = record.TypeDesc;
		_row.cells[2].innerHTML = record.ICD10;
		_row.cells[3].innerHTML = record.ICDDesc;
		_row.cells[4].innerHTML = record.OperSttDate;
		_row.cells[5].innerHTML = record.OperatorName;
		_row.cells[6].innerHTML = record.Ass1Name;
		_row.cells[7].innerHTML = record.Ass2Name;
		_row.cells[8].innerHTML = record.NarTypeDesc;
		_row.cells[9].innerHTML = record.NarDocName;
		_row.cells[10].innerHTML = record.CutTypeDesc;
		_row.cells[11].innerHTML = record.HealingDesc;
		_row.cells[12].innerHTML = record.OperLevelDesc;
		
		_row = _row.parentElement.moveRow(_row.rowIndex-2,_row.rowIndex-1,2);	//调整行位置
	}
	
	obj.FPO_DSTable_Rowdblclick = function(_row){
		obj.FPO_LoadDSQuery();     //加载首页手术列表，修改bug,第二次双击首页列表，编目编辑框加载上次保存的记录。
		var rowIndex = _row.rowIndex;
		var objRec = obj.FPO_DSQuery[rowIndex-1];
		var newIndex = obj.FPO_FPQuery.length + 1;
		obj.FPO_FPQuery[newIndex-1] = objRec;
		obj.FPO_AddNewTableRow(objRec);  //***添加空白行
		obj.FPO_SelectRow(newIndex);  //选中行
	}
	
	obj.FPO_FPTable_Rowclick = function(_row){
		var rowIndex = _row.rowIndex;
		obj.FPO_SelectRow(rowIndex);  //选中行
	}
	
	obj.FPO_btnFindICD_onclick = function(){
		var TypeID = Common_GetValue('FPO_RowEditor_Type');
		if (TypeID == ''){
			ExtTool.alert('提示', '请先输入手术/操作类型!');
			return;
		}
		var ICDAlias = Common_GetText('FPO_RowEditor_ICD');
		var win = new FP_FindICDWin(ICDAlias,TypeID,'FPO_RowEditor_ICD');
	}
	
	obj.FPO_btnSave_onclick = function(){
		//保存控制
		var TypeDesc = Common_GetText("FPO_RowEditor_Type");
		var ICDDesc  = Common_GetText("FPO_RowEditor_ICD");
		if ((TypeDesc == '')&&(ICDDesc == '')) {
			ExtTool.alert('提示', '类型和手术名称为空,不允许保存!');
			return;
		}
		
		//保存行数据
		var rowIndex = Common_GetValue("FPO_RowEditor_No");
		if (rowIndex) {
			rowIndex = rowIndex*1;
			var objRec = obj.FPO_FPQuery[rowIndex-1];
			objRec = obj.FPO_GetRecord(objRec);  //获取记录值
		} else {
			rowIndex = obj.FPO_FPQuery.length + 1;
			var objRec = obj.FPO_GetRecord();  //获取记录值
			obj.FPO_AddNewTableRow(objRec);  //***添加空白行
		}
		obj.FPO_FPQuery[rowIndex-1] = objRec;
		
		//更新行显示
		var _table = document.getElementById("FPO_FPTable");
		_row = _table.rows[rowIndex];
		_row.cells[1].innerHTML = (((objRec.TypeID == '')&&(objRec.TypeDesc != '')) ? '@' : '') + objRec.TypeDesc;
		_row.cells[2].innerHTML = objRec.ICD10;
		_row.cells[3].innerHTML = (objRec.ICDID == '' ? '@' : '') + objRec.ICDDesc;
		_row.cells[4].innerHTML = objRec.OperSttDate;
		_row.cells[5].innerHTML = objRec.OperatorName;
		_row.cells[6].innerHTML = objRec.Ass1Name;
		_row.cells[7].innerHTML = objRec.Ass2Name;
		_row.cells[8].innerHTML = (((objRec.NarTypeID == '')&&(objRec.NarTypeDesc != '')) ? '@' : '') + objRec.NarTypeDesc;
		_row.cells[9].innerHTML = objRec.NarDocName;
		_row.cells[10].innerHTML = (((objRec.CutTypeID == '')&&(objRec.CutTypeDesc != '')) ? '@' : '') + objRec.CutTypeDesc;
		_row.cells[11].innerHTML = (((objRec.HealingID == '')&&(objRec.HealingDesc != '')) ? '@' : '') + objRec.HealingDesc;
		_row.cells[12].innerHTML = (((objRec.OperLevelID == '')&&(objRec.OperLevelDesc != '')) ? '@' : '') + objRec.OperLevelDesc;
		
		obj.FPO_RowIndex = rowIndex;
		if (rowIndex < (_table.rows.length-2)){
			obj.FPO_RowMoveDown();  //自动选择下一行
		} else {
			obj.FPO_SetTabStyle();  //初始化Table样式及行号
			obj.FPO_ClearForms();   //清空表单元素内容
		}
		
		//获取焦点延迟300毫秒执行
		setTimeout('objScreen.FPO_RowEditor_focus(1)',300);
	}
	
	obj.FPO_btnCopy_onclick = function(){
		var arrQuery = obj.FPO_FPQuery;
		if (arrQuery.length<1) return;
		//update by zhouruimeng 2015-03-17修改复制时复制最后一条，改为复制选中的那一条
		//var objRec = arrQuery[arrQuery.length-1];
		var rowIndex = obj.FPO_RowIndex;
		var objRec = arrQuery[rowIndex-1];
		
		obj.FPO_SetTabStyle();  //初始化Table样式及行号
		obj.FPO_ClearForms();   //清空表单元素内容
		
		Common_SetValue("FPO_RowEditor_No","");
		Common_SetValue("FPO_RowEditor_Type",objRec.TypeID,objRec.TypeDesc);
		Common_SetValue("FPO_RowEditor_OperDate",objRec.OperSttDate);
		Common_SetValue("FPO_RowEditor_Operator",objRec.OperatorID,objRec.OperatorName);
		obj.FPO_RowEditor.OperatorId = objRec.OperatorID;
		obj.FPO_RowEditor.OperatorTxt = objRec.OperatorName;
		Common_SetValue("FPO_RowEditor_Ass1",objRec.Ass1ID,objRec.Ass1Name);
		obj.FPO_RowEditor.Ass1Id = objRec.Ass1ID;
		obj.FPO_RowEditor.Ass1Txt = objRec.Ass1Name;
		Common_SetValue("FPO_RowEditor_Ass2",objRec.Ass2ID,objRec.Ass2Name);
		obj.FPO_RowEditor.Ass2Id = objRec.Ass2ID;
		obj.FPO_RowEditor.Ass2Txt = objRec.Ass2Name;
		Common_SetValue("FPO_RowEditor_NarType",objRec.NarTypeID,objRec.NarTypeDesc);
		Common_SetValue("FPO_RowEditor_NarDoc",objRec.NarDocID,objRec.NarDocName);
		obj.FPO_RowEditor.NarDocId = objRec.NarDocID;
		obj.FPO_RowEditor.NarDocTxt = objRec.NarDocName;
		Common_SetValue("FPO_RowEditor_CutType",objRec.CutTypeID,objRec.CutTypeDesc);
		Common_SetValue("FPO_RowEditor_Healing",objRec.HealingID,objRec.HealingDesc);
		Common_SetValue("FPO_RowEditor_OperLevel",objRec.OperLevelID,objRec.OperLevelDesc);
		
		//获取焦点延迟300毫秒执行
		setTimeout('objScreen.FPO_RowEditor_focus(2)',300);
	}
	
	obj.FPO_btnDelete_onclick = function(){
		var rowIndex = obj.FPO_RowIndex;
		Ext.MessageBox.confirm('删除', '是否删除当前记录?', function(btn,text){
			if(btn=="yes"){
				//删除行
				var _table = document.getElementById("FPO_FPTable");
				var _row = _table.rows[rowIndex];
				_row.parentNode.removeChild(_row);
				
				//删除数据行
				obj.FPO_FPQuery.splice(rowIndex-1,1); //删除数据项
				
				obj.FPO_SetTabStyle(); //初始化Table样式及行号
				obj.FPO_ClearForms(); //清空表单元素内容
				
				//获取焦点延迟300毫秒执行
				setTimeout('objScreen.FPO_RowEditor_focus(1)',300);
			}
		});
	}
	
	obj.FPO_btnMoveUp_onclick = function(){
		var rowIndex = obj.FPO_RowIndex;
		var _table = document.getElementById("FPO_FPTable");
		if (rowIndex<=1) return;  //第一行退出
		var _row = _table.moveRow(rowIndex,rowIndex-1,1);  //移动行(上移)
		
		var dataIndex = rowIndex-1;
		var objRec = obj.FPO_FPQuery[dataIndex-1];  //移动数据行(上移)
		obj.FPO_FPQuery[dataIndex-1] = obj.FPO_FPQuery[dataIndex];
		obj.FPO_FPQuery[dataIndex] = objRec;
		
		obj.FPO_SelectRow(rowIndex-1);  //选中行
	}
	
	obj.FPO_btnMoveDown_onclick = function(){
		var rowIndex = obj.FPO_RowIndex;
		var _table = document.getElementById("FPO_FPTable");
		if (rowIndex >= _table.rows.length-2) return;  //最后一行退出
		var _row = _table.moveRow(rowIndex,rowIndex+1,1);  //移动行(下移)
		
		var dataIndex = rowIndex-1;
		var objRec = obj.FPO_FPQuery[dataIndex+1];  //移动数据行(下移)
		obj.FPO_FPQuery[dataIndex+1] = obj.FPO_FPQuery[dataIndex];
		obj.FPO_FPQuery[dataIndex] = objRec;
		
		obj.FPO_SelectRow(rowIndex+1); //选中行
	}
	
	var beginMoving = false;
	obj.FPO_RowMouseDown = function(_row){
		obj.FPO_SetTabStyle(); //初始化Table样式及行号
		_row.style.backgroundColor = '#FF9797';
		_row.style.zIndex = 1;
		_row.mouseDownY = event.clientY;
		_row.mouseDownX = event.clientX;
		beginMoving = true;
		event.srcElement.setCapture();
	}
	obj.FPO_RowMouseMove = function(_row){
		if(!beginMoving) return false;
		_row.style.top = (event.clientY-_row.mouseDownY);
		_row.style.left = (event.clientX-_row.mouseDownX);
	}
	obj.FPO_RowMouseUp = function(_row){
		if(!beginMoving) return false;
		event.srcElement.releaseCapture();
		
		_row.style.top = 0;
		_row.style.left = 0;
		_row.style.zIndex = 0;
		
		beginMoving = false;
		var _table = _row.parentElement;
		var rowIndex = _row.rowIndex;
		var rowHeight = _row.clientHeight;
		var tempTop = event.clientY - _row.mouseDownY;
		var tempRowIndex = ((tempTop-tempTop%rowHeight)/rowHeight);
		if (tempTop%rowHeight > 10){
			tempRowIndex += 1;
		} else if (tempTop%rowHeight < -10){
			tempRowIndex -= 1;
		} else {}
		tempRowIndex = tempRowIndex + rowIndex;
		if (tempRowIndex == rowIndex) return false;  //未拖动行
		if (tempRowIndex < 1) tempRowIndex = 1;  //拖动行越界
		if (tempRowIndex > _table.rows.length-1) tempRowIndex = _table.rows.length-1;  //拖动行越界
		_row = _table.moveRow(rowIndex-1,tempRowIndex-1);  //移动行(拖动)
		
		var dataIndex = rowIndex-1;
		var tmpDataIndex = tempRowIndex-1;
		var objRec = obj.FPO_FPQuery[dataIndex];  //移动数据行(拖动)
		if (dataIndex<tmpDataIndex){
			for (var indData = dataIndex; indData < tmpDataIndex; indData++){
				obj.FPO_FPQuery[indData] = obj.FPO_FPQuery[indData+1];
			}
		} else {
			for (var indData = dataIndex; indData > tmpDataIndex; indData--){
				obj.FPO_FPQuery[indData] = obj.FPO_FPQuery[indData-1];
			}
		}
		obj.FPO_FPQuery[tmpDataIndex] = objRec;
		
		obj.FPO_SelectRow(tempRowIndex);  //选中行
	}
	
	obj.FPO_SetTabStyle = function(){
		var _table = document.getElementById("FPO_FPTable");
		for (var row = 1; row < _table.rows.length - 1; row++){
			var cls = (row % 2 === 1 ? "RowEven" : "RowOdd");
			_table.rows[row].setAttribute("class", cls);
			_table.rows[row].setAttribute("className", cls);
			_table.rows[row].style.backgroundColor = '';
			_table.rows[row].cells[0].innerText = row;
		}
	}
	
	obj.FPO_SelectRow = function(rowIndex){
		obj.FPO_RowIndex = rowIndex;
		Common_SetDisabled("FPO_btnDelete",false);
		Common_SetDisabled("FPO_btnMoveUp",false);
		Common_SetDisabled("FPO_btnMoveDown",false);
		
		var arrQuery = obj.FPO_FPQuery;
		var objRec = arrQuery[rowIndex-1];
		
		Common_SetValue("FPO_RowEditor_No",rowIndex);
		Common_SetValue("FPO_RowEditor_Type",objRec.TypeID,objRec.TypeDesc);
		Common_SetValue("FPO_RowEditor_ICD10",objRec.ICD10);
		Common_SetValue("FPO_RowEditor_ICD",objRec.ICDID,objRec.ICDDesc);
		obj.FPO_RowEditor.ICDId = objRec.ICDID;
		obj.FPO_RowEditor.ICDTxt = objRec.ICDDesc;
		Common_SetValue("FPO_RowEditor_OperDate",objRec.OperSttDate);
		Common_SetValue("FPO_RowEditor_Operator",objRec.OperatorID,objRec.OperatorName);
		obj.FPO_RowEditor.OperatorId = objRec.OperatorID;
		obj.FPO_RowEditor.OperatorTxt = objRec.OperatorName;
		Common_SetValue("FPO_RowEditor_Ass1",objRec.Ass1ID,objRec.Ass1Name);
		obj.FPO_RowEditor.Ass1Id = objRec.Ass1ID;
		obj.FPO_RowEditor.Ass1Txt = objRec.Ass1Name;
		Common_SetValue("FPO_RowEditor_Ass2",objRec.Ass2ID,objRec.Ass2Name);
		obj.FPO_RowEditor.Ass2Id = objRec.Ass2ID;
		obj.FPO_RowEditor.Ass2Txt = objRec.Ass2Name;
		Common_SetValue("FPO_RowEditor_NarType",objRec.NarTypeID,objRec.NarTypeDesc);
		Common_SetValue("FPO_RowEditor_NarDoc",objRec.NarDocID,objRec.NarDocName);
		obj.FPO_RowEditor.NarDocId = objRec.NarDocID;
		obj.FPO_RowEditor.NarDocTxt = objRec.NarDocName;
		Common_SetValue("FPO_RowEditor_CutType",objRec.CutTypeID,objRec.CutTypeDesc);
		Common_SetValue("FPO_RowEditor_Healing",objRec.HealingID,objRec.HealingDesc);
		Common_SetValue("FPO_RowEditor_OperLevel",objRec.OperLevelID,objRec.OperLevelDesc);
		
		var _table = document.getElementById("FPO_FPTable");
		for (var row = 1; row < _table.rows.length-1; row++){
			if (row == rowIndex){
				_table.rows[row].style.backgroundColor = '#FF9797';
			} else {
				_table.rows[row].style.backgroundColor = '';
			}
			var cls = (row % 2 === 1 ? "RowEven" : "RowOdd");
			_table.rows[row].setAttribute("class", cls);
			_table.rows[row].setAttribute("className", cls);
			_table.rows[row].cells[0].innerText = row;
		}
		
		//获取焦点延迟300毫秒执行
		setTimeout('objScreen.FPO_RowEditor_focus(1)',300);
	}
	
	obj.FPO_RowEditor_focus = function(col){
		if (col ==1){
			var cmp = Ext.getCmp('FPO_RowEditor_Type');
			if (cmp) cmp.focus(); //光标定位
		} else if (col == 2) {
			var cmp = Ext.getCmp('FPO_RowEditor_ICD');
			if (cmp) cmp.focus(); //光标定位
		}
	}
	
	obj.FPO_RowMoveDown = function(){
		var rowIndex = obj.FPO_RowIndex;
		var _table = document.getElementById("FPO_FPTable");
		if (rowIndex >= (_table.rows.length-3)) rowIndex = _table.rows.length - 3;
		obj.FPO_SelectRow(rowIndex+1);  //选中行
	}
	
	obj.FPO_ClearForms = function(){
		obj.FPO_RowIndex = 0;
		Common_SetValue("FPO_RowEditor_No","");
		Common_SetValue("FPO_RowEditor_Type","","");
		Common_SetValue("FPO_RowEditor_ICD10","");
		Common_SetValue("FPO_RowEditor_ICD","","");
		obj.FPO_RowEditor.ICDId = '';
		obj.FPO_RowEditor.ICDTxt = '';
		Common_SetValue("FPO_RowEditor_OperDate","");
		Common_SetValue("FPO_RowEditor_Operator","","");
		obj.FPO_RowEditor.OperatorId = '';
		obj.FPO_RowEditor.OperatorTxt = '';
		Common_SetValue("FPO_RowEditor_Ass1","","");
		obj.FPO_RowEditor.Ass1Id = '';
		obj.FPO_RowEditor.Ass1Txt = '';
		Common_SetValue("FPO_RowEditor_Ass2","","");
		obj.FPO_RowEditor.Ass2Id = '';
		obj.FPO_RowEditor.Ass2Txt = '';
		Common_SetValue("FPO_RowEditor_NarType","","");
		Common_SetValue("FPO_RowEditor_NarDoc","","");
		obj.FPO_RowEditor.NarDocId = '';
		obj.FPO_RowEditor.NarDocTxt = '';
		Common_SetValue("FPO_RowEditor_CutType","","");
		Common_SetValue("FPO_RowEditor_Healing","","");
		Common_SetValue("FPO_RowEditor_OperLevel","","");
		
		Common_SetDisabled("FPO_btnDelete",true);
		Common_SetDisabled("FPO_btnMoveUp",true);
		Common_SetDisabled("FPO_btnMoveDown",true);
	}
	
	obj.FPO_RowEditor_ICD_select = function(cb,rd,ind){
		Common_SetValue("FPO_RowEditor_ICD10",rd.get('ICD10'));
		obj.FPO_RowEditor.ICDId = cb.getValue();
		obj.FPO_RowEditor.ICDTxt = cb.getRawValue();
	}
	
	obj.FPO_RowEditor_Operator_select = function(cb,rd,ind){
		obj.FPO_RowEditor.OperatorId = cb.getValue();
		obj.FPO_RowEditor.OperatorTxt = cb.getRawValue();
	}
	
	obj.FPO_RowEditor_Ass1_select = function(cb,rd,ind){
		obj.FPO_RowEditor.Ass1Id = cb.getValue();
		obj.FPO_RowEditor.Ass1Txt = cb.getRawValue();
	}
	
	obj.FPO_RowEditor_Ass2_select = function(cb,rd,ind){
		obj.FPO_RowEditor.Ass2Id = cb.getValue();
		obj.FPO_RowEditor.Ass2Txt = cb.getRawValue();
	}
	
	obj.FPO_RowEditor_NarDoc_select = function(cb,rd,ind){
		obj.FPO_RowEditor.NarDocId = cb.getValue();
		obj.FPO_RowEditor.NarDocTxt = cb.getRawValue();
	}
	
	//获取手术编目结果
	obj.FPO_GetInput = function(tmpFlag){
		var strResult = '';
		var arrResult = obj.FPO_FPQuery;
		for (var ind = 0; ind < arrResult.length; ind++){
			var strTemp = '';
			var record = arrResult[ind];
			if (tmpFlag != 1){
				strTemp = record.TypeID
				strTemp += '^' + record.TypeDesc
				strTemp += '^' + record.ICDID
				strTemp += '^' + record.ICD10
				strTemp += '^' + record.ICDDesc
				strTemp += '^' + record.OperSttDate
				strTemp += '^' + record.OperSttTime
				strTemp += '^' + record.OperEndDate
				strTemp += '^' + record.OperEndTime
				strTemp += '^' + record.OperatorID
				strTemp += '^' + record.OperatorName
				strTemp += '^' + record.Ass1ID
				strTemp += '^' + record.Ass1Name
				strTemp += '^' + record.Ass2ID
				strTemp += '^' + record.Ass2Name
				strTemp += '^' + record.NarTypeID
				strTemp += '^' + record.NarTypeDesc
				strTemp += '^' + record.NarDocID
				strTemp += '^' + record.NarDocName
				strTemp += '^' + record.CutTypeID
				strTemp += '^' + record.CutTypeDesc
				strTemp += '^' + record.HealingID
				strTemp += '^' + record.HealingDesc
				strTemp += '^' + record.OperLevelID
				strTemp += '^' + record.OperLevelDesc
			}
			
			if (strResult != '') strResult += CHR_1
			strResult += obj.FrontPage.FrontPageID
			strResult += CHR_2 + record.FPSubID
			strResult += CHR_2 + (ind+1)  //record.RowIndex
			strResult += CHR_2 + record.ICDID
			strResult += CHR_2 + record.TypeID
			strResult += CHR_2 + record.OperSttDate
			strResult += CHR_2 + record.OperatorID
			strResult += CHR_2 + record.OperatorName
			strResult += CHR_2 + record.Ass1ID
			strResult += CHR_2 + record.Ass1Name
			strResult += CHR_2 + record.Ass2ID
			strResult += CHR_2 + record.Ass2Name
			strResult += CHR_2 + record.NarTypeID
			strResult += CHR_2 + record.NarDocID
			strResult += CHR_2 + record.NarDocName
			strResult += CHR_2 + record.CutTypeID
			strResult += CHR_2 + record.HealingID
			strResult += CHR_2 + record.OperLevelID
			strResult += CHR_2 + record.DataSource
			strResult += CHR_2 + strTemp
		}
		return strResult;
	}
	
	//校验编目输入内容
	obj.FPO_CheckInput = function(){
		var errInfo = '';
		var AdmitDate = obj.FrontPage.AdmitDate;
		var DischDate = obj.FrontPage.DischDate;
		var arrResult = obj.FPO_FPQuery;
		for (var ind = 0; ind < arrResult.length; ind++){
			var rowErr = '';
			var record = arrResult[ind];
			if (record.TypeID == '') rowErr += '___类型不允许为空!'
			if (record.ICDID == '') rowErr += '___手术/操作编码不允许为空!'
			if (record.ICDDesc == '') rowErr += '___手术/操作名称不允许为空!'
			if (record.TypeDesc == '操作'){
				if (record.OperSttDate == '') rowErr += '___手术日期不允许为空!'
				if (record.OperatorName == '') rowErr += '___术者不允许为空!'
				//if (record.CutTypeID == '') rowErr += '___切口方式不允许为空!'
				//if (record.HealingID == '') rowErr += '___愈合情况不允许为空!'
				//if (record.OperLevelID == '') rowErr += '___手术等级不允许为空!'
			} else { //手术
				if (record.OperSttDate == '') rowErr += '___手术日期不允许为空!'
				if (record.OperatorName == '') rowErr += '___术者不允许为空!'
				if (record.CutTypeID == '') rowErr += '___切口方式不允许为空!'
				if (record.HealingID == '') rowErr += '___愈合情况不允许为空!'
				if (record.OperLevelID == '') rowErr += '___手术等级不允许为空!'
				
			}
			//if ((record.OperatorID == '')&&(record.OperatorName != '')) rowErr += '___术者输入内容不规范!'
			//if ((record.Ass1ID == '')&&(record.Ass1Name != '')) rowErr += '___1助输入内容不规范!'
			//if ((record.Ass2ID == '')&&(record.Ass2Name != '')) rowErr += '___2助输入内容不规范!'
			if (((record.NarTypeID != '')||(record.NarTypeDesc!=''))&&(record.NarDocName == '')) rowErr += '___麻醉医师必须填写!'
			
			//手术日期不能大于出院日期、小于入院日期
			var OperDate=record.OperSttDate;
			if ((AdmitDate != '')&&(OperDate != '')){
				var flg = Common_CompareDate(AdmitDate,OperDate);
				if (!flg) rowErr += '___手术日期小于入院日期!'
			}
			if ((DischDate != '')&&(OperDate != '')){
				var flg = Common_CompareDate(OperDate,DischDate);
				if (!flg) rowErr += '___手术日期大于出院日期!'
			}
			if (rowErr != '') errInfo += '<br>行 ' + (ind+1) + ' 提示：' + rowErr;
		}
		
		if (errInfo != '') errInfo = '<br>手术错误提示：' + errInfo;
		return errInfo;
	}
	
	obj.FPO_GetRecord = function(objRec){
		if (!objRec){
			var objRec = new Object();
			objRec.VolumeID = obj.FrontPage.VolumeID;
			objRec.EpisodeID = obj.FrontPage.VolPaadm;
			objRec.FrontPageID = obj.FrontPage.FrontPageID;
			objRec.FPSubID = '';
			objRec.TypeID = '';
			objRec.TypeCode = '';
			objRec.TypeDesc = '';
			objRec.ICDID = '';
			objRec.ICD10 = '';
			objRec.ICDDesc = '';
			objRec.ICDVerID = '';
			objRec.ICDVerCode = '';
			objRec.OperSttDate = '';
			objRec.OperSttTime = '';
			objRec.OperEndDate = '';
			objRec.OperEndTime = '';
			objRec.OperatorID = '';
			objRec.OperatorName = '';
			objRec.Ass1ID = '';
			objRec.Ass1Name = '';
			objRec.Ass2ID = '';
			objRec.Ass2Name = '';
			objRec.NarTypeID = '';
			objRec.NarTypeDesc = '';
			objRec.NarDocID = '';
			objRec.NarDocName = '';
			objRec.CutTypeID = '';
			objRec.CutTypeDesc = '';
			objRec.HealingID = '';
			objRec.HealingDesc = '';
			objRec.OperLevelID = '';
			objRec.OperLevelDesc = '';
			objRec.DataSource = '';
			objRec.EprRowNo = '';
		}
		
		objRec.TypeID = Common_GetValue("FPO_RowEditor_Type");
		objRec.TypeDesc = Common_GetText("FPO_RowEditor_Type");
		if ((objRec.TypeID == '-')&&(objRec.TypeDesc == '-')){
			objRec.TypeID = '';
			objRec.TypeDesc = '';
		}
		objRec.ICD10 = Common_GetValue("FPO_RowEditor_ICD10");
		objRec.ICDID = obj.FPO_RowEditor.ICDId;
		objRec.ICDDesc = obj.FPO_RowEditor.ICDTxt;
		if (objRec.ICDDesc != Common_GetText("FPO_RowEditor_ICD")){
			objRec.ICDID = '';
		}
		objRec.OperSttDate = Common_GetValue("FPO_RowEditor_OperDate");
		objRec.OperatorID = obj.FPO_RowEditor.OperatorId;
		objRec.OperatorName = obj.FPO_RowEditor.OperatorTxt;
		if (objRec.OperatorName != Common_GetText("FPO_RowEditor_Operator")){
			objRec.OperatorID = '';
			objRec.OperatorName = '';  //update zf 20150331 姓名删除不掉
		}
		objRec.Ass1ID = obj.FPO_RowEditor.Ass1Id;
		objRec.Ass1Name = obj.FPO_RowEditor.Ass1Txt;
		if (objRec.Ass1Name != Common_GetText("FPO_RowEditor_Ass1")){
			objRec.Ass1ID = '';
			objRec.Ass1Name = '';  //update zf 20150331 姓名删除不掉
		}
		objRec.Ass2ID = obj.FPO_RowEditor.Ass2Id;
		objRec.Ass2Name = obj.FPO_RowEditor.Ass2Txt;
		if (objRec.Ass2Name != Common_GetText("FPO_RowEditor_Ass2")){
			objRec.Ass2ID = '';
			objRec.Ass2Name = '';  //update zf 20150331 姓名删除不掉
		}
		objRec.NarTypeID = Common_GetValue("FPO_RowEditor_NarType");
		objRec.NarTypeDesc = Common_GetText("FPO_RowEditor_NarType");
		if ((objRec.NarTypeID == '-')&&(objRec.NarTypeDesc == '-')){
			objRec.NarTypeID = '';
			objRec.NarTypeDesc = '';
		}
		objRec.NarDocID = obj.FPO_RowEditor.NarDocId;
		objRec.NarDocName = obj.FPO_RowEditor.NarDocTxt;
		if (objRec.NarDocName != Common_GetText("FPO_RowEditor_NarDoc")){
			objRec.NarDocID = '';
			objRec.NarDocName = '';  //update zf 20150331 姓名删除不掉
		}
		objRec.CutTypeID = Common_GetValue("FPO_RowEditor_CutType");
		objRec.CutTypeDesc = Common_GetText("FPO_RowEditor_CutType");
		if ((objRec.CutTypeID == '-')&&(objRec.CutTypeDesc == '-')){
			objRec.CutTypeID = '';
			objRec.CutTypeDesc = '';
		}
		objRec.HealingID = Common_GetValue("FPO_RowEditor_Healing");
		objRec.HealingDesc = Common_GetText("FPO_RowEditor_Healing");
		if ((objRec.HealingID == '-')&&(objRec.HealingDesc == '-')){
			objRec.HealingID = '';
			objRec.HealingDesc = '';
		}
		objRec.OperLevelID = Common_GetValue("FPO_RowEditor_OperLevel");
		objRec.OperLevelDesc = Common_GetText("FPO_RowEditor_OperLevel");
		if ((objRec.OperLevelID == '-')&&(objRec.OperLevelDesc == '-')){
			objRec.OperLevelID = '';
			objRec.OperLevelDesc = '';
		}
		
		return objRec;
	}
}