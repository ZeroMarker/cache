//页面Event
function InitVAERuleConfigEvent(obj){
	//检索框
	$('#searchBox').searchbox({ 
		searcher:function(value,name){
			obj.gridMonitItem.load({
				ClassName : "DHCHAI.IRS.VAEMonitItemSrv",
				QueryName : "QueryMonitItem",
				aAlias:$.trim(value)
			})
		}	
	});
	//事件初始化
	obj.LoadEvent = function(args){
		//监测项目
		$('#btnAdd').on('click', function(){
			obj.InitDialog();
		});
		$('#btnEdit').on('click', function(){
			var rd=obj.gridMonitItem.getSelected();
			obj.InitDialog(rd);
		});
		$('#btnDelete').on('click', function(){
			obj.btnDelete_click();
		});
		
		$('#winBtnEdit').on('click', function(){
			obj.Save();
		});
		$('#winBtnClose').on('click', function(){
			$HUI.dialog('#winEdit').close();
		});
		obj.InitRuleSubItem();
    }
    // 初始化监测子项目
    obj.InitRuleSubItem = function(){
		obj.SubItem = $cm({
			ClassName:'DHCHAI.IRS.VAESubItemSrv',
			QueryName:'QueryMonitSItem'
		},false);
		var Shtml="";
		if (obj.SubItem.total>0) {
			$('#VAESubItemInfo').empty();
			
			Shtml += '<table class="search-table">'
			for (var i=0;i<obj.SubItem.total;i++){
				var rd = obj.SubItem.rows[i];
				var VASItmCode = rd.VASItmCode;
				var VASResumeInfo="";
				
				if (VASItmCode=="1"){
					// 每日最低PEEP保持稳定或降低≥{2}天，之后连续{2}天较前两天内升高≥{3}
					VASResumeInfo="每日最低PEEP保持稳定或降低≥"
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A1" style="width:40px;" value="2" />天，之后连续'
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A2" style="width:40px;" value="2" />天较前两天内升高≥'
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A3" style="width:40px;" value="3" />'
				}
				if (VASItmCode=="2"){
					// 每日最低FiO2保持稳定或降低≥{2}天，之后连续{2}天较前两天内升高≥{20%}
					VASResumeInfo="每日最低FiO2保持稳定或降低≥"
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A1" style="width:40px;" value="2" />天，之后连续'
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A2" style="width:40px;" value="2" />天较前两天内升高≥'
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A3" style="width:40px;" value="20%" />'
				}
				if (VASItmCode=="3"){
					// 设置日期范围，异常值范围。某个日期前{3}天后{3}天，出现体温异常大于{38}℃小于{36}℃
					VASResumeInfo="设置日期范围，异常值范围。某个日期前"
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A1" style="width:40px;" value="2" />天后'
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A2" style="width:40px;" value="2" />天，出现体温异常大于'
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A3" style="width:40px;" value="38" />℃小于'
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A4" style="width:40px;" value="36" />℃'
				}
				if (VASItmCode=="4"){
					// 持续发热{3}天及以上
					VASResumeInfo="持续发热"
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A1" style="width:40px;" value="3" />天及以上'
				}
				if (VASItmCode=="5"){
					// {A1}检验医嘱多选下拉框，{A2}类型（可设置排除、包含检验医嘱）{A3}标本多选下拉框{A4}类型（可设置排除、包含标本）{A5}病原体{A6}(可设置包含，排除)
					VASResumeInfo='<a class="hisui-linkbutton" id="ItmCode'+VASItmCode+'A1"">设置检验医嘱</a>&nbsp;&nbsp;'
					VASResumeInfo+='<a class="hisui-linkbutton" id="ItmCode'+VASItmCode+'A2">设置标本</a>&nbsp;&nbsp;'
					VASResumeInfo+='<a class="hisui-linkbutton" id="ItmCode'+VASItmCode+'A3">设置病原体</a>&nbsp;&nbsp;'
					
					VASResumeInfo+='<span style="position: absolute;margin-left:10px;padding:4px 10px;background-color:#e3f7ff;color:#1278b8;border: 1px solid #c0e2f7;border-radius: 5px;">'
    				VASResumeInfo+='<span class="icon-tip-blue" style="margin-right:5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>'
    				VASResumeInfo+='<span style="color:#1278b8;font-weight: 700;font-size: smaller;">提示信息：可以设置检验医嘱、标本、病原体相关附加条件！</span>'		
    				VASResumeInfo+='</span>	'
				}
				if (VASItmCode=="6"){
					// {A1}抗生素多选下拉框，{A2}类型（可设置排除、包含某类抗生素）
					VASResumeInfo='<a class="hisui-linkbutton" id="ItmCode'+VASItmCode+'A1">设置抗生素</a>&nbsp;&nbsp;'
					
					VASResumeInfo+='<span style="position: absolute;margin-left:10px;padding:4px 10px;background-color:#e3f7ff;color:#1278b8;border: 1px solid #c0e2f7;border-radius: 5px;">'
    				VASResumeInfo+='<span class="icon-tip-blue" style="margin-right:5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>'
    				VASResumeInfo+='<span style="color:#1278b8;font-weight: 700;font-size: smaller;">提示信息：可以设置抗生素附加条件！</span>'		
    				VASResumeInfo+='</span>	'
				}
				if (VASItmCode=="7"){
					// 使用新的抗菌药物{A1}，持续{4}天及以上
					VASResumeInfo="使用新的抗菌药物"
					VASResumeInfo+= '<input id="ItmCode'+VASItmCode+'A1" class="hisui-checkbox" name="SItmCheck" type="checkbox">&nbsp;持续'
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A2" style="width:40px;" value="4" />天及以上'
				}
				if (VASItmCode=="8"){
					// {A1}检验医嘱多选下拉框，{A2}类型（可设置排除、包含检验医嘱）{A3}标本多选下拉框{A4}类型（可设置排除、包含标本）计数≥{12000}
					VASResumeInfo='<a class="hisui-linkbutton" id="ItmCode'+VASItmCode+'A1">设置检验医嘱</a>&nbsp;&nbsp;'
					VASResumeInfo+='<a class="hisui-linkbutton" id="ItmCode'+VASItmCode+'A2">设置标本</a>&nbsp;&nbsp;白细胞计数≥'
					VASResumeInfo+= '<input class="textbox" id="ItmCode'+VASItmCode+'A3" style="width:60px;" value="12000" />'
					
					VASResumeInfo+='<span style="position: absolute;margin-left:10px;padding:4px 10px;background-color:#e3f7ff;color:#1278b8;border: 1px solid #c0e2f7;border-radius: 5px;">'
    				VASResumeInfo+='<span class="icon-tip-blue" style="margin-right:5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>'
    				VASResumeInfo+='<span style="color:#1278b8;font-weight: 700;font-size: smaller;">提示信息：可设置具体检验医嘱的白细胞计数以及标本附加条件！</span>'		
    				VASResumeInfo+='</span>	'
				}
				Shtml += '<tr>'
						+'	<td class="l-label" style="padding-left:10px;">'+VASItmCode+'</td>'
					  	+'	<td class="r-label"><input id="SItmCheck'+VASItmCode+'" name="SItmCheck" class="hisui-checkbox" type="checkbox" /></td>'
						+'	<td class="l-label" style="width:130px"><span>'+rd.VASItmDesc+'</span></td>'
						+'	<td class="l-label">'+VASResumeInfo+'</td>'
						+'</tr>'
			}
			Shtml += '<tr>'
						+'	<td colspan="2" class="l-label" style="padding-left:10px;">逻辑关系</td>'
						+'	<td colspan="2"  style="padding-left:10px;" class="l-label" style="width:290px">'
						+'    <input class="textbox" id="VAERuleLogic" style="width:280px;"/>'
						
						+'<span style="position: absolute;margin-left:10px;padding:4px 10px;background-color:#e3f7ff;color:#1278b8;border: 1px solid #c0e2f7;border-radius: 5px;">'
    				    +'<span class="icon-tip-blue" style="margin-right:5px;">&nbsp;&nbsp;&nbsp;&nbsp;</span>'
    				    +'<span style="color:#1278b8;font-weight: 700;font-size: smaller;">提示信息：设置选择的规则逻辑关系表达式；如：(1或2)且(3或4) </span>'		
    				    +'</span>	'
						+'</td>'
						+'</tr>'
			
			Shtml += '</table>'
			$('#VAESubItemInfo').html(Shtml);
			// 初始化规则下拉框信息
			obj.InitRuleCbo();
			
			// 监听事件
			$('#ItmCode1A1,#ItmCode1A2,#ItmCode1A3,#ItmCode2A1,#ItmCode2A2,#ItmCode2A3,#ItmCode3A1,#ItmCode3A2,#ItmCode3A3,#ItmCode3A4,#ItmCode4A1,#ItmCode7A2,#ItmCode8A3').on('blur', function(){
				if (obj.RecRowID){
					
					var SItmCheck1 = ($("#SItmCheck1").checkbox('getValue')?1:0);
					var SItmCheck2 = ($("#SItmCheck2").checkbox('getValue')?1:0);
					if ((SItmCheck1!=1)&&(SItmCheck2!=1)){
						$.messager.popover({msg: '规则维护失败！请至少选择规则PEEP、FiO2中一个。',type:'info',timeout: 2000});
						return;
					}
					var ClickID = $(this).context.id;
					var VASItmCode=ClickID.substring(7,ClickID.indexOf("A"));
					obj.SaveRuleData(VASItmCode);
			    }else{
				    $.messager.popover({msg: '请先选择左侧监测项目,再更新数据!',type:'info',timeout: 2000});
					return;
				}
			});
			// 监听事件
			$('#VAERuleLogic').on('blur', function(){
				
				if (obj.RecRowID){
					var SItmCheck1 = ($("#SItmCheck1").checkbox('getValue')?1:0);
					var SItmCheck2 = ($("#SItmCheck2").checkbox('getValue')?1:0);
					if ((SItmCheck1!=1)&&(SItmCheck2!=1)){
						$.messager.popover({msg: '规则维护失败！请至少选择规则PEEP、FiO2中一个。',type:'info',timeout: 2000});
						return;
					}
					var flg =$m({
						ClassName:"DHCHAI.IR.VAERuleConfig",
						MethodName:"UpdateLogic",
						aMonitItemDr:obj.RecRowID,
						aRuleLogic:$("#VAERuleLogic").val()
				 	},false);
			    	if (parseInt(flg) <= 0) {
						$.messager.popover({msg: '监测规则更新失败!',type:'info',timeout: 2000});
						return;
					}else{
						$.messager.popover({msg: '监测规则更新成功!',type:'success',timeout: 2000});
						return;
					}
			    }else{
				    $.messager.popover({msg: '请先选择左侧监测项目,再更新数据!',type:'info',timeout: 2000});
					return;
				}
			});
			//复选框选中事件
			$HUI.checkbox("[name='SItmCheck']",{  
				onChecked:function(e,value){
					if (obj.RecSelctFlag==1){
						return;
					}
					var SItmCheck1 = ($("#SItmCheck1").checkbox('getValue')?1:0);
					var SItmCheck2 = ($("#SItmCheck2").checkbox('getValue')?1:0);
					if ((SItmCheck1!=1)&&(SItmCheck2!=1)){
						$.messager.popover({msg: '规则维护失败！请至少选择规则PEEP、FiO2中一个。',type:'info',timeout: 2000});
						obj.InitRuleData();
						return;
					}
					var CheckID = $(e.target).attr("id");
					if (obj.RecRowID){
						if (CheckID.indexOf("ItmCode")>=0){
							//规则里面的复选框
							var VASItmCode=CheckID.substring(7,CheckID.indexOf("A"));
						}else{
							//最前面启用规则复选框
							var VASItmCode=CheckID.substring(9,CheckID.length);
						}
						obj.SaveRuleData(VASItmCode);
			    	}else{
				    	this.checked=false;
				    	$.messager.popover({msg: '请先选择左侧监测项目!',type:'info',timeout: 2000});
						return;
					}				
				},onUnchecked:function(e,value){
					if (obj.RecSelctFlag==1){
						return;
					}
					var SItmCheck1 = ($("#SItmCheck1").checkbox('getValue')?1:0);
					var SItmCheck2 = ($("#SItmCheck2").checkbox('getValue')?1:0);
					if ((SItmCheck1!=1)&&(SItmCheck2!=1)){
						$.messager.popover({msg: '规则维护失败！请至少选择规则PEEP、FiO2中一个。',type:'info',timeout: 2000});
						obj.InitRuleData();
						return;
					}				
					var CheckID = $(e.target).attr("id");
					if (obj.RecRowID){
						if (CheckID.indexOf("ItmCode")>=0){
							//规则里面的复选框
							var VASItmCode=CheckID.substring(7,CheckID.indexOf("A"));
						}else{
							//最前面启用规则复选框
							var VASItmCode=CheckID.substring(9,CheckID.length);
						}
						obj.SaveRuleData(VASItmCode);
			    	}else{
				    	this.checked=true;
				    	$.messager.popover({msg: '请先选择左侧监测项目!',type:'info',timeout: 2000});
						return;
					}
				}
			});
		}
		$.parser.parse("#VAESubItemInfo"); // 解析整个页面
	}
	// 保存规则数据
    obj.SaveRuleData = function(aVASItmCode){
		var SubItemID =$m({
			ClassName:"DHCHAI.IR.VAESubItem",
			MethodName:"GetIDByCode",
			aCode:aVASItmCode
	 	},false);
		//规则启用字段 对应表里是否有效字段
		var SItmCheck = ($("#SItmCheck"+aVASItmCode).checkbox('getValue')?1:0);
		var VAEArg=new Array();
    	for (var i=0;i<15;i++){
	    	var VAEItmType=$("#ItmCode"+aVASItmCode+"A"+(i+1)).attr("type");
	    	if (VAEItmType=="checkbox"){
		    	var VAEArginfo=($("#ItmCode"+aVASItmCode+"A"+(i+1)).checkbox("getValue")?1:0);
		    }else{
	    		var VAEArginfo=$("#ItmCode"+aVASItmCode+"A"+(i+1)).val();
		    }
		    if (VAEArginfo==undefined) VAEArginfo="";
			VAEArg[i]=VAEArginfo;
		}
		var VAERuleLogic=$("#VAERuleLogic").val();
    	var InputStr = "";
		InputStr = InputStr + "^" + obj.RecRowID;
		InputStr = InputStr + "^" + SubItemID;
    	InputStr = InputStr + "^" + VAEArg[0];
    	InputStr = InputStr + "^" + VAEArg[1];
    	InputStr = InputStr + "^" + VAEArg[2];
    	InputStr = InputStr + "^" + VAEArg[3];
    	InputStr = InputStr + "^" + VAEArg[4];
    	InputStr = InputStr + "^" + VAEArg[5];
    	InputStr = InputStr + "^" + VAEArg[6];
    	InputStr = InputStr + "^" + VAEArg[7];
    	InputStr = InputStr + "^" + VAEArg[8];
    	InputStr = InputStr + "^" + VAEArg[9];
    	InputStr = InputStr + "^" + VAEArg[10];
    	InputStr = InputStr + "^" + VAEArg[11];
    	InputStr = InputStr + "^" + VAEArg[12];
    	InputStr = InputStr + "^" + VAEArg[13];
    	InputStr = InputStr + "^" + VAEArg[14];
    	InputStr = InputStr + "^" + VAERuleLogic;
    	InputStr = InputStr + "^" + SItmCheck;
    	InputStr = InputStr + "^" + "";
		InputStr = InputStr + "^" + "";
		InputStr = InputStr + "^" + $.LOGON.USERID;
    	var flg =$m({
			ClassName:"DHCHAI.IR.VAERuleConfig",
			MethodName:"Update",
			aInputStr:InputStr,
			aSeparete:"^"
	 	},false);
    	if (parseInt(flg) <= 0) {
			$.messager.popover({msg: '监测规则更新失败!',type:'info',timeout: 2000});
			return;
		}else{
			$.messager.popover({msg: '监测规则更新成功!',type:'success',timeout: 2000});
			return;
		}
    }
	// 初始化规则数据
    obj.InitRuleData = function(){
	    //默认值
		obj.InitRuleSubItem();
	    if (obj.RecRowID==""){
			obj.RecSelctFlag="";
			return;
		}
		obj.VAERuleInfo = $cm({
			ClassName:'DHCHAI.IRS.VAERuleConfigSrv',
			QueryName:'QueryVAERule',
			aMonitItemDr:obj.RecRowID
		},false);
		$("[name='SItmCheck']").checkbox('setValue', false);
		if (obj.VAERuleInfo.total>0) {
			for (var i=0;i<obj.VAERuleInfo.total;i++){
				var rd = obj.VAERuleInfo.rows[i];
				var VAEArg=new Array();
				
				var VASItmCode  = rd.VASItmCode;
				var VAEIsActive = rd.VAEIsActive;
				if (VAEIsActive == "1") {
	                $('#SItmCheck'+VASItmCode).checkbox('setValue', true);
	            }
				VAEArg[0]  = rd.VAEArg1;
				VAEArg[1]  = rd.VAEArg2;
				VAEArg[2]  = rd.VAEArg3;
				VAEArg[3]  = rd.VAEArg4;
				VAEArg[4]  = rd.VAEArg5;
				VAEArg[5]  = rd.VAEArg6;
				VAEArg[6]  = rd.VAEArg7;
				VAEArg[7]  = rd.VAEArg8;
				VAEArg[8]  = rd.VAEArg9;
				VAEArg[9]  = rd.VAEArg10;
				VAEArg[10] = rd.VAEArg11;
				VAEArg[11] = rd.VAEArg12;
				VAEArg[12] = rd.VAEArg13;
				VAEArg[13] = rd.VAEArg14;
				VAEArg[14] = rd.VAEArg15;
		    	for (var j=0;j<15;j++){
			    	var VAEItmType=$("#ItmCode"+VASItmCode+"A"+(j+1)).attr("type");
			    	if (VAEItmType=="checkbox"){
				    	if (VAEArg[j]=="1"){
				    		$("#ItmCode"+VASItmCode+"A"+(j+1)).checkbox('setValue', true);
				    	}
				    }else{
						$("#ItmCode"+VASItmCode+"A"+(j+1)).val(VAEArg[j]);
				    }
				}
			}
			$("#VAERuleLogic").val(rd.VAERuleLogic);
		}else{
			$("#VAERuleLogic").val("");
		}
		obj.RecSelctFlag="";
    }
	// 初始化规则下拉框信息
    obj.InitRuleCbo = function(){
	    // 检验医嘱设置
		$('#ItmCode5A1,#ItmCode8A1').on('click', function(){
			if (!obj.RecRowID){
				$.messager.popover({msg: '请先选择左侧监测项目!',type:'info',timeout: 2000});
				return;		
			}
			obj.ClickEventID = $(this).attr("id");
			obj.CboLabOE1 = $HUI.combobox("#CboLabOE1", {
				url: $URL,
				editable: true,
				allowNull: true, 
				multiple:true,
				rowStyle:'checkbox',
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'TestSet',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = "DHCHAI.DPS.LabTestSetSrv",
					param.QueryName = "QryLabTestSetMap",
					param.aAlias = "", // DHCHAI.DP.LabTestSetMap
					param.ResultSetType = 'array';
				}
			});
			obj.LabOEType1  = $HUI.combobox("#LabOEType1", {
				url: $URL,
				editable: true,
				allowNull: true, 
				multiple:false,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'DicDesc',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.BTS.DictionarySrv';
					param.QueryName = 'QryDic';
					param.aTypeCode    = "VAEType",
					param.aActive = "1";
					param.ResultSetType = 'array';
				}
			});
			$HUI.dialog('#LabOEEdit1').open();
		});
		// 标本设置
		$('#ItmCode5A2,#ItmCode8A2').on('click', function(){
			if (!obj.RecRowID){
				$.messager.popover({msg: '请先选择左侧监测项目!',type:'info',timeout: 2000});
				return;		
			}
			obj.ClickEventID = $(this).context.id;
			obj.CboSpec1 = $HUI.combobox("#CboSpec1", {
				url: $URL,
				editable: true,
				allowNull: true, 
				multiple:true,
				rowStyle:'checkbox',
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'SpecDesc',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = "DHCHAI.DPS.LabSpecSrv",
					param.QueryName = "QryLabSpecimen",
					param.aAlias = "", // DHCHAI.DP.LabSpecimen
					param.ResultSetType = 'array';
				}
			});
			obj.SpecType1  = $HUI.combobox("#SpecType1", {
				url: $URL,
				editable: true,
				allowNull: true, 
				multiple:false,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'DicDesc',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.BTS.DictionarySrv';
					param.QueryName = 'QryDic';
					param.aTypeCode    = "VAEType",
					param.aActive = "1";
					param.ResultSetType = 'array';
				}
			});
			$HUI.dialog('#SpecEdit1').open();
		});
		// 抗生素设置
		$('#ItmCode6A1').on('click', function(){
			if (!obj.RecRowID){
				$.messager.popover({msg: '请先选择左侧监测项目!',type:'info',timeout: 2000});
				return;		
			}
			obj.ClickEventID = $(this).attr("id");
			obj.CboAnti1 = $HUI.combobox("#CboAnti1", {
				url: $URL,
				editable: true,
				allowNull: true, 
				multiple:true,
				rowStyle:'checkbox',
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'AntDesc',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = "DHCHAI.DPS.LabAntiSrv",
					param.QueryName = "QryLabAntibiotic",
					param.aAlias = "", // DHCHAI.DP.LabAntibiotic
					param.ResultSetType = 'array';
				}
			});
			obj.AntiType1  = $HUI.combobox("#AntiType1", {
				url: $URL,
				editable: true,
				allowNull: true, 
				multiple:false,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'DicDesc',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.BTS.DictionarySrv';
					param.QueryName = 'QryDic';
					param.aTypeCode    = "VAEType",
					param.aActive = "1";
					param.ResultSetType = 'array';
				}
			});
			$HUI.dialog('#AntiEdit1').open();
		});
		// 检出菌设置病原体
		$('#ItmCode5A3').on('click', function(){
			if (!obj.RecRowID){
				$.messager.popover({msg: '请先选择左侧监测项目!',type:'info',timeout: 2000});
				return;		
			}
			obj.ClickEventID = $(this).attr("id");
			obj.Bact1 = $HUI.combobox("#Bact1", {
				url: $URL,
				editable: true,
				allowNull: true, 
				multiple:true,
				rowStyle:'checkbox',
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'BacDesc',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.DPS.LabBactSrv';
					param.QueryName = 'QryLabBacteria';
					param.aAlias    = "",  // DHCHAI.DP.LabBacteria
					param.aIsCommon = "";
					param.ResultSetType = 'array';
				}
			});
			obj.BactType1  = $HUI.combobox("#BactType1", {
				url: $URL,
				editable: true,
				allowNull: true, 
				multiple:false,
				defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
				valueField: 'ID',
				textField: 'DicDesc',
				onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
					param.ClassName = 'DHCHAI.BTS.DictionarySrv';
					param.QueryName = 'QryDic';
					param.aTypeCode    = "VAEType",
					param.aActive = "1";
					param.ResultSetType = 'array';
				}
			});
			$HUI.dialog('#BactEdit1').open();
		})
    }
    //删除抗生素信息
    $('#AntiDel1').on('click', function(){
	    var SelectRows=$HUI.datagrid('#AntiList1').getSelections();
	    if (SelectRows.length<1) {
			$.messager.alert("提示","至少选择一条记录进行删除", 'info');
			return ;
		}
		var DelVAEInfo="";
		var SubItemID="",MonitItemDr="";
		for(var i=0;i<SelectRows.length;i++) {
			var row=SelectRows[i];
			var DictionDr   = row.DictionDr;
			var AntiDr      = row.AntiDr;
			var SubItemID   = row.SubItemID;
			var MonitItemDr = row.aMonitItemDr;
			var DelVAEInfo  = DelVAEInfo+"#"+AntiDr+","+DictionDr;
		}
		var InputStr = MonitItemDr;
		InputStr += "^" + SubItemID;  
		InputStr += "^" + DelVAEInfo;
		InputStr += "^" + obj.ClickEventID;
		// 更新抗生素信息
		var flg = $m({
			ClassName:"DHCHAI.IR.VAERuleConfig",
			MethodName:"DeleteLabOE",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.reloadAntiInfo();	//刷新当前页
			//$HUI.dialog('#Specdit1').close();
			//给弹出框赋值
			var VAEArg=flg.split("%")[1];
			$("#"+obj.ClickEventID+"").val(VAEArg);
			
			$.messager.popover({msg: '删除成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	});
	//保存抗生素信息
    $('#AntiSave1').on('click', function(){
	    var AntiTypeID=$('#AntiType1').combobox('getValue');
	    var errinfo="";
	    var AntiArr   = $('#CboAnti1').combobox('getValues');
		var aAntiIDs  = AntiArr.join(); // ID 逗号分隔
		
		if (!aAntiIDs) {
			errinfo = errinfo + "抗生素不允许为空!<br>";
		}
		if (!AntiTypeID) {
			errinfo = errinfo + "类型不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + obj.ClickEventID;  
		InputStr += "^" + AntiTypeID; 
		InputStr += "^" + aAntiIDs;
		
		// 更新抗生素信息
		var flg = $m({
			ClassName:"DHCHAI.IR.VAERuleConfig",
			MethodName:"UpdateLabOE",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.reloadAntiInfo();	//刷新当前页
			//$HUI.dialog('#SpecEdit1').close();
			//给弹出框赋值
			var VAEArg=flg.split("%")[1];
			$("#"+obj.ClickEventID+"").val(VAEArg);
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	});
    //删除病原体信息
    $('#BactDel1').on('click', function(){
	    var SelectRows=$HUI.datagrid('#BactList1').getSelections();
	    if (SelectRows.length<1) {
			$.messager.alert("提示","至少选择一条记录进行删除", 'info');
			return ;
		}
		var DelVAEInfo="";
		var SubItemID="",MonitItemDr="";
		for(var i=0;i<SelectRows.length;i++) {
			var row=SelectRows[i];
			var DictionDr   = row.DictionDr;
			var BactDr      = row.BactDr;
			var SubItemID   = row.SubItemID;
			var MonitItemDr = row.aMonitItemDr;
			var DelVAEInfo  = DelVAEInfo+"#"+BactDr+","+DictionDr;
		}
		var InputStr = MonitItemDr;
		InputStr += "^" + SubItemID;  
		InputStr += "^" + DelVAEInfo;
		InputStr += "^" + obj.ClickEventID;
		// 更新病原体信息
		var flg = $m({
			ClassName:"DHCHAI.IR.VAERuleConfig",
			MethodName:"DeleteLabOE",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.reloadBactInfo();	//刷新当前页
			//$HUI.dialog('#Specdit1').close();
			//给弹出框赋值
			var VAEArg=flg.split("%")[1];
			$("#"+obj.ClickEventID+"").val(VAEArg);
			$.messager.popover({msg: '删除成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	});
	//保存病原体信息
    $('#BactSave1').on('click', function(){
	    var BactTypeID=$('#BactType1').combobox('getValue');
	    var errinfo="";
	    var BactArr   = $('#Bact1').combobox('getValues');
		var aBactIDs  = BactArr.join(); // ID 逗号分隔
		
		if (!aBactIDs) {
			errinfo = errinfo + "病原体不允许为空!<br>";
		}
		if (!BactTypeID) {
			errinfo = errinfo + "类型不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + obj.ClickEventID;  
		InputStr += "^" + BactTypeID; 
		InputStr += "^" + aBactIDs;
		
		// 更新病原体信息
		var flg = $m({
			ClassName:"DHCHAI.IR.VAERuleConfig",
			MethodName:"UpdateLabOE",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.reloadBactInfo();	//刷新当前页
			//$HUI.dialog('#SpecEdit1').close();
			//给弹出框赋值
			var VAEArg=flg.split("%")[1];
			$("#"+obj.ClickEventID+"").val(VAEArg);
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	});
    //删除标本信息
    $('#SpecDel1').on('click', function(){
	    var SelectRows=$HUI.datagrid('#SpecList1').getSelections();
	    if (SelectRows.length<1) {
			$.messager.alert("提示","至少选择一条记录进行删除", 'info');
			return ;
		}
		var DelVAEInfo="";
		var SubItemID="",MonitItemDr="";
		for(var i=0;i<SelectRows.length;i++) {
			var row=SelectRows[i];
			var DictionDr   = row.DictionDr;
			var SpecDescDr  = row.SpecDescDr;
			var SubItemID   = row.SubItemID;
			var MonitItemDr = row.aMonitItemDr;
			var DelVAEInfo  = DelVAEInfo+"#"+SpecDescDr+","+DictionDr;
		}
		var InputStr = MonitItemDr;
		InputStr += "^" + SubItemID;  
		InputStr += "^" + DelVAEInfo;
		InputStr += "^" + obj.ClickEventID;
		// 更新标本信息
		var flg = $m({
			ClassName:"DHCHAI.IR.VAERuleConfig",
			MethodName:"DeleteLabOE",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.reloadSpecInfo();	//刷新当前页
			//$HUI.dialog('#Specdit1').close();
			//给弹出框赋值
			var VAEArg=flg.split("%")[1];
			$("#"+obj.ClickEventID+"").val(VAEArg);
			$.messager.popover({msg: '删除成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	});
	//保存标本信息
    $('#SpecSave1').on('click', function(){
	    var SpecTypeID=$('#SpecType1').combobox('getValue');
	    var errinfo="";
	    var SpecArr   = $('#CboSpec1').combobox('getValues');
		var aSpecIDs  = SpecArr.join(); // ID 逗号分隔
		
		if (!aSpecIDs) {
			errinfo = errinfo + "标本不允许为空!<br>";
		}
		if (!SpecTypeID) {
			errinfo = errinfo + "类型不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + obj.ClickEventID;  
		InputStr += "^" + SpecTypeID; 
		InputStr += "^" + aSpecIDs;
		
		// 更新标本信息
		var flg = $m({
			ClassName:"DHCHAI.IR.VAERuleConfig",
			MethodName:"UpdateLabOE",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.reloadSpecInfo();	//刷新当前页
			//$HUI.dialog('#SpecEdit1').close();
			//给弹出框赋值
			var VAEArg=flg.split("%")[1];
			$("#"+obj.ClickEventID+"").val(VAEArg);
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	});
    //删除检验医嘱信息
    $('#LabOEDel1').on('click', function(){
	    var SelectRows=$HUI.datagrid('#LabOEList1').getSelections();
	    if (SelectRows.length<1) {
			$.messager.alert("提示","至少选择一条记录进行删除", 'info');
			return ;
		}
		var DelVAEInfo="";
		var SubItemID="",MonitItemDr="";
		for(var i=0;i<SelectRows.length;i++) {
			var row=SelectRows[i];
			var DictionDr   = row.DictionDr;
			var TestSetDr   = row.TestSetDr;
			var SubItemID   = row.SubItemID;
			var MonitItemDr = row.aMonitItemDr;
			var DelVAEInfo  = DelVAEInfo+"#"+TestSetDr+","+DictionDr;
		}
		var InputStr = MonitItemDr;
		InputStr += "^" + SubItemID;  
		InputStr += "^" + DelVAEInfo;
		InputStr += "^" + obj.ClickEventID;
		// 更新检验医嘱信息
		var flg = $m({
			ClassName:"DHCHAI.IR.VAERuleConfig",
			MethodName:"DeleteLabOE",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.reloadLabOEInfo();	//刷新当前页
			//$HUI.dialog('#LabOEEdit1').close();
			//给弹出框赋值
			var VAEArg=flg.split("%")[1];
			$("#"+obj.ClickEventID+"").val(VAEArg);
			$.messager.popover({msg: '删除成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	});
	//保存检验医嘱信息
    $('#LabOESave1').on('click', function(){
	    var LabOETypeID=$('#LabOEType1').combobox('getValue');
	    var errinfo="";
	    var LabOE1Arr   = $('#CboLabOE1').combobox('getValues');
		var aLabOEIDs  = LabOE1Arr.join(); // ID 逗号分隔
		
		if (!aLabOEIDs) {
			errinfo = errinfo + "检验医嘱不允许为空!<br>";
		}
		if (!LabOETypeID) {
			errinfo = errinfo + "类型不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + obj.ClickEventID;  
		InputStr += "^" + LabOETypeID; 
		InputStr += "^" + aLabOEIDs;
		
		// 更新检验医嘱信息
		var flg = $m({
			ClassName:"DHCHAI.IR.VAERuleConfig",
			MethodName:"UpdateLabOE",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.reloadLabOEInfo();	//刷新当前页
			//$HUI.dialog('#LabOEEdit1').close();
			//给弹出框赋值
			var VAEArg=flg.split("%")[1];
			$("#"+obj.ClickEventID+"").val(VAEArg);
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	});
	// *********************监测项目Event*************************
	//双击编辑
	obj.gridMonitItem_onDbselect = function(rd){
		obj.InitDialog(rd);
	}
	//选择
	obj.gridMonitItem_onSelect = function (){
		var rowData = obj.gridMonitItem.getSelected();

		if (rowData["ID"] == obj.RecRowID) {
			obj.RecRowID="";
			obj.RecSelctFlag="";
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			obj.gridMonitItem.clearSelections();
		} else {
			obj.RecSelctFlag=1;
			obj.RecRowID = rowData["ID"];
			$("#btnAdd").linkbutton("disable");
			$("#btnEdit").linkbutton("enable");
			$("#btnDelete").linkbutton("enable");
		}
		// 1,根据监测项目初始化规则数据
		obj.InitRuleData();
	}
	
	//核心方法-更新
	obj.Save = function(){
		var errinfo="";
		var VAItmCode = $("#txtVAItmCode").val();
		var VAItmDesc = $("#txtVAItmDesc").val();
		var VAResume  = $("#txtVAResume").val();
		var IsActive  = $("#chkVAIsActive").checkbox('getValue')? '1':'0';		                                                                            
	    
		if (!VAItmCode) {
			errinfo = errinfo + "项目代码不允许为空!<br>";
		}
		if (!VAItmDesc) {
			errinfo = errinfo + "项目名称不允许为空!<br>";
		}
		if (errinfo) {
			$.messager.alert("错误提示", errinfo, 'info');
			return;
		}
		var InputStr = obj.RecRowID;
		InputStr += "^" + VAItmCode;  
		InputStr += "^" + VAItmDesc; 
		InputStr += "^" + VAResume;
		InputStr += "^" + "";         // 院区
		InputStr += "^" + IsActive; 
		InputStr += "^" + "";         // 处置日期
		InputStr += "^" + "";         // 处置时间
		InputStr += "^" + $.LOGON.USERID; // 处置人
		
		var flg = $m({
			ClassName:"DHCHAI.IR.VAEMonitItem",
			MethodName:"Update",
			aInputStr:InputStr
		},false);
		if (parseInt(flg)> 0) {
			obj.RecRowID="";
			obj.gridMonitItem.reload();	//刷新当前页
			$HUI.dialog('#winEdit').close();
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
		}else if(parseInt(flg) == '-100'){
			$.messager.alert("错误提示", "代码重复!" , 'info');
		}else{
			$.messager.alert("错误提示", "保存失败!Error=" + flg, 'info');
		}
	}
	//核心方法-删除
	obj.btnDelete_click = function(){
		if (obj.RecRowID==""){
			$.messager.alert("提示", "请选中数据,再点击删除!", 'info');
			return;
		}
		$.messager.confirm("删除", "确认是否删除?", function (r) {
			if (r) {				
				var flg = $m({
					ClassName:"DHCHAI.IR.VAEMonitItem",
					MethodName:"DeleteById",
					aId:obj.RecRowID
				},false);
				
				if (flg == '0') {
					$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
					obj.RecRowID = "";
					obj.gridMonitItem.reload(); //刷新当前页
				} else {
					if (parseInt(flg)=='-777') {
						$.messager.alert("提示","-777：当前无删除权限，请启用删除权限后再删除记录!",'info');
					}else {
						$.messager.alert("错误提示","删除失败!Error=" + flg, 'info');
					}
				}
			} 
		});
	}
    //窗体-初始化
	obj.InitDialog= function(rd){
		if(rd){
			$('#txtVAItmCode').val(rd["VAItmCode"]).validatebox("validate");
			$('#txtVAItmDesc').val(rd["VAItmDesc"]).validatebox("validate");
			$('#txtVAResume').val(rd["VAResume"]);
			$('#chkVAIsActive').checkbox('setValue',rd["VAIsActive"]== "是");
			
			$("#winBtnSave").show();
			$("#winBtnAdd").hide();
			
			obj.RecRowID=rd["ID"];
		}else{
			$('#txtVAItmCode').val("").validatebox("validate");
			$('#txtVAItmDesc').val("").validatebox("validate");
			$('#txtVAResume').val("");
			$('#chkVAIsActive').checkbox('setValue',true);
			
			$("#winBtnSave").hide();
			$("#winBtnAdd").show();
			
			obj.RecRowID = "";
		}
		
		$('#winEdit').show();
		$('#winEdit').dialog({
			title: '监测项目编辑',
			iconCls:'icon-w-paper',
			modal: true,
			isTopZindex:true
		});
	}
}