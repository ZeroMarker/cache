if (!((!!window.ActiveXObject || "ActiveXObject" in window))){
	HTMLElement.prototype.moveRow = function(srcIdx, targetIdx,f){
		if (f==1){
			srcIdx--;
			targetIdx--;
		}
        var re = /^(table|tbody|tfoot|thead)/i;
        if(!re.test(this.nodeName) || srcIdx === targetIdx) return;
        var pNode, srcR,targetR;
        pNode = this;
        if(this.nodeName.toLowerCase() === 'table') pNode = this.getElementsByTagName('tbody')[1]; //firefox 自动插入tbody
        //targetIdx<srcIdx 行往前面移 直接pNode.insertBefore()即可
        
        srcR = pNode.rows[srcIdx];
        targetR = pNode.rows[targetIdx];
        if(!srcR || !targetR) return; //索引范围以外 则返回
        targetRnext = pNode.rows[targetIdx+1] || null;
        if(targetIdx < srcIdx) pNode.insertBefore(srcR, targetR);
        if(targetIdx > srcIdx) pNode.insertBefore(srcR, targetRnext);
    };
}

    
function InitFPDiagnos(obj){
	obj.FPD_RowIndex = 0;
	obj.FPD_RowEditor = new Object();
	obj.FPD_DSQuery = new Array();
	obj.FPD_FPQuery = new Array();
	
	obj.FPD_InitView = function(){
		obj.FPD_RowEditor.No = FP_NumberField("FPD_RowEditor_No","序号");
		obj.FPD_RowEditor.Type = FP_ComboDic("FPD_RowEditor_Type","诊断类型","FPICDType");
		obj.FPD_RowEditor.ICD10 = FP_TextField("FPD_RowEditor_ICD10","ICD10");
		obj.FPD_RowEditor.ICD = FP_ICDSelect("FPD_RowEditor_ICD","诊断名称",obj.FrontPage.FPItemID,"FPD_RowEditor_Type");
		obj.FPD_RowEditor.ICDId = '';
		obj.FPD_RowEditor.ICDTxt = '';
		obj.FPD_RowEditor.AdmitCond = FP_ComboDic("FPD_RowEditor_AdmitCond","入院病情","DiseaseResult");
		obj.FPD_RowEditor.IsDefinite = FP_ComboDic("FPD_RowEditor_IsDefinite","是否确诊","QuestionDiagnose");
		obj.FPD_RowEditor.No.setDisabled(true);
		obj.FPD_RowEditor.ICD10.setDisabled(true);
		obj.FPD_RowEditor.ICD.on('select',obj.FPD_RowEditor_ICD_select,obj);
		
		obj.FPD_btnSave = new Ext.Button({
			id : 'FPD_btnSave'
			,icon: '../scripts/dhcwmr/img/update.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">保存</span>'
			,renderTo : 'FPD_btnSave'
			,width : 70
			,anchor : '100%'
		});
		obj.FPD_btnCopy = new Ext.Button({
			id : 'FPD_btnCopy'
			,icon: '../scripts/dhcwmr/img/copy.ico'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">复制</span>'
			,renderTo : 'FPD_btnCopy'
			,width : 70
			,anchor : '100%'
		});
		obj.FPD_btnDelete = new Ext.Button({
			id : 'FPD_btnDelete'
			,icon: '../scripts/dhcwmr/img/delete.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">删除</span>'
			,renderTo : 'FPD_btnDelete'
			,width : 70
			,anchor : '100%'
		});
		obj.FPD_btnMoveUp = new Ext.Button({
			id : 'FPD_btnMoveUp'
			,icon: '../scripts/dhcwmr/img/moveup.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">上移</span>'
			,renderTo : 'FPD_btnMoveUp'
			,width : 70
			,anchor : '100%'
		});
		obj.FPD_btnMoveDown = new Ext.Button({
			id : 'FPD_btnMoveDown'
			,icon: '../scripts/dhcwmr/img/movedown.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">下移</span>'
			,renderTo : 'FPD_btnMoveDown'
			,width : 70
			,anchor : '100%'
		});
		obj.FPD_btnFindICD = new Ext.Button({
			id : 'FPD_btnFindICD'
			,icon: '../scripts/dhcwmr/img/find.gif'
			,text : '<span style="font-weight:bold;color:#457294;font-size:14;">ICD检索</span>'
			,renderTo : 'FPD_btnFindICD'
			,width : 90
			,anchor : '100%'
		});
		
		obj.FPD_btnFindICD.on('click',obj.FPD_btnFindICD_onclick,obj);
		obj.FPD_btnSave.on('click',obj.FPD_btnSave_onclick,obj);
		obj.FPD_btnCopy.on('click',obj.FPD_btnCopy_onclick,obj);
		obj.FPD_btnDelete.on('click',obj.FPD_btnDelete_onclick,obj);
		obj.FPD_btnMoveUp.on('click',obj.FPD_btnMoveUp_onclick,obj);
		obj.FPD_btnMoveDown.on('click',obj.FPD_btnMoveDown_onclick,obj);
		Common_SetDisabled("FPD_btnDelete",true);
		Common_SetDisabled("FPD_btnMoveUp",true);
		Common_SetDisabled("FPD_btnMoveDown",true);
		
		obj.FPD_LoadDSQuery();	//加载首页诊断列表
		obj.FPD_LoadFPQuery();	//加载编目诊断列表
		if (obj.FrontPage.FrontPageID == ''){
			for (var row = 0; row < obj.FPD_DSQuery.length; row++){
				var record = obj.FPD_DSQuery[row];
				var newIndex = obj.FPD_FPQuery.length;
				obj.FPD_FPQuery[newIndex]=record;
			}
		}
		obj.FPD_DSTemplate.overwrite("divDiagnos-DS",obj.FPD_DSQuery);	//显示首页诊断列表
		obj.FPD_FPTemplate.overwrite("divDiagnos-FP",obj.FPD_FPQuery);	//显示编目诊断列表
	}
	
	obj.FPD_DSTemplate = new Ext.XTemplate(
		'<table id="FPD_DSTable" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#00AEAE;text-align:center;width:100%;">',
			'<tr style="font-size:13px;height:30px;font-weight:bold;">',
				'<td align="center" width="3%">序号</td>',
				'<td align="center" width="10%">诊断类型</td>',
				'<td align="center" width="5%">ICD10</td>',
				'<td align="center" width="20%">诊断名称</td>',
				'<td align="center" width="10%">入院病情</td>',
				'<td align="center" width="10%">是否确诊</td>',
			'</tr>',
			'<tbody>',
				'<tpl for=".">',
					'<tr {[this.trEvent()]} class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">',
						'<td {[this.tdEvent()]} align="center">{[xindex]}</td>',
						'<td {[this.tdEvent()]} align="center">{TypeDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{ICD10}</td>',
						'<td {[this.tdEvent()]} align="left">{ICDDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{AdmitCondDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{IsDefiniteDesc}</td>',
					'</tr>',
				'</tpl>',
			'</tbody>',
		'</table>',
		{
			trEvent : function(){
				var tabEv = '';
				tabEv += ' ondblclick="objScreen.FPD_DSTable_Rowdblclick(this);"'
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
	
	obj.FPD_FPTemplate = new Ext.XTemplate(
		'<table id="FPD_FPTable" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;width:100%;">',
			'<tr style="font-size:13px;height:30px;font-weight:bold;">',
				'<td align="center" width="3%">序号</td>',
				'<td align="center" width="10%">诊断类型</td>',
				'<td align="center" width="5%">ICD10</td>',
				'<td align="center" width="20%">诊断名称</td>',
				'<td align="center" width="10%">入院病情</td>',
				'<td align="center" width="10%">是否确诊</td>',
			'</tr>',
			'<tbody>',
				'<tpl for=".">',
					'<tr {[this.trEvent()]} class="{[ (xindex % 2 === 1 ? \"RowEven\" : \"RowOdd\")]}">',
						'<td {[this.tdEvent()]} align="center">{[xindex]}</td>',
						'<td {[this.tdEvent()]} align="center">{[this.tdError(values.TypeID,values.TypeDesc)]} {TypeDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{ICD10}</td>',
						'<td {[this.tdEvent()]} align="left">{[this.tdError(values.ICDID,values.ICDDesc)]} {ICDDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{[this.tdError(values.AdmitCondID,values.AdmitCondDesc)]} {AdmitCondDesc}</td>',
						'<td {[this.tdEvent()]} align="center">{[this.tdError(values.IsDefiniteID,values.IsDefiniteDesc)]} {IsDefiniteDesc}</td>',
					'</tr>',
				'</tpl>',
				'<tr class="RowEven" style="border-bottom:1px #BDBDBD solid;">',
					'<td align="center"><div id="Cmp_FPD_RowEditor_No" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPD_RowEditor_Type" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPD_RowEditor_ICD10" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="left"><div id="Cmp_FPD_RowEditor_ICD" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPD_RowEditor_AdmitCond" style="width:100%;overflow:hidden;"></div></td>',
					'<td align="center"><div id="Cmp_FPD_RowEditor_IsDefinite" style="width:100%;overflow:hidden;"></div></td>',
				'</tr>',
			'</tbody>',
		'</table>',
		{
			trEvent : function(){
				var tabEv = '';
				tabEv += ' onclick="objScreen.FPD_FPTable_Rowclick(this);"'
				tabEv += ' onmousedown="objScreen.FPD_RowMouseDown(this);"'
				//tabEv += ' onmousemove="objScreen.FPD_RowMouseMove(this);"'
				tabEv += ' onmouseup="objScreen.FPD_RowMouseUp(this);"'
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
	
	obj.FPD_LoadDSQuery = function(){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FPService.FPDiagnosSrv'
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
			
			obj.FPD_DSQuery.length = 0;
			obj.FPD_DSQuery = arryData;
			return true;
		} else {
			ExtTool.alert("提示","加载诊断数据错误!");
			return false;
		}
	}
	
	obj.FPD_LoadFPQuery = function(){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FPService.FPDiagnosSrv'
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
			
			obj.FPD_FPQuery.length = 0;
			obj.FPD_FPQuery = arryData;
			return true;
		} else {
			ExtTool.alert("提示","加载诊断数据错误!");
			return false;
		}
	}
	
	obj.FPD_AddNewTableRow = function(record){
		var _table = document.getElementById("FPD_FPTable");
		var _row = _table.insertRow(-1);
		_row.setAttribute("class", (_row.rowIndex % 2 === 1 ? "RowEven" : "RowOdd"));
		_row.setAttribute("className", (_row.rowIndex % 2 === 1 ? "RowEven" : "RowOdd"));
		_row.style.backgroundColor = '';
		_row.style.fontsize = '13px';
		_row.style.height = '30px';
		_row.onclick = function(){obj.FPD_FPTable_Rowclick(this);};
		_row.onmousedown = function(){obj.FPD_RowMouseDown(this);};
		_row.onmousemove = function(){obj.FPD_RowMouseMove(this);};
		_row.onmouseup = function(){obj.FPD_RowMouseUp(this);};
		
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
		_row.cells[4].innerHTML = record.AdmitCondDesc;
		_row.cells[5].innerHTML = record.IsDefiniteDesc;
		
		_row = _row.parentElement.moveRow(_row.rowIndex-2,_row.rowIndex-1,2);	//调整行位置
		
	}
	
	obj.FPD_DSTable_Rowdblclick = function(_row){
		var rowIndex = _row.rowIndex;
		var objRec = obj.FPD_DSQuery[rowIndex-1];
		var newIndex = obj.FPD_FPQuery.length + 1;
		obj.FPD_FPQuery[newIndex-1] = objRec;
		obj.FPD_AddNewTableRow(objRec);  //***添加空白行
		obj.FPD_SelectRow(newIndex);  //选中行
	}
	
	obj.FPD_FPTable_Rowclick = function(_row){
		var rowIndex = _row.rowIndex;
		obj.FPD_SelectRow(rowIndex);  //选中行
	}
	
	obj.FPD_btnFindICD_onclick = function(){
		var TypeID = Common_GetValue('FPD_RowEditor_Type');
		if (TypeID == ''){
			ExtTool.alert('提示', '请先输入诊断类型!');
			return;
		}
		var ICDAlias = Common_GetText('FPD_RowEditor_ICD');
		var win = new FP_FindICDWin(ICDAlias,TypeID,'FPD_RowEditor_ICD');
	}
	
	obj.FPD_btnSave_onclick = function(){
		//保存控制
		var TypeDesc = Common_GetText("FPD_RowEditor_Type");
		var ICDDesc  = Common_GetText("FPD_RowEditor_ICD");
		if ((TypeDesc == '')&&(ICDDesc == '')) {
			ExtTool.alert('提示', '类型和诊断名称为空,不允许保存!');
			return;
		}
		
		//保存行数据
		var rowIndex = Common_GetValue("FPD_RowEditor_No");
		if (rowIndex) {
			rowIndex = rowIndex*1;
			var objRec = obj.FPD_FPQuery[rowIndex-1];
			objRec = obj.FPD_GetRecord(objRec);  //获取记录值
		} else {
			rowIndex = obj.FPD_FPQuery.length + 1;
			var objRec = obj.FPD_GetRecord();  //获取记录值
			obj.FPD_AddNewTableRow(objRec);  //***添加空白行
		}
		obj.FPD_FPQuery[rowIndex-1] = objRec;
		
		//更新行显示
		var _table = document.getElementById("FPD_FPTable");
		_row = _table.rows[rowIndex];
		_row.cells[1].innerHTML = (((objRec.TypeID == '')&&(objRec.TypeDesc != '')) ? '@' : '') + objRec.TypeDesc;
		_row.cells[2].innerHTML = objRec.ICD10;
		_row.cells[3].innerHTML = (objRec.ICDID == '' ? '@' : '') + objRec.ICDDesc;
		_row.cells[4].innerHTML = (((objRec.AdmitCondID == '')&&(objRec.AdmitCondDesc != '')) ? '@' : '') + objRec.AdmitCondDesc;
		_row.cells[5].innerHTML = (((objRec.IsDefiniteID == '')&&(objRec.IsDefiniteDesc != '')) ? '@' : '') + objRec.IsDefiniteDesc;
		
		obj.FPD_RowIndex = rowIndex;
		if (rowIndex < (_table.rows.length-2)){
			obj.FPD_RowMoveDown();  //自动选择下一行
		} else {
			obj.FPD_SetTabStyle();  //初始化Table样式及行号
			obj.FPD_ClearForms();   //清空表单元素内容
		}
		
		//获取焦点延迟300毫秒执行
		setTimeout('objScreen.FPD_RowEditor_focus(1)',300);
	}
	
	obj.FPD_btnCopy_onclick = function(){
		var arrQuery = obj.FPD_FPQuery;
		if (arrQuery.length<1) return;
		//update by zhouruimeng 2015-03-17修改复制时复制最后一条，改为复制选中的那一条
		//var objRec = arrQuery[arrQuery.length-1];
		var rowIndex = obj.FPD_RowIndex;
		var objRec = arrQuery[rowIndex-1];
		
		obj.FPD_SetTabStyle();  //初始化Table样式及行号
		obj.FPD_ClearForms();   //清空表单元素内容
		
		Common_SetValue("FPD_RowEditor_No","");
		Common_SetValue("FPD_RowEditor_Type",objRec.TypeID,objRec.TypeDesc);
		Common_SetValue("FPD_RowEditor_AdmitCond",objRec.AdmitCondID,objRec.AdmitCondDesc);
		Common_SetValue("FPD_RowEditor_IsDefinite",objRec.IsDefiniteID,objRec.IsDefiniteDesc);
		
		//获取焦点延迟300毫秒执行
		setTimeout('objScreen.FPD_RowEditor_focus(2)',300);
	}
	obj.FPD_btnDelete_onclick = function(){
		var rowIndex = obj.FPD_RowIndex;
		Ext.MessageBox.confirm('删除', '是否删除当前记录?', function(btn,text){
			if(btn=="yes"){
				//删除行
				var _table = document.getElementById("FPD_FPTable");
				var _row = _table.rows[rowIndex];
				_row.parentNode.removeChild(_row);
				
				//删除数据行
				obj.FPD_FPQuery.splice(rowIndex-1,1); //删除数据项
				
				obj.FPD_SetTabStyle(); //初始化Table样式及行号
				obj.FPD_ClearForms(); //清空表单元素内容
				
				//获取焦点延迟300毫秒执行
				setTimeout('objScreen.FPD_RowEditor_focus(1)',300);
			}
		});
	}
	
	obj.FPD_btnMoveUp_onclick = function(){
		var rowIndex = obj.FPD_RowIndex;
		var _table = document.getElementById("FPD_FPTable");
		if (rowIndex<=1) return;  //第一行退出
		
		var _row = _table.moveRow(rowIndex,rowIndex-1,1);  //移动行(上移)
	
		var dataIndex = rowIndex-1;
		var objRec = obj.FPD_FPQuery[dataIndex-1];  //移动数据行(上移)
		obj.FPD_FPQuery[dataIndex-1] = obj.FPD_FPQuery[dataIndex];
		obj.FPD_FPQuery[dataIndex] = objRec;
		obj.FPD_SelectRow(rowIndex-1);  //选中行
	}
	
	obj.FPD_btnMoveDown_onclick = function(){
		var rowIndex = obj.FPD_RowIndex;
		var _table = document.getElementById("FPD_FPTable");
		if (rowIndex >= _table.rows.length-2) return;  //最后一行退出
		var _row = _table.moveRow(rowIndex,rowIndex+1,1);  //移动行(下移)
		
		var dataIndex = rowIndex-1;
		var objRec = obj.FPD_FPQuery[dataIndex+1];  //移动数据行(下移)
		obj.FPD_FPQuery[dataIndex+1] = obj.FPD_FPQuery[dataIndex];
		obj.FPD_FPQuery[dataIndex] = objRec;
		
		obj.FPD_SelectRow(rowIndex+1); //选中行
	}
	
	var beginMoving = false;
	obj.FPD_RowMouseDown = function(_row){
		obj.FPD_SetTabStyle(); //初始化Table样式及行号
		_row.style.backgroundColor = '#FF9797';
		_row.style.zIndex = 1;
		_row.mouseDownY = event.clientY;
		_row.mouseDownX = event.clientX;
		beginMoving = true;
		event.srcElement.setCapture();
	}
	obj.FPD_RowMouseMove = function(_row){
		if(!beginMoving) return false;
		_row.style.top = (event.clientY-_row.mouseDownY);
		_row.style.left = (event.clientX-_row.mouseDownX);
	}
	obj.FPD_RowMouseUp = function(_row){
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
		var objRec = obj.FPD_FPQuery[dataIndex];  //移动数据行(拖动)
		if (dataIndex<tmpDataIndex){
			for (var indData = dataIndex; indData < tmpDataIndex; indData++){
				obj.FPD_FPQuery[indData] = obj.FPD_FPQuery[indData+1];
			}
		} else {
			for (var indData = dataIndex; indData > tmpDataIndex; indData--){
				obj.FPD_FPQuery[indData] = obj.FPD_FPQuery[indData-1];
			}
		}
		obj.FPD_FPQuery[tmpDataIndex] = objRec;
		
		obj.FPD_SelectRow(tempRowIndex);  //选中行
	}
	
	obj.FPD_SetTabStyle = function(){
		var _table = document.getElementById("FPD_FPTable");
		for (var row = 1; row < _table.rows.length - 1; row++){
			var cls = (row % 2 === 1 ? "RowEven" : "RowOdd");
			_table.rows[row].setAttribute("class", cls);
			_table.rows[row].setAttribute("className", cls);
			_table.rows[row].style.backgroundColor = '';
			_table.rows[row].cells[0].innerText = row;
		}
	}
	
	obj.FPD_SelectRow = function(rowIndex){
		obj.FPD_RowIndex = rowIndex;
		Common_SetDisabled("FPD_btnDelete",false);
		Common_SetDisabled("FPD_btnMoveUp",false);
		Common_SetDisabled("FPD_btnMoveDown",false);
		
		var arrQuery = obj.FPD_FPQuery;
		var objRec = arrQuery[rowIndex-1];
		
		Common_SetValue("FPD_RowEditor_No",rowIndex);
		Common_SetValue("FPD_RowEditor_Type",objRec.TypeID,objRec.TypeDesc);
		Common_SetValue("FPD_RowEditor_ICD10",objRec.ICD10);
		Common_SetValue("FPD_RowEditor_ICD",objRec.ICDID,objRec.ICDDesc);
		obj.FPD_RowEditor.ICDId = objRec.ICDID;
		obj.FPD_RowEditor.ICDTxt = objRec.ICDDesc;
		Common_SetValue("FPD_RowEditor_AdmitCond",objRec.AdmitCondID,objRec.AdmitCondDesc);
		Common_SetValue("FPD_RowEditor_IsDefinite",objRec.IsDefiniteID,objRec.IsDefiniteDesc);
		
		var _table = document.getElementById("FPD_FPTable");
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
		setTimeout('objScreen.FPD_RowEditor_focus(1)',300);
	}
	
	obj.FPD_RowEditor_focus = function(col){
		if (col ==1){
			var cmp = Ext.getCmp('FPD_RowEditor_Type');
			if (cmp) cmp.focus(); //光标定位
		} else if (col == 2) {
			var cmp = Ext.getCmp('FPD_RowEditor_ICD');
			if (cmp) cmp.focus(); //光标定位
		}
	}
	
	obj.FPD_RowMoveDown = function(){
		var rowIndex = obj.FPD_RowIndex;
		var _table = document.getElementById("FPD_FPTable");
		if (rowIndex >= (_table.rows.length-3)) rowIndex = _table.rows.length - 3;
		obj.FPD_SelectRow(rowIndex+1);  //选中行
	}
	
	obj.FPD_ClearForms = function(){
		obj.FPD_RowIndex = 0;
		Common_SetValue("FPD_RowEditor_No","");
		Common_SetValue("FPD_RowEditor_Type","","");
		Common_SetValue("FPD_RowEditor_ICD10","");
		Common_SetValue("FPD_RowEditor_ICD","","");
		obj.FPD_RowEditor.ICDId = '';
		obj.FPD_RowEditor.ICDTxt = '';
		Common_SetValue("FPD_RowEditor_AdmitCond","","");
		Common_SetValue("FPD_RowEditor_IsDefinite","","");
		
		Common_SetDisabled("FPD_btnDelete",true);
		Common_SetDisabled("FPD_btnMoveUp",true);
		Common_SetDisabled("FPD_btnMoveDown",true);
	}
	
	obj.FPD_RowEditor_ICD_select = function(cb,rd,ind){
		Common_SetValue("FPD_RowEditor_ICD10",rd.get('ICD10'));
		obj.FPD_RowEditor.ICDId = cb.getValue();
		obj.FPD_RowEditor.ICDTxt = cb.getRawValue();
	}
	
	//获取诊断编目结果
	obj.FPD_GetInput = function(tmpFlag){
		var strResult = '';
		var arrResult = obj.FPD_FPQuery;
		for (var ind = 0; ind < arrResult.length; ind++){
			var strTemp = '';
			var record = arrResult[ind];
			if (tmpFlag != 1){
				strTemp = record.TypeID
				strTemp += '^' + record.TypeDesc
				strTemp += '^' + record.ICDID
				strTemp += '^' + record.ICD10
				strTemp += '^' + record.ICDDesc
				strTemp += '^' + record.AdmitCondID
				strTemp += '^' + record.AdmitCondDesc
				strTemp += '^' + record.DischCondID
				strTemp += '^' + record.DischCondDesc
				strTemp += '^' + record.IsDefiniteID
				strTemp += '^' + record.IsDefiniteDesc
			}
			
			if (strResult != '') strResult += CHR_1
			strResult += obj.FrontPage.FrontPageID
			strResult += CHR_2 + record.FPSubID
			strResult += CHR_2 + (ind+1)  //record.RowIndex
			strResult += CHR_2 + record.ICDID
			strResult += CHR_2 + record.TypeID
			strResult += CHR_2 + record.AdmitCondID
			strResult += CHR_2 + record.DischCondID
			strResult += CHR_2 + record.IsDefiniteID
			strResult += CHR_2 + record.DataSource
			strResult += CHR_2 + strTemp
		}
		return strResult;
	}
	
	//校验编目输入内容
	obj.FPD_CheckInput = function(){
		var errInfo = '';
		var sex = document.getElementById('txtSex').innerText;
		var isMainDiagnos = 0;		//是否编主要诊断
		var isMainTumor = 0;	    //主要诊断是否恶性肿瘤
		var isTumorCode = 0;		//是否编病理诊断(主要诊断为恶性肿瘤时需要)
		var isTumorErr = 0;			//病理诊断诊断ICD（M打头）
		var isMainInjury = 0;		//是否损伤中毒诊断
		var isInjuryCode = 0;		//是否编损伤中毒(主要诊断为意外伤害时需要)
		var isInjuryErr = 0;		//损伤中毒诊断ICD（V、W、X、Y打头）
		var isMainErr = 0;			//主要诊断错误
		var isOtherErr = 0;			//其他诊断错误
		//add by liyi 2016-04-19 增加编目质控
		var isMaleErr = 0;			//男性患者诊断是否出现N70-N77,N80-N98的编码
		var isOutInDigErr1 = 0;		//入院和门急诊诊断中是否使用B95-B97的编码
		var isOutInDigErr2 = 0;		//入院和门急诊诊断中是否使用V、W、X、Y的编码和M****/*形式编码
		var isMainIsO00_O08= 0;		//主要诊断编码是否为O00-O08
		var isOtherZ37	   = 0;		//其他诊断是否为Z37的编码
		var isMainIsO80_O84= 0;		//主要诊断编码是否为O80-O84
		var arrResult = obj.FPD_FPQuery;
		for (var ind = 0; ind < arrResult.length; ind++){
			var rowErr = '';
			var record = arrResult[ind];
			if (record.TypeID == '') rowErr += '___诊断类型不允许为空!'
			if (record.ICDID == '') rowErr += '___诊断编码不允许为空!'
			var ICD10Head = record.ICD10.substring(0,1);
			
			if (record.TypeDesc == '主要诊断') {
				isMainDiagnos++;
				if ((record.ICD10>'C0')&&(record.ICD10<'D49')) isMainTumor++;
				if ((ICD10Head=='S')||(ICD10Head=='T')) isMainInjury++;
				if ((ICD10Head=='V')||(ICD10Head=='W')||(ICD10Head=='X')||(ICD10Head=='Y')) isMainErr++;
				if ((ICD10Head=='M')&&(record.ICD10.indexOf('/')>-1)) isMainErr++;
				if (record.AdmitCondID == '') rowErr += '___入院病情不允许为空!'
			} else if (record.TypeDesc == '病理诊断') {
				isTumorCode++;
				if (((ICD10Head!='M'))||(record.ICD10.indexOf('/')<0)) isTumorErr++;
			} else if (record.TypeDesc == '损伤中毒诊断') {
				isInjuryCode++;
				if ((ICD10Head!='V')&&(ICD10Head!='W')&&(ICD10Head!='X')&&(ICD10Head!='Y')) isInjuryErr++;
			} else if (record.TypeDesc == '门急诊诊断') {
				if ((ICD10Head=='V')||(ICD10Head=='W')||(ICD10Head=='X')||(ICD10Head=='Y')) isOtherErr++;
				if ((ICD10Head=='M')&&(record.ICD10.indexOf('/')>-1)) isOtherErr++;
			} else {
				if ((ICD10Head=='V')||(ICD10Head=='W')||(ICD10Head=='X')||(ICD10Head=='Y')) isOtherErr++;
				if ((ICD10Head=='M')&&(record.ICD10.indexOf('/')>-1)) isOtherErr++;
				if (record.AdmitCondID == '') rowErr += '___入院病情不允许为空!'
			}
			
			if (record.IsDefiniteID == '') rowErr += '___是否确诊不允许为空!'
			if (rowErr != '') errInfo += '<br>行 ' + (ind+1) + ' 提示：' + rowErr;
			
			//add by liyi 2016-04-19 增加编目质控
			if ((sex.indexOf('男')>-1)||(sex.indexOf('男性')>-1)){
				if ((record.ICD10.indexOf('N70')>-1)||(record.ICD10.indexOf('N71')>-1)
				   ||(record.ICD10.indexOf('N72')>-1)||(record.ICD10.indexOf('N73')>-1)
				   ||(record.ICD10.indexOf('N74')>-1)||(record.ICD10.indexOf('N75')>-1)
				   ||(record.ICD10.indexOf('N76')>-1)||(record.ICD10.indexOf('N77')>-1))
					isMaleErr = 1;
				if ((record.ICD10.indexOf('N80')>-1)||(record.ICD10.indexOf('N81')>-1)
				   ||(record.ICD10.indexOf('N82')>-1)||(record.ICD10.indexOf('N83')>-1)
				   ||(record.ICD10.indexOf('N84')>-1)||(record.ICD10.indexOf('N85')>-1)
				   ||(record.ICD10.indexOf('N86')>-1)||(record.ICD10.indexOf('N87')>-1)
				   ||(record.ICD10.indexOf('N88')>-1)||(record.ICD10.indexOf('N89')>-1)
				   ||(record.ICD10.indexOf('N90')>-1)||(record.ICD10.indexOf('N91')>-1)
				   ||(record.ICD10.indexOf('N92')>-1)||(record.ICD10.indexOf('N93')>-1)
				   ||(record.ICD10.indexOf('N94')>-1)||(record.ICD10.indexOf('N95')>-1)
				   ||(record.ICD10.indexOf('N96')>-1)||(record.ICD10.indexOf('N97')>-1)
				   ||(record.ICD10.indexOf('N98')>-1))
					isMaleErr = 1;
			}
			if ((record.TypeDesc == '门急诊诊断')||(record.TypeDesc == '入院诊断')){
				if ((record.ICD10.indexOf('B95')>-1)||(record.ICD10.indexOf('B96')>-1)||(record.ICD10.indexOf('B97')>-1))
					isOutInDigErr1 = 1;
				if ((ICD10Head=='V')||(ICD10Head=='W')||(ICD10Head=='X')||(ICD10Head=='Y') 
					||((ICD10Head=='M')&&(record.ICD10.indexOf('/')>-1)))
					isOutInDigErr2 = 1;
			}
			if (record.TypeDesc == '主要诊断') {
				if ((record.ICD10.indexOf('O00')>-1)||(record.ICD10.indexOf('O01')>-1)
				   ||(record.ICD10.indexOf('O02')>-1)||(record.ICD10.indexOf('O03')>-1)
				   ||(record.ICD10.indexOf('O04')>-1)||(record.ICD10.indexOf('O05')>-1)
				   ||(record.ICD10.indexOf('O06')>-1)||(record.ICD10.indexOf('O07')>-1)
				   ||(record.ICD10.indexOf('O08')>-1))
				isMainIsO00_O08 = 1;
			}
			if (record.TypeDesc == '次要诊断') {
				if (record.ICD10.indexOf('Z37')>-1)
				isOtherZ37 = 1;
			}
			if (record.TypeDesc == '主要诊断') {
				if ((record.ICD10.indexOf('O80')>-1)||(record.ICD10.indexOf('O81')>-1)
				   ||(record.ICD10.indexOf('O82')>-1)||(record.ICD10.indexOf('O83')>-1)
				   ||(record.ICD10.indexOf('O84')>-1))
				isMainIsO80_O84 = 1;
			}
		}
		if (isMainDiagnos<1) errInfo += '<br>缺少主要诊断!'
		if (isMainDiagnos>1) errInfo += '<br>主要诊断重复(只允许有一个主要诊断)!'
		if ((isMainTumor>0)&&(isTumorCode<1)) errInfo += '<br>缺少病理诊断!'
		if ((isMainInjury>0)&&(isInjuryCode<1)) errInfo += '<br>缺少损伤中毒诊断!'
		if (isMainErr>0) errInfo += '<br>主要诊断ICD错误!'
		if (isOtherErr>0) errInfo += '<br>其他诊断ICD错误!'
		if (isTumorErr>0) errInfo += '<br>病理诊断ICD错误!'
		if (isInjuryErr>0) errInfo += '<br>损伤中毒诊断ICD错误!'
		//add by liyi 2016-04-19 增加编目质控
		if (isMaleErr>0) errInfo += '<br>男性患者诊断不能使用N70-N77,N80-N98的编码!'
		if (isOutInDigErr1>0) errInfo += '<br>入院和门急诊诊断中不能使用B95-B97的编码!'
		if (isOutInDigErr2>0) errInfo += '<br>入院和门急诊诊断中不能使用V、W、X、Y的编码和M****/*形式编码!'
		if ((isMainIsO00_O08>0)&&(isOtherZ37>0)) errInfo += '<br>主要诊断编码为O00-O08，次要诊断不能使用Z37的编码!'
		if ((isMainIsO80_O84>0)&&(isOtherZ37<1)) errInfo += '<br>主要诊断或其他诊断编码为O80-O84，其他诊断中必须有Z37的编码!'
		return errInfo;
	}
	
	obj.FPD_GetRecord = function(objRec){
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
			objRec.AdmitCondID = '';
			objRec.AdmitCondDesc = '';
			objRec.DischCondID = '';
			objRec.DischCondDesc = '';
			objRec.IsDefiniteID = '';
			objRec.IsDefiniteDesc = '';
			objRec.DataSource = '';
			objRec.EprRowNo = '';
		}
		
		objRec.TypeID = Common_GetValue("FPD_RowEditor_Type");
		objRec.TypeDesc = Common_GetText("FPD_RowEditor_Type");
		if ((objRec.TypeID == '-')&&(objRec.TypeDesc == '-')){
			objRec.TypeID = '';
			objRec.TypeDesc = '';
		}
		objRec.ICD10 = Common_GetValue("FPD_RowEditor_ICD10");
		objRec.ICDID = obj.FPD_RowEditor.ICDId;
		objRec.ICDDesc = obj.FPD_RowEditor.ICDTxt;
		if (objRec.ICDDesc != Common_GetText("FPD_RowEditor_ICD")){
			objRec.ICDID = '';
		}
		objRec.AdmitCondID = Common_GetValue("FPD_RowEditor_AdmitCond");
		objRec.AdmitCondDesc = Common_GetText("FPD_RowEditor_AdmitCond");
		if ((objRec.AdmitCondID == '-')&&(objRec.AdmitCondDesc == '-')){
			objRec.AdmitCondID = '';
			objRec.AdmitCondDesc = '';
		}
		objRec.IsDefiniteID = Common_GetValue("FPD_RowEditor_IsDefinite");
		objRec.IsDefiniteDesc = Common_GetText("FPD_RowEditor_IsDefinite");
		if ((objRec.IsDefiniteID == '-')&&(objRec.IsDefiniteDesc == '-')){
			objRec.IsDefiniteID = '';
			objRec.IsDefiniteDesc = '';
		}
		
		return objRec;
	}
}