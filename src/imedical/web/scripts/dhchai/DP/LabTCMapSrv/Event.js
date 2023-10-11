//页面Event
function InitLabTCMapWinEvent(obj){
	$('#layer_one').dialog({
			title: '检验项目编辑',
			iconCls:"icon-w-paper",
			closed: true,
			modal: true,
			isTopZindex:true
		});
		var p = $('#gridLabTCMap').datagrid('getPager');
	    if (p){
	        $(p).pagination({ //设置分页功能栏
	           //分页功能可以通过Pagination的事件调用后台分页功能来实现
	        	onRefresh:function(){
		        	$("#btnEdit_one").linkbutton("disable");
	        	}
	 
	        });
	    }
		$('#layer_two').dialog({
			title: '检验项目结果编辑',
			iconCls:"icon-w-paper",
			closed: true,
			modal: true,
			isTopZindex:true
		});
		
		$('#layer_three').dialog({
			title: '检验项目定值结果编辑',
			iconCls:"icon-w-paper",
			closed: true,
			modal: true,
			isTopZindex:true
		});
		
		obj.LoadEvent = function(args){ 
		     	//保存常规检验项目
				$('#btnSave').on('click', function(){
			     	obj.btnSave_click();
		     	});
				//关闭常规检验项目
				$('#btnClose').on('click', function(){
			     	$HUI.dialog('#layer_one').close();
		     	});
				//编辑
				$('#btnEdit_one').on('click', function(){
			     	var rd=obj.gridLabTCMap.getSelected()
					obj.layer1(rd);	
		     	});
				//搜索常规检验项目
				$('#btnsearch_one').searchbox({ 
							searcher:function(value,name){ 
								obj.gridLabTCMap.load({
									ClassName:'DHCHAI.DPS.LabTCMapSrv',
									QueryName:'QryLabTCMapInfo',
									aAlias:value
								});
							}	
						});
				//搜索常规检验项目定值结果
				$('#btnsearch_two').searchbox({ 
							searcher:function(value,name){ 
								obj.gridLabTCMapRst.load({
									ClassName:'DHCHAI.DPS.LabTCMapSrv',
									QueryName:'QryMapRstByTCInfo',
									aMapID:obj.RecRowID1,
									aAlias:value
								});
							}	
						});
				//保存检验项目结果
				$('#btnRstSave').on('click', function(){
			     	obj.btnRstSave_click();
		     	});
				//关闭检验项目结果
				$('#btnRstClose').on('click', function(){
			     	$HUI.dialog('#layer_two').close();
		     	});
				//编辑检验项目结果
		     	$('#btnEdit_two').on('click', function(){
					if(!obj.RecRowID1)return;
			     	var rd=obj.gridLabTCMapRst.getSelected();
					obj.layer2(rd);		
		     	});
				//编辑检验项目定值结果
				$('#btnEdit_three').on('click', function(){
					if(!obj.RecRowID1)return;
				 	var rd=obj.gridLabTCMapAb.getSelected();
					obj.layer3(rd);		
				});
				//检验项目定值结果-保存
				$('#btnAbSave').on('click', function(){
			     	obj.btnAbSave_click();
		     	});
				//检验项目定值结果-关闭
				$('#btnAbClose').on('click', function(){
			     	$HUI.dialog('#layer_three').close();
		     	});
		     	//搜索常规检验项目定值结果
				$('#btnsearch_three').searchbox({ 
							searcher:function(value,name){ 
								obj.gridLabTCMapAb.load({
									ClassName:'DHCHAI.DPS.LabTCMapSrv',
									QueryName:'QryMapAbByTCInfo',
									aMapID:obj.RecRowID1,
									aAlias:value
								});
							}	
						});
		    }
			
			
			//选择常规检验项目
				obj.gridLabTCMap_onSelect = function(){
					if($("#btnEdit_one").hasClass("l-btn-disabled")) obj.RecRowID1="";
					var rowData = obj.gridLabTCMap.getSelected();
					$('#btnsearch_two').searchbox("setValue","");
					$('#btnsearch_three').searchbox("setValue","");
					if (rowData["ID"] == obj.RecRowID1) {
						$("#btnEdit_one").linkbutton("disable");
						$("#btnEdit_two").linkbutton("disable");
						$("#btnEdit_three").linkbutton("disable");
						
						obj.RecRowID1="";
						//obj.PathTCMExtLoad();
						obj.gridLabTCMap.clearSelections();  //清除选中行
					} else {
						obj.RecRowID1 = rowData["ID"];
						$("#btnEdit_one").linkbutton("enable");
						obj.LabTCMapRstLoad();  //加载检验项目结果
						obj.LabTCMapAbLoad();  //加载检验项目定值结果
					}
				}
			//双击编辑事件 父表 常规检验项目
				obj.gridLabTCMap_onDbselect = function(rd){
					obj.layer1(rd);	
				}
			//选择子项  检验项目结果
			    obj.gridLabTCMapRst_onSelect = function (){
					if(!obj.RecRowID1)return;
					if($("#btnEdit_two").hasClass("l-btn-disabled")) obj.RecRowID2="";
					var rowData = obj.gridLabTCMapRst.getSelected();
					
					if (rowData["ID"] == obj.RecRowID2) {
						$("#btnEdit_two").linkbutton("disable");
						
						obj.RecRowID2="";
						obj.gridLabTCMapRst.clearSelections();  //清除选中行
					} else {
						obj.RecRowID2 = rowData["ID"];
						$("#btnEdit_two").linkbutton("enable");
						
					}
				}
			//双击编辑事件 子表  检验项目结果
				obj.gridLabTCMapRst_onDbSelect = function(rd){
					if($("#btnEdit_one").hasClass("l-btn-disabled")){
						$.messager.alert("错误提示", "请先选择左表中的数据" , 'info');			
						return;
					}
					if(!obj.RecRowID1) return;
					obj.layer2(rd);	
				}
					
				obj.btnSave_click = function(){
					var errinfo = "";
					var TestCode = $('#txtTestCode').val();
					var TestDesc = $('#txtTestDesc').val();
					var RstFormat = $('#txtRstFormat').val();
					var AbFlagS = $('#txtAbFlagS').val();
					var SCode = $('#txtSCode').val();
					var IsActive = $("#chkTCActive").checkbox('getValue')? '1':'0';
				
					if (!TestCode) {
						errinfo = errinfo + "代码为空!<br>";
					}
					if (!TestDesc) {
						errinfo = errinfo + "名称为空!<br>";
					}	
				  	
					if (errinfo) {
						$.messager.alert("错误提示", errinfo, 'info');
						return;
					}
					
					var inputStr = obj.RecRowID1;
					inputStr = inputStr + "^" + TestCode;
					inputStr = inputStr + "^" + TestDesc;
					inputStr = inputStr + "^" + RstFormat;
					inputStr = inputStr + "^" + AbFlagS;
					inputStr = inputStr + "^" + SCode;
					inputStr = inputStr + "^" + IsActive;
					inputStr = inputStr + "^";
					inputStr = inputStr + "^";
					inputStr = inputStr + "^";
					var flg = $m({
						ClassName:"DHCHAI.DP.LabTCMap",
						MethodName:"Update",
						InStr:inputStr,
						aSeparete:"^"
					},false);
					if (parseInt(flg) <= 0) {
						if (parseInt(flg) == 0) {
							$.messager.alert("错误提示", "参数错误!" , 'info');
						} else {
							$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
						}
					}else {
						$HUI.dialog('#layer_one').close();
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
						obj.RecRowID1=flg;
						$("#btnEdit_one").linkbutton("disable");
						obj.gridLabTCMap.reload() ;//刷新当前页
					}
				}
				
				
				//选择子项  检验项目定值结果
				    obj.gridLabTCMapAb_onSelect = function (){
						if(!obj.RecRowID1)return;
						if($("#btnEdit_three").hasClass("l-btn-disabled")) obj.RecRowID3="";
						var rowData = obj.gridLabTCMapAb.getSelected();
						
						if (rowData["ID"] == obj.RecRowID3) {
							$("#btnEdit_three").linkbutton("disable");
							
							obj.RecRowID3="";
							obj.gridLabTCMapAb.clearSelections();  //清除选中行
						} else {
							obj.RecRowID3 = rowData["ID"];
							$("#btnEdit_three").linkbutton("enable");
							
						}
					}
				//双击编辑事件 子表  检验项目定值结果
					obj.gridLabTCMapAb_onDbSelect = function(rd){
						if($("#btnEdit_one").hasClass("l-btn-disabled")){
							$.messager.alert("错误提示", "请先选择左表中的数据" , 'info');			
							return;
						}
						if(!obj.RecRowID1) return;
						obj.layer3(rd);	
					}
				
			
			//保存子类 检验项目结果
				obj.btnRstSave_click =  function(){
					var rowDatas = obj.gridLabTCMapRst.getRows();
					var rowlen2=rowDatas.length;
					var AbFlag = "";
					for (var indx=0;indx<rowlen2;indx++){
						if(rowDatas[indx].ID == obj.RecRowID2){
							TestRes=rowDatas[indx].TestRes;
							break;
						}
					}
					//var AbFlag=rowData.AbFlag;
					//var RecRowID2 = rowData.ID;
					//var MapItemDr = rowData.MapID;
					//var TestRes   = rowData.TestRes;
					var errinfo = "";	
					var MapText = $('#txtMapText').val();
					var MapNote = $('#txtMapNote').val();
					var IsActive = $("#chkActive").checkbox('getValue')? '1':'0';
					
					if (!obj.RecRowID1) {
						errinfo = errinfo + "检验项目为空!<br>";
					}
					
					var InputStr = obj.RecRowID2;
					InputStr += "^" + obj.RecRowID1;
					InputStr += "^" + MapText;		
					InputStr += "^" + MapNote;
					InputStr += "^" + TestRes;
					InputStr += "^" + IsActive;
					InputStr += "^" + ''; 
					InputStr += "^" + '';
					InputStr += "^" +'';
					
					var flg = $m({
						ClassName:"DHCHAI.DP.LabTCMapRst",
						MethodName:"Update",
						InStr:InputStr,
						aSeparete:"^"
					},false);
					
					if (parseInt(flg) <= 0) {
						if (parseInt(flg) == 0) {
							$.messager.alert("错误提示", "参数错误!", 'info');
						} else {
							$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
						}
					}else {
						$HUI.dialog('#layer_two').close();
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
						obj.RecRowID2 =flg
						obj.gridLabTCMapRst.reload() ;//刷新当前页
					}
				}
			
			//保存子类 检验项目定值结果
				obj.btnAbSave_click =  function(){
					var rowDatas = obj.gridLabTCMapAb.getRows();
					var rowlen=rowDatas.length;
					var AbFlag = "";
					for (var indx=0;indx<rowlen;indx++){
						if(rowDatas[indx].ID == obj.RecRowID3){
							AbFlag=rowDatas[indx].AbFlag;
							break;
						}
					}
					var errinfo = "";	
					var MapText = $('#txtAbMapText').val();
					var MapNote = $('#txtAbMapNote').val();
					var IsActive = $("#chkAbActive").checkbox('getValue')? '1':'0';
					
					var InputStr = obj.RecRowID3;
					InputStr += "^" + obj.RecRowID1;
					InputStr += "^" + MapText;		
					InputStr += "^" + MapNote;
					InputStr += "^" + AbFlag;
					InputStr += "^" + IsActive;
					InputStr += "^" + ''; 
					InputStr += "^" + '';
					InputStr += "^" + '';
					var flg = $m({
						ClassName:"DHCHAI.DP.LabTCMapAb",
						MethodName:"Update",
						InStr:InputStr,
						aSeparete:"^"
					},false);
					
					if (parseInt(flg) <= 0) {
						if (parseInt(flg) == 0) {
							$.messager.alert("错误提示", "参数错误!", 'info');
						} else {
							$.messager.alert("错误提示", "更新数据错误!Error=" + flg, 'info');
						}
					}else {
						$HUI.dialog('#layer_three').close();
						$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
						obj.RecRowID3 =flg
						obj.gridLabTCMapAb.reload() ;//刷新当前页
					}
				}
			
	//加载项目结果
		obj.LabTCMapRstLoad = function () {
			var ParRef = "";
			if (obj.RecRowID1) {
				ParRef =obj.RecRowID1;
			}
			obj.gridLabTCMapRst.load({
				ClassName:"DHCHAI.DPS.LabTCMapSrv",
				QueryName:"QryMapRstByTC",
				aMapID:ParRef
			});	
		}
		//加载定值项目结果
		obj.LabTCMapAbLoad = function () {
			var MapID = "";
			if (obj.RecRowID1) {
				MapID =obj.RecRowID1;
			}
		obj.gridLabTCMapAb.load({
				ClassName:"DHCHAI.DPS.LabTCMapSrv",
				QueryName:"QryMapAbByTC",
				aMapID:MapID
			});
		}
		
		
	//配置窗体-初始化
		obj.layer1= function(rd){
			if(rd){
				obj.RecRowID1=rd["ID"];
				var Code = rd["TestCode"];
				var Desc = rd["TestDesc"];
				var SetList = rd["TestSetList"];
				var RstFormat = rd["RstFormat"];
				var AbFlagS = rd["AbFlagS"];
				var SCode = rd["SCode"];
				var IsActive = rd["IsActive"];
				IsActive = (IsActive=="1"? true: false)
				$('#txtTestCode').val(Code);
				$('#txtTestDesc').val(Desc);
				$('#txtTestSet').val(SetList);
				$('#txtRstFormat').val(RstFormat);
				$('#txtAbFlagS').val(AbFlagS);
				$('#txtSCode').val(SCode);
				$('#chkTCActive').checkbox('setValue',IsActive);
			}else{
				obj.RecRowID1="";
				$('#txtTestCode').val('');
				$('#txtTestDesc').val('');
				$('#txtTestSet').val('');
				$('#txtRstFormat').val('');
				$('#txtAbFlagS').val('');
				$('#txtSCode').val('');
				$('#chkTCActive').checkbox('setValue',false);
			}
			$HUI.dialog('#layer_one').open();
		}
	    //配置窗体-初始化
		obj.layer2= function(rd){
			if(!obj.RecRowID1){
				//若（obj.RecRowID1 为空）父表未被选中，则子表不进行操作
				$.messager.alert("错误提示","请先选定常规检验项目",'info');
				return;
			}	
			
			if(rd){
				obj.RecRowID2	=rd["ID"];
				var txtMapText	= rd["TestRes"];
				var txtMapNote = rd["MapText"];
				var IsActive = rd["IsActive"];
				IsActive = (IsActive=="1"? true: false)
				$('#txtMapText').val(txtMapText);
				$('#txtMapNote').val(txtMapNote);
				$('#chkActive').checkbox('setValue',IsActive);
			}else{
				obj.RecRowID2 ="";
				$('#txtMapText').val('');
				$('#txtMapNote').val('');
				$('#chkActive').checkbox('setValue',false);
				
			}
			$HUI.dialog('#layer_two').open();
		}
		//配置窗体-初始化
		obj.layer3= function(rd){
			if(!obj.RecRowID1){
				//若（obj.RecRowID1 为空）父表未被选中，则子表不进行操作
				$.messager.alert("错误提示","请先选定常规检验项目",'info');
				return;
			}	
			
			if(rd){
				obj.RecRowID3	=rd["ID"];
				var AbFlag	= rd["AbFlag"];
				var MapText = rd["MapText"];
				var IsActive = rd["IsActive"];
				IsActive = (IsActive=="1"? true: false)
				$('#txtAbMapText').val(AbFlag);
				$('#txtAbMapNote').val(MapText);
				$('#chkAbActive').checkbox('setValue',IsActive);
			}else{
				obj.RecRowID3 ="";
				$('#txtAbMapText').val('');
				$('#txtAbMapNote').val('');
				$('#chkAbActive').checkbox('setValue',false);
				
			}
			$HUI.dialog('#layer_three').open();
		}
  
	
}
