var CHR_1 = String.fromCharCode(1);
var CHR_2 = String.fromCharCode(2);
var CHR_3 = String.fromCharCode(3);
var CHR_4 = String.fromCharCode(4);
var CHR_5 = String.fromCharCode(5);
var CHR_6 = String.fromCharCode(6);
var CHR_7 = String.fromCharCode(7);
var CHR_8 = String.fromCharCode(8);

//取值
function Common_GetValue()
{
	var itmValue = '';

	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	
    var className = $this.attr("class").split(' ')[0];

    if (className == 'textbox') {  //文本框
	    itmValue = $this.val();
    }else if (className == 'hisui-numberbox') {  //数字
    	itmValue = $this.val();	    
    }else if (className == 'hisui-datebox') {  //日期
    	itmValue = $this.datebox('getValue');	    
    }else if (className == 'hisui-timespinner') {  //时间框
    	itmValue = $this.timespinner('getValue');	
    }else if (className == 'hisui-combobox') {  //下拉框（多选下拉框没有封装）
   	  	itmValue = $this.combobox('getValue');
    }else if (className == 'hisui-switchbox') {  //开关
    	itmValue = $this.switchbox('getValue');	
    }else if (className == 'hisui-checkbox') {  // 单个复选框
    	itmValue = $this.checkbox('getValue');	    
    }else if (className == 'hisui-radio') {  //单个单选框
    	itmValue = $this.radio('getValue');
    }else if (className == 'hisui-searchbox') {  //查询框框
    	itmValue = $this.searchbox('getValue');	
    }
    
	return itmValue;	
}

//取值
function Common_GetText()
{
	var itmValue = '';

	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	
    var className = $this.attr("class").split(' ')[0];
 
    if (className == 'textbox') {  //文本框
	    itmValue = $this.val();
    }else if (className == 'hisui-numberbox') {  //数字
    	itmValue = $this.val();	    
    }else if (className == 'hisui-datebox') {  //日期
    	itmValue = $this.datebox('getValue');	    
    }else if (className == 'hisui-timespinner') {  //时间框
    	itmValue = $this.timespinner('getValue');	
    }else if (className == 'hisui-combobox') {  //下拉框
   	  	itmValue = $this.combobox('getText');
    }else if (className == 'hisui-switchbox') {  //开关
    	itmValue = $this.switchbox('getValue');	
    }else if (className == 'hisui-checkbox') {  // 单个复选框
    	itmValue = $this.attr("label");	    
    }else if (className == 'hisui-radio') {  //单个单选框
    	itmValue =$this.attr("label");
    }else if (className == 'hisui-searchbox') {  //查询框框
    	itmValue = $this.searchbox('getValue');	
    }
    
	return itmValue;	
}

//赋值
function Common_SetValue()
{
	var itmValue = '';
    
    var val = arguments[1];     
	var txt = arguments[2];
	
	if (typeof(arguments[0]) !== 'string') return '';
	if (arguments[0] == '') return '';
	
	var $this = $('#'+ arguments[0]);
	if ($this.length < 1) return '';
	if (typeof val == 'undefined') val = '';
	if (typeof txt == 'undefined') txt = '';
	
    var className = $this.attr("class").split(' ')[0];
 
    if (className == 'textbox') {  //文本框
	    itmValue = $this.val(val);
    }else if (className == 'hisui-numberbox') {  //数字
    	itmValue = $this.val(val);	    
    }else if (className == 'hisui-datebox') {  //日期
    	itmValue = $this.datebox('setValue',val);   
    }else if (className == 'hisui-timespinner') {  //时间框
    	itmValue = $this.timespinner('setValue',val);	
    }else if (className == 'hisui-combobox') {  //下拉框
    	if(val !="" && txt ==""){
   	  		itmValue = $this.combobox('setValue',val);
    	}else{
	    	itmValue = $this.combobox('setValue',txt);
		}
    }else if (className == 'hisui-switchbox') {  //开关
    	itmValue = $this.switchbox('setValue',val);	
    }else if (className == 'hisui-checkbox') {  // 单个复选框
    	if (val == '') val = 0;
    	itmValue = $this.checkbox('setValue',(val) ? true : false);
    }else if (className == 'hisui-radio') {  //单个单选框
        if (val == '') val = 0;
    	itmValue = $this.radio('setValue',(val) ? true : false);
    }else if (className == 'hisui-searchbox') {  //查询框框
    	itmValue = $this.searchbox('setValue',val);	
    }
    
	return itmValue;	
}

//加载医院公共方法
function Common_ComboToSSHosp(){
	var ItemCode = arguments[0];
	var SSHospCode = arguments[1];
	var ProductCode = arguments[2];
	
	//医院列表 表格初始查询只有同步加载才能取得数据
	var HospList = $cm ({
		ClassName:"DHCMed.SSService.HospitalSrv",
		QueryName:"QrySSHospByCode",
		aHospCode:SSHospCode,
		aProductCode:ProductCode
	},false);

    var cbox = $HUI.combobox("#"+ItemCode, {
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'CTHospID',
		textField: 'CTHospDesc',
		data:HospList.rows,
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
			// 院区默认选择
				$(this).combobox('select',data[0]['CTHospID']);
			}
		}

	})
	
}

//加载医院公共方法(MA)
function Common_ComboToSSHosp2(){
	var ItemCode = arguments[0];
	var SSHospCode = arguments[1];
	var ProductCode = arguments[2];
	var IsShowAllHosp = arguments[3];			// 是否显示全部院区，为1显示全部院区，其他只显示与SSHospCode同组下院区
	if (IsShowAllHosp == undefined || IsShowAllHosp == "") IsShowAllHosp = "0";
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'OID',
		textField: 'Desc',
		//value:SSHospCode,
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMA.Util.EPS.HospitalSrv';
			param.QueryName = 'QryHospInfo';
			param.aHospID=SSHospCode;
			param.aIsActive="1";
			param.IsShowAllHosp=IsShowAllHosp;
			param.ResultSetType = 'array';
		},		
		onLoadSuccess:function(){   //初始加载赋值
			var data=$(this).combobox('getData');
			if (data.length>0){
				if (!!SSHospCode) $(this).combobox('select',SSHospCode);
				else $(this).combobox('select',data[0].OID)
			} 
		}
	});
	return  cbox;
}

//加载医院公共方法(针对8.5His及之后版本，用于支持基础数据平台多院区改造后方法)		
function Common_ComboToSSHosp3(){
	var ItemCode = arguments[0];
	var SSHospOID = arguments[1];
	var SSHospDesc = arguments[2];
	var TableName = arguments[3];
	var SessionStr = arguments[4];
	var ProductCode = arguments[5];
	
	//当前登录用户默认医院
	var DefHospOID = $cm({ClassName:"DHCMA.Util.IO.MultiHospInterface",MethodName:"GetDefaultHosp",aTableName:TableName,aHospID:session['LOGON.HOSPID'],dataType:'text'},false);
	
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField:'OID',
		textField:'Desc',
		value:DefHospOID,
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMA.Util.IO.MultiHospInterface';
			param.QueryName = 'QryHospInfoForCombo';
			param.aRowid=SSHospOID;
			param.aDesc = SSHospDesc;
			param.aTableName = TableName ;
			param.aSessionStr = SessionStr;
			param.ResultSetType = 'array';
		}
	});
	
	return  cbox;
}

// 基于基础数据平台多院区改造后，用于管控数据的通用授权弹框方法 			add by yankai 20210729
function Common_WinToAuthHosp(){
	var DataRowID = arguments[0];				//关联数据ID
	var TableName = arguments[1];				//关联数据所属表名
	var GridCode = arguments[2];
	var WinCode = arguments[3];
		
	if (DataRowID==""){
		$.messager.alert("提示", "请先选中一条记录,再点击！", 'info');
		return;
	}
	//授权医院列表
	$HUI.datagrid("#"+GridCode,{
		//title: "授权医院列表",
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.Util.IO.MultiHospInterface",
			QueryName:"QryHospDataForCloud",
			aTableName:TableName,
			aDataID:DataRowID
		}, 
		columns:[[
			{field:'LinkFlag',checkbox:'true',align:'center',auto:false},
			{field:'OID',title:'id',width:'80',sortable:true,hidden:true},
			{field:'HOSPDesc',title:'医院名称',width:'300',sortable:true}
		]],
		onLoadSuccess:function(data) {
		    var rowData = data.rows;
		    $.each(rowData,function (idx, val) {
		        if (val.LinkFlag=="Y") {
			        $("#"+GridCode).datagrid("checkRow", idx);
		        }
		    });
		}
	})
	//编辑窗体
	$('#'+WinCode).dialog({
		title: '医院权限分配',
		closed: true,
		modal: true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			handler:function(){
				var rows = $('#'+GridCode).datagrid("getRows");
				if (rows.length==0){
					$.messager.alert("提示", "没有需要关联的医院！", 'info');
					return;	
				}					
				var retInfo=""
				$.each(rows, function(index, item){
					if ( item.LinkFlag=="N" && $(":checkbox[name=LinkFlag]")[index].checked==true ){			//新增关联处理
						var addRet = $m({
							ClassName:"DHCMA.Util.IO.MultiHospInterface",
							MethodName:"SaveDataRelHosp",
							aTableName:TableName,
							aRowID:DataRowID,
							aHospID:item.OID
						},false);
						if(addRet.split("^")[0]<0) {
							retInfo="err^第"+index+"记录保存失败，请重试！"
							return false;
						}
					}else if( item.LinkFlag=="Y" && $(":checkbox[name=LinkFlag]")[index].checked==false ){		//取消原有关联处理
						var delRet = $m({
							ClassName:"DHCMA.Util.IO.MultiHospInterface",
							MethodName:"DelOneDataHospRelRec",
							aTableName:TableName,
							aRowID:DataRowID,
							aHospID:item.OID
						},false);
						if(delRet.split("^")[0]<0) {
							retInfo="err^第"+index+"记录保存失败，请重试！"
							return false;
						}	
					}else{
						//未进行修改，无需处理	
					}
				});
				if (retInfo!=""){
					$.messager.alert("提示", retInfo.split("^")[1] , 'error');
					return;	
				}else{
					$.messager.alert("提示", "保存成功！" , 'success');
					$HUI.dialog('#'+WinCode).close();
					return;			
				}
			}
		},{
			text:'取消',
			handler:function(){
				$HUI.dialog('#'+WinCode).close();
			}
		}]
	});
	$HUI.dialog('#'+WinCode).open();	
}


function dispalyEasyUILoad() {
    $(".datagrid-mask").remove();
    $(".datagrid-mask-msg").remove();
}

//加载科室/病区公共方法
function Common_ComboToLoc(){
	var ItemCode = arguments[0];
	var LocType = arguments[1];
	var LinkLoc = arguments[2];
	var AdmType = arguments[3];
	var HospID = arguments[4];

	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'LocRowId',
		textField: 'LocDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMed.SSService.HospitalSrv';
			param.QueryName = 'QueryLoction';
			param.aAlias = '';
			param.aDepGroup = '';
			param.aLinkLoc = LinkLoc;
			param.aLocType = LocType;
			param.aAdmType = AdmType;
			param.aHospitalIDs =HospID;
			param.ResultSetType = 'array';
		}
	});
	return ;
	
}
//加载科室/病区公共方法 (科室多选)
function Common_ComboToMultiLoc(){
	var ItemCode = arguments[0];
	var LocType = arguments[1];
	var LinkLoc = arguments[2];
	var AdmType = arguments[3];
	var HospID = arguments[4];

	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		valueField: 'LocRowId',
		textField: 'LocDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMed.SSService.HospitalSrv';
			param.QueryName = 'QueryLoction';
			param.aAlias = '';
			param.aDepGroup = '';
			param.aLinkLoc = LinkLoc;
			param.aLocType = LocType;
			param.aAdmType = AdmType;
			param.aHospitalIDs =HospID;
			param.ResultSetType = 'array';
		}
	});
	return ;
	
}
//加载科室/病区公共方法
function Common_ComboToLoc2(){
	var ItemCode = arguments[0];
	var LocType = arguments[1];
	var LinkLoc = arguments[2];
	var AdmType = arguments[3];
	var HospID = arguments[4];
	var cbox = $HUI.combobox("#"+ItemCode, {
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'LocRowId',
		textField: 'LocDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCMed.SSService.HospitalSrv&QueryName=QueryLoction&ResultSetType=array&aLinkLoc="+LinkLoc +"&aLocType="+LocType+"&aAdmType="+AdmType+"&aHospitalIDs="+HospID;
		   	$("#"+ItemCode).combobox('reload',url);
		}
	});
	return ;
	
}

//加载科室/病区公共方法去取MA
function Common_ComboToLoc3(){
	var ItemCode = arguments[0];
	var LocType = arguments[1];
	var LinkLoc = arguments[2];
	var AdmType = arguments[3];
	var HospID = arguments[4];
	var cbox = $HUI.combobox("#"+ItemCode, {
		url:$URL,
		onBeforeLoad:function(param){
			param.ClassName="DHCMA.Util.EPS.LocationSrv",
			param.QueryName="QryLocInfo",
			param.aHospID=HospID,
			param.aType=LocType,
			param.aAdmType=AdmType,
			param.ResultSetType='array'	
		},
		editable: true,
		valueField: 'OID',
		textField: 'Desc',
		defaultFilter:4
	});
	return ;
	
}

//字典公共方法(取值是code)
function Common_ComboToDicCode() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	if (arguments[2]) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '^-';
	}
	if (arguments[3]) {
		var HospID = arguments[3];
	} else {
		var HospID = "";
	}
	if (arguments[2]) {  //需初始赋值
		var cbox = $HUI.combobox("#"+ItemCode, {
			url: $URL,
			editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
			allowNull: true,
			defaultFilter:4,     
			valueField: 'DicCode',
			textField: 'DicDesc', 
			onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDicToCbo';
				param.aDicType = DicType;
				param.aAddItem = AddItem;
				param.aHospID = HospID;
				param.ResultSetType = 'array';
			},		 
			onLoadSuccess:function(){
				var data=$(this).combobox('getData');
				if (data.length>0){
					$(this).combobox('select',data[0]['DicCode']);
				}
			}
		});			
	} else {
		var cbox = $HUI.combobox("#"+ItemCode, {
			editable: false,     
			defaultFilter:4,    
			valueField: 'DicCode',
			textField: 'DicDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDicToCbo&ResultSetType=array&aDicType="+DicType +"&aAddItem="+AddItem+"&aHospID="+HospID;;
			   	$("#"+ItemCode).combobox('reload',url);
			}
		});	
	}		
	return;
}

//字典公共方法(取值是ID)
function Common_ComboToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	if (arguments[2]) {
		var AddItem = arguments[2];
	} else {
		var AddItem = '^-';
	}
	if (arguments[3]) {
		var HospID = arguments[3];
	} else {
		var HospID = "";
	}
	if (arguments[2]) {  //需初始赋值
		var cbox = $HUI.combobox("#"+ItemCode, {
			url: $URL,
			editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
			defaultFilter:4, 
			allowNull: true,
			//placeholder:'请选择',
			valueField: 'DicRowId',
			textField: 'DicDesc', 
			onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
				param.ClassName = 'DHCMed.SSService.DictionarySrv';
				param.QueryName = 'QryDicToCbo';
				param.aDicType = DicType;
				param.aAddItem = AddItem;
				param.aHospID = HospID;
				param.ResultSetType = 'array';
			}
		});	
	} else {	
		var cbox = $HUI.combobox("#"+ItemCode, {
			editable: false,       
			defaultFilter:4,  
			allowNull: true,			
			valueField: 'DicRowId',
			textField: 'DicDesc',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDicToCbo&ResultSetType=array&aDicType="+DicType +"&aAddItem="+AddItem+"&aHospID="+HospID;;
			   	$("#"+ItemCode).combobox('reload',url);
			}
		});
	}		
	return;
}

//Query下拉字典公共方法(取值是code)
function Common_ComboDicCode() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var IsValued= arguments[2];   //是否初始赋值
	if (!IsValued) {
		var cbox = $HUI.combobox("#"+ItemCode, {
			editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
			defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
			allowNull: true,
			valueField: 'Code',
			textField: 'Description',
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType;
			    $("#"+ItemCode).combobox('reload',url);
			} 
		});	
	} else {
		var cbox = $HUI.combobox("#"+ItemCode, {
			url:$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType,
			editable: false,  
			allowNull: true,			
			defaultFilter:4,    
			valueField: 'Code',
			textField: 'Description'
		});	
	}
	return;
}
//Query下拉字典公共方法(取值是ID)
function Common_ComboDicID() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var IsValued= arguments[2];   //是否初始赋值
	if (!IsValued) {
		var cbox = $HUI.combobox("#"+ItemCode, {
			editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
			defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
			allowNull: true,
			valueField: 'myid',
			textField: 'Description', 
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType;
			    $("#"+ItemCode).combobox('reload',url);
			}
		});	
	} else {
		var cbox = $HUI.combobox("#"+ItemCode, {
			url:$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType,
			editable: false,       
			defaultFilter:4,
			allowNull:true,			
			valueField: 'myid',
			textField: 'Description'
		});	
	}	
	return;
}

//多选下拉框(取值是ID)
function Common_ComboMultiDicID(){
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var IsValued= arguments[2];   //是否初始赋值
	
	if (!IsValued) {
		var cbox = $HUI.combobox("#"+ItemCode, {
			valueField:'myid',
			textField:'Description',
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false,
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType;
				$("#"+ItemCode).combobox('reload',url);
			}
		});
	} else {
		var cbox = $HUI.combobox("#"+ItemCode, {
			url:$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType,
			valueField:'myid',
			textField:'Description',
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false
		});
	}
	
}
//多选下拉框(取值是Code)
function Common_ComboMultiDicCode(){
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var IsValued= arguments[2];   //是否初始赋值
	
	if (!IsValued) {
		var cbox = $HUI.combobox("#"+ItemCode, {
			valueField:'Code',
			textField:'Description',
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false,
			onShowPanel: function () {
				var url=$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType;
				$("#"+ItemCode).combobox('reload',url);
			}	
		});
	} else {
		var cbox = $HUI.combobox("#"+ItemCode, {
			url:$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType,
			valueField:'Code',
			textField:'Description',
			multiple:true,
			rowStyle:'checkbox', //显示成勾选行形式
			selectOnNavigation:false,
			panelHeight:"auto",
			editable:false
		});
	}
}

//省市县乡公共方法【死亡证、慢病、食源性疾病、精神疾病用共用的省市县乡字典】
function Common_ComboToArea() {
	var ItemCode = arguments[0];
	var lnkLocCmp = arguments[1];
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'ShortDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMed.SS.AreaDic';
			param.QueryName = 'QryArea';
			param.ResultSetType = 'array';
			param.aParentId = (lnkLocCmp != "1" ? $('#'+lnkLocCmp).combobox('getValue') : 1);
		}
	});
	return;
}
//省市县乡公共方法【初始不加载，死亡证、慢病、食源性疾病、精神疾病用共用的省市县乡字典】
function Common_ComboToArea2() {
	var ItemCode = arguments[0];
	var lnkLocCmp = arguments[1];
	var Flag = arguments[2];
	var cbox = $HUI.combobox("#"+ItemCode, {
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		allowNull: true,
		valueField: 'ID',
		textField: 'ShortDesc',
		onShowPanel: function () {
			var ParentId = (lnkLocCmp != "1" ? $('#'+lnkLocCmp).combobox('getValue') : 1);
			var url=$URL+"?ClassName=DHCMed.SS.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=" + ParentId+ "&aFlag="+Flag;
			$('#'+ItemCode).combobox('reload',url);
		}
	});
	return;
}
//省市县乡公共方法【传染病用单独的省市县乡字典】
function Common_ComboToAreaEpd() {
	var ItemCode = arguments[0];
	var lnkLocCmp = arguments[1];
	var Flag = arguments[2];
	var cbox = $HUI.combobox("#"+ItemCode, {
		url: $URL,
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'ShortDesc',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMed.EPD.AreaDic';
			param.QueryName = 'QryArea';
			param.ResultSetType = 'array';
			param.aParentId = (lnkLocCmp != "1" ? $('#'+lnkLocCmp).combobox('getValue') : 1);
			param.aFlag = Flag;
		}
	});	
	return;
}
//省市县乡公共方法【初始不加载，传染病用单独的省市县乡字典】
function Common_ComboToAreaEpd2() {
	var ItemCode = arguments[0];
	var lnkLocCmp = arguments[1];
	var cbox = $HUI.combobox("#"+ItemCode, {
		editable: true,
		defaultFilter:4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
		valueField: 'ID',
		textField: 'ShortDesc',
		onShowPanel: function () {
			var ParentId = (lnkLocCmp != "1" ? $('#'+lnkLocCmp).combobox('getValue') : 1);
			var url=$URL+"?ClassName=DHCMed.EPD.AreaDic&QueryName=QryArea&ResultSetType=array&aParentId=" + ParentId;
			$('#'+ItemCode).combobox('reload',url);
		}
	});
	return;
}

//至少输入一个字符进行查询
function Common_LookupToICD() {
	var ItemCode = arguments[0];
	var LinkItem = arguments[1];
	
	$("#"+ItemCode).lookup({
		panelWidth:450,
		url:$URL,
		editable: true,
		mode:'remote',      //当设置为 'remote' 模式时，用户输入的值将会被作为名为 'q' 的 http 请求参数发送到服务器，以获取新的数据。
		valueField: 'ICDRowID',
		textField: 'ICDDesc',
		queryParams:{ClassName: 'DHCMed.SSService.CommonCls',QueryName: 'QryICDDxByAlias'},
		columns:[[  
			{field:'ICD10',title:'ICD10',width:80},   
			{field:'ICDDesc',title:'诊断描述',width:360}  
		]],
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;        
			param = $.extend(param,{aAlias:desc}); //将参数q转换为类中的参数
	    },
		onSelect:function(index,rowData){
			 var ICD10=rowData['ICD10'];
			 if (LinkItem) {
				$("#"+LinkItem).val(ICD10);            //给相关的ICD10赋值
			 }
		},
		pagination:true,
		loadMsg:'正在查询',	
		isCombo:true,             //是否输入字符即触发事件，进行搜索
		minQueryLen:1             //isCombo为true时，可以搜索要求的字符最小长度
	});
	return;
}
//多选字典 显示 obj.StatusList = Common_CheckboxToDic("chkStatusList","SPEStatus","");
function Common_CheckboxToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
	var len =dicList.length;		
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
	
	var listHtml=""
	for (var index =0; index< count; index++) {
		var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			var dicDesc=dicSubList[1].replace(/[<>&"]/g,function(c){return {'<':'&lt;','>':'&gt;','&':'&amp;','"':'&quot;'}[c];});
			listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label="+dicDesc+"  name="+ItemCode+"  value="+dicSubList[0]+"></div>";  
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析checkbox	
}
function Common_CheckboxToDicByInd() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByIndNo",
		aType:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
	var len =dicList.length;		
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
	
	var listHtml=""
	for (var index =0; index< count; index++) {
		var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			var dicDesc=dicSubList[1].replace(/[<>&"]/g,function(c){return {'<':'&lt;','>':'&gt;','&':'&amp;','"':'&quot;'}[c];});
			listHtml += " <div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label="+dicDesc+"  name="+ItemCode+"  value="+dicSubList[0]+"></div>";  
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析checkbox	
}
//多选字典取值 Common_CheckboxValue("chkStatusList")
function Common_CheckboxValue() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = value + $(this).val()+ ","; 
	});
	if (value!="") { value = value.substring(0, value.length-1); }
	
	return value;
}

//多选字典取值(label文字描述) Common_CheckboxText("chkStatusList")
function Common_CheckboxLabel() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = value + $(this).attr("label")+ ","; 
	});
	
	if (value!="") { value = value.substring(0, value.length-1); }
	
	return value;
}
//单选字典
function Common_RadioToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			
			listHtml += "<div style='float:left;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='radio' class='hisui-radio' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[1]+" name="+ItemCode+" value="+dicSubList[0]+"></div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}


//复选框样式的单选字典
function Common_chkRadioToDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByType",
		aType:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			listHtml += "<div style='float:left;width:"+per+"'><input id="+dicSubList[0]+" type='radio' class='hisui-radio' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[1]+" name="+ItemCode+" value="+dicSubList[0]+" data-options=radioClass:'hischeckbox_square-blue'></div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}
// 更具排序码，展现复选框样式的单选字典
function Common_chkRadioToDicByInd() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		MethodName:"GetDicsByIndNo",
		aType:DicType,
		aActive:1
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			listHtml += "<div style='float:left;width:"+per+"'><input id="+dicSubList[0]+" type='radio' class='hisui-radio' "+(dicSubList[0]==1? "checked='checked'":"")+" label="+dicSubList[1]+" name="+ItemCode+" value="+dicSubList[0]+" data-options=radioClass:'hischeckbox_square-blue'></div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}
//调查问卷的单选字典
function Common_RadioToSur() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMA.CPW.BTS.SurveySrv",
		MethodName:"GetOptionIDByQues",
		QuestionID:DicType
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
    var len = dicList.length;
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';   //每列所在百分比
	var listHtml=""
	for (var index =0; index< count; index++) {
		var radlen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < radlen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			listHtml += " <div style='display:inline-block;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='radio' class='hisui-radio' "+" label="+dicSubList[1]+" name="+ItemCode+" value="+dicSubList[0]+"></div>";
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
    $.parser.parse('#'+ItemCode);  //解析radio
}
//调查问卷多选字典
function Common_CheckboxToSur() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var columns = arguments[2]? arguments[2] : 4;
	
	var strDicList =$m({
		ClassName:"DHCMA.CPW.BTS.SurveySrv",
		MethodName:"GetOptionIDByQues",
		QuestionID:DicType
	},false);
	
	var dicList = strDicList.split(String.fromCharCode(1));
	var len =dicList.length;		
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
	
	var listHtml=""
	for (var index =0; index< count; index++) {
		var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			var dicDesc=dicSubList[1].replace(/[<>&"]/g,function(c){return {'<':'&lt;','>':'&gt;','&':'&amp;','"':'&quot;'}[c];});
			//listHtml += " <div style='display:inline-block;width:"+per+"'><input id="+ItemCode+"-"+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+(dicSubList[0]==1? "checked='true'":"")+" label="+dicDesc+"  name="+ItemCode+"  value="+dicSubList[0]+"></div>";  
			listHtml += " <div style='display:inline-block;width:"+per+"'><input id="+ItemCode+dicSubList[0]+" type='checkbox' class='hisui-checkbox' "+" label="+dicDesc+"  name="+ItemCode+"  value="+dicSubList[0]+"></div>";  
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析checkbox	
	
}

//单选字典取值
function Common_RadioValue() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
	      value = $(this).val(); 
	});
	return value;
}
//单选字典取值(label文字描述)
function Common_RadioLabel() {
	var ItemCode = arguments[0];
    var value = "";
	$("input[name='"+ItemCode+"']:checked").each(function(){
		  value = $(this).attr("label");
	});
	return value;
}
//单选字典赋值
function Common_SetRadioValue() {
	var ItemCode = arguments[0];
	var value = arguments[1];
	$("input[name='"+ItemCode+"']").each(function(){
	      if ($(this).val() == value) {
			  $(this).radio('setValue',true);
		  }
	});
	return true;
}


//Query多选选字典（不限制展示列,取值为code）
function Common_CheckboxDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];		
	var strList =$m({
		ClassName:"DHCMed.SSService.DictionarySrv",
		QueryName:"QryDictionary",
		ResultSetType:'array',
		aType:DicType
	}, false);
		
	var objStr = JSON.parse(strList);
	var len = objStr.length;
	var listHtml="";
	for (var ind=0; ind < len;ind++) {
		var ValueID    = objStr[ind].myid;
		var ValueCode  = objStr[ind].Code;
		var Value  = objStr[ind].Description;
		listHtml += "<input id="+ItemCode+ValueCode+" type='checkbox' class='hisui-checkbox' label="+Value+" name="+ItemCode+" value="+ValueCode+">";
	}	
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析radio
	
}

//Query单选字典（不限制展示列,取值为code）
function Common_RadioDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];		
	var strList =$m({              //使用同步加载方法，否则后台取值向前台赋值时赋值不上
		ClassName:"DHCMed.SSService.DictionarySrv",
		QueryName:"QryDictionary",
		ResultSetType:'array',
		aType:DicType
	}, false);
	
	var objStr = JSON.parse(strList);
	var len = objStr.length;
	var listHtml="";
	for (var ind=0; ind < len;ind++) {
		var ValueID    = objStr[ind].myid;
		var ValueCode  = objStr[ind].Code;
		var Value  = objStr[ind].Description;
		listHtml += "<input id="+ItemCode+ValueCode+" type='radio' class='hisui-radio' label="+Value+" name="+ItemCode+" value="+ValueCode+">";
	}	
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析radio
}

//复选框样式Query单选字典（不限制展示列,取值为code）
function Common_chkRadioDic() {
	var ItemCode = arguments[0];
	var DicType = arguments[1];		
	var strList =$m({              //使用同步加载方法，否则后台取值向前台赋值时赋值不上
		ClassName:"DHCMed.SSService.DictionarySrv",
		QueryName:"QryDictionary",
		ResultSetType:'array',
		aType:DicType
	}, false);
	
	var objStr = JSON.parse(strList);
	var len = objStr.length;
	var listHtml="";
	for (var ind=0; ind < len;ind++) {
		var ValueID    = objStr[ind].myid;
		var ValueCode  = objStr[ind].Code;
		var Value  = objStr[ind].Description;
		listHtml += "<input id="+ItemCode+ValueCode+" type='radio' class='hisui-radio' label="+Value+" name="+ItemCode+" value="+ValueCode+" data-options=radioClass:'hischeckbox_square-blue'></div>";
	}	
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析radio
}

//日期格式化显示
function Common_FormatDate(date){	
	var LogicalDate = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"DateHtmlToLogical",
		aDate:date
	},false);
	var FormatDate = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"DateLogicalToHtml",
		aDate:LogicalDate
	},false);
	return  FormatDate;
}
//日期时间格式转化 1->3
function Common_Format13DateT(dateTime){
	//如果入惨非指定日期格式，则原值返回
	if (dateTime.indexOf('/')<0)
	{
		return dateTime;
	}
	var Time=dateTime.split(' ')[1];
	var date=dateTime.split(' ')[0];
	var year=date.split('/')[2];
	var month=date.split('/')[1];
	var day=date.split('/')[0];
	var date=year+"-"+month+"-"+day
	if (Time!="") {
		var dateTime=date+" "+Time;
	}else{
		var dateTime=date;
		}
	return  dateTime;
}

function GetDateFormat() {
	var DateFormat ;
    if ("undefined"==typeof dtformat){
        DateFormat = $m({ 
            ClassName:"DHCMed.SSService.CommonCls",
            MethodName:"GetDateFormat"
        },false);
    }else{
        DateFormat = dtformat;
    }
    return DateFormat;
}

//当期日期 时间
function Common_GetDate(date){	
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	var DateFormat = GetDateFormat();
	if (DateFormat=='YMD') {
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}else if (DateFormat=='DMY') {
		return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y;
	}else {
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	}
}

//时间 myDate.toLocaleTimeString()
function Common_GetTime(date){
	var h = date.getHours();
	var m= date.getMinutes();
	var s = date.getSeconds();
	return h+':'+(m<10?('0'+m):m)+':'+(s<10?('0'+s):s);
}

//当期日期 时间
function Common_GetCurrDateTime(date){	
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	var h = date.getHours();
	var mm= date.getMinutes();
	var s = date.getSeconds();
	var DateFormat = GetDateFormat();
	if (DateFormat=='YMD') {	
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+ h + ":" + mm + ":" + s;
	}else if (DateFormat=='DMY') {
		return (d<10?('0'+d):d)+'/'+(m<10?('0'+m):m)+'/'+y+' '+ h + ":" + mm + ":" + s;
	}else {
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d)+' '+ h + ":" + mm + ":" + s;
	}
}

// 判断日期大小		modified by yankai 20221202 修正支持日期时间比较
function  Common_CompareDate(startDateTime,endDateTime){
	if ((typeof(startDateTime)=='undefined')||(typeof(endDateTime)=='undefined')){
		return -1;
	}
	var sttDate=startDateTime.split(" ")[0]
	var sttTime=startDateTime.split(" ")[1]
	var endDate=endDateTime.split(" ")[0]
	var endTime=endDateTime.split(" ")[1]
	
	// 转换为后台数据库格式
	var startDateNum = $m({                  
		ClassName:"DHCMA.Util.IO.FromHisSrv",
		MethodName:"DateHtmlToLogical",
		aDate:sttDate
	},false);
	
	var startTimeNum = $m({                  
		ClassName:"DHCMA.Util.IO.FromHisSrv",
		MethodName:"TimeHtmlToLogical",
		aTime:sttTime
	},false);
	if (startTimeNum=="") startTimeNum=0
	
	var endDateNum = $m({                  
		ClassName:"DHCMA.Util.IO.FromHisSrv",
		MethodName:"DateHtmlToLogical",
		aDate:endDate
	},false);
	
	var endTimeNum = $m({                  
		ClassName:"DHCMA.Util.IO.FromHisSrv",
		MethodName:"TimeHtmlToLogical",
		aTime:endTime
	},false);
	if (endTimeNum=="") endTimeNum=0
	
	if ((startDateNum=='')||(endDateNum=='')){
		return -1;
	}
	if (parseInt(startDateNum)>parseInt(endDateNum)){
		return 1;
	}else if (parseInt(startDateNum) == parseInt(endDateNum)){
		if (parseInt(startTimeNum) > parseInt(endTimeNum)){
			return 1;	
		}else{
			return 0	
		}
	}else{
		return 0;
	}
}
// 判断时间大小
function  Common_CompareTime(astartTime,aendTime){
	if ((typeof(astartTime)=='undefined')||(typeof(aendTime)=='undefined')){
		return -1;
	} 
	// 转换为后台数据库格式
	var startTime = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"TimeHtmlToLogical",
		aTime:astartTime
	},false);
	var endTime = $m({                
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"TimeHtmlToLogical",
		aTime:aendTime
	},false);
	if ((startTime=='')||(endTime=='')){
		return -1;
	}
	if (parseInt(startTime)>parseInt(endTime)){
		return 1;
	}else{
		return 0;
	}
}
// 判断日期是否在三天内
function  Common_CompareDateToNum(startDate,endDate){
	if ((typeof(startDate)=='undefined')||(typeof(endDate)=='undefined')){
		return -1;
	} 
	// 转换为后台数据库格式
	var startDate = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"DateHtmlToLogical",
		aDate:startDate
	},false);
	var endDate = $m({                  
		ClassName:"DHCMed.SSService.CommonCls",
		MethodName:"DateHtmlToLogical",
		aDate:endDate
	},false);
	if ((Math.abs(startDate-endDate))>3){
		return -1;
	}
	else{
		return 1;
	}
}
// 判断时间超过三个月 true:不超过
function checkThreeTime(startDate,endDate){
	//var time1 = new Date(startDate).getTime();
	//时间格式统一
	var DateFormat = GetDateFormat();
	if (DateFormat=='DMY') {
		startDate=startDate.replace(/\//g, '').replace(/^(\d{2})(\d{2})(\d{4})$/,"$3-$2-$1")
		endDate=endDate.replace(/\//g, '').replace(/^(\d{2})(\d{2})(\d{4})$/,"$3-$2-$1")
	}
	var arr1 = startDate.split('-');
	var arr2 = endDate.split('-');
	arr1[1] = parseInt(arr1[1]);
	arr1[2] = parseInt(arr1[2]);
	arr2[1] = parseInt(arr2[1]);
	arr2[2] = parseInt(arr2[2]);
	//判断时间跨度是否大于3个月
	var flag = true;
	if(arr1[0] == arr2[0]){//同年
	    if(arr2[1]-arr1[1] > 3){ //月间隔超过3个月
	        flag = false;
	    }else if(arr2[1]-arr1[1] == 3){ //月相隔3个月，比较日
	        if(arr2[2] > arr1[2]){ //结束日期的日大于开始日期的日
	            flag = false;
	        }
	    }
	}else{ //不同年
	    if(arr2[0] - arr1[0] > 1){
	        flag = false;
	    }else if(arr2[0] - arr1[0] == 1){
	        if(arr1[1] < 10){ //开始年的月份小于10时，不需要跨年
	            flag = false;
	        }else if(arr1[1]+3-arr2[1] < 12){ //月相隔大于3个月
	            flag = false;
	        }else if(arr1[1]+3-arr2[1] == 12){ //月相隔3个月，比较日
	            if(arr2[2] > arr1[2]){ //结束日期的日大于开始日期的日
	                flag = false;
	            }
	        }
	    }
	}

	if(!flag){
	    return false;
	}
	return true;
}


//获取a天之前或a天之后日期
function Common_GetCalDate(a) {	
	var date1 = new Date();
	time1=date1.getFullYear()+"-"+(date1.getMonth()+1)+"-"+date1.getDate();
    var date2 = new Date(date1);
	date2.setDate(date1.getDate() + a);
	
	var year = date2.getFullYear();
	var month = date2.getMonth();
	month++;
	if(month<10) month = '0'+month;
	var day = date2.getDate();
	if(day<10) day = '0'+day;
	
	var DateFormat = GetDateFormat();
	if (DateFormat=='YMD') {
		return time2 =  year+'-'+month+'-'+day;
	}else if (DateFormat=='DMY') {
		return time2 = day+'/'+month+'/'+year;
	}else {
		return time2 = year+'-'+month+'-'+day;
	}
}
//文本框输入特殊字符处理
//oninput 是 HTML5 的标准事件，对于检测 textarea, input:text, input:password 和 input:search 这几个元素通过用户界面发生的内容变化非常有用
CheckSpecificKey = function(){ 
	$('input').bind('input propertychange', function() {
		var value = $(this).val();
		var specialKey = "^";       //特殊字符list
		for (var i = 0; i < value.length; i++) {
			var realkey=value.charAt(i);
			if (specialKey.indexOf(realkey) >= 0) {
				$(this).val($(this).val().replace(realkey,""));  //替换特殊字符
				//layer.alert('请勿输入特殊字符: ' + realkey,{icon: 0});
			}
		}
	});
}

/**
*两种调用方式
*var template1="我是{0}，今年{1}了";
*var template2="我是{name}，今年{age}了";
*var result1=template1.format("loogn",22);
*var result2=template2.format({name:"loogn",age:22});
*两个结果都是"我是loogn，今年22了"
*/
String.prototype.format = function (args) {
    var result = this;
    if (arguments.length > 0) {
        if (arguments.length == 1 && typeof (args) == "object") {
            for (var key in args) {
                if (args[key] != undefined) {
                    var reg = new RegExp("({" + key + "})", "g");
                    result = result.replace(reg, args[key]);
                }
            }
        }
        else {
            for (var i = 0; i < arguments.length; i++) {
                if (arguments[i] != undefined) {
                    //var reg = new RegExp("({[" + i + "]})", "g");//这个在索引大于9时会有问题
                    var reg = new RegExp("({)" + i + "(})", "g");
                    result = result.replace(reg, arguments[i]);
                }
            }
        }
    }
    return result;
};

//add by jiangpengpeng
//IE8下数组不支持IndexOf方法
//添加数组IndexOf方法
if (!Array.prototype.indexOf){
  Array.prototype.indexOf = function(elt /*, from*/){
    var len = this.length >>> 0;

    var from = Number(arguments[1]) || 0;
    from = (from < 0)
         ? Math.ceil(from)
         : Math.floor(from);
    if (from < 0)
      from += len;

    for (; from < len; from++){
      if (from in this && this[from] === elt)
        return from;
    }
    return -1;
  };
}
//IE8下数组不支持forEach方法
//添加数组forEach方法
if ( !Array.prototype.forEach ) {

  Array.prototype.forEach = function forEach( callback, thisArg ) {

    var T, k;

    if ( this == null ) {
      throw new TypeError( "this is null or not defined" );
    }
    var O = Object(this);
    var len = O.length >>> 0; 
    if ( typeof callback !== "function" ) {
      throw new TypeError( callback + " is not a function" );
    }
    if ( arguments.length > 1 ) {
      T = thisArg;
    }
    k = 0;

    while( k < len ) {

      var kValue;
      if ( k in O ) {

        kValue = O[ k ];
        callback.call( T, kValue, k, O );
      }
      k++;
    }
  };
}
function dispalyEasyUILoad() {
    $(".datagrid-mask").remove();
    $(".datagrid-mask-msg").remove();
}

//列排序方法(数字、日期类型)
function Sort_int(a,b) {
    if (a.length > b.length) return 1;
    else if (a.length < b.length) return -1;
    else if (a > b) return 1;
    else return -1;
}

// 分页数据的操作(查询界面导出功能用到)
function pagerFilter(data) {
	if (typeof data.length == 'number' && typeof data.splice == 'function') {	//  判断数据是否是数组
		data = {
			total: data.length,
			rows: data
		}
	}
	
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	var sortName = opts.sortName;
    var sortOrder = opts.sortOrder;
 	
 	if (!data.originalRows) {
        data.originalRows = data.rows;
	}
    if ((!opts.remoteSort)&& (sortName != null)) {	    
        data.originalRows.sort(function (obj1, obj2) {
            var val1 = obj1[sortName];
            var val2 = obj2[sortName];
            if (!isNaN(Number(val1)) && !isNaN(Number(val2))) {
                val1 = Number(val1);
                val2 = Number(val2);
            }
            var $sorter = dg.datagrid("getColumnOption", sortName).sorter;  //sorter排序方法
            if ($sorter) {
                return (sortOrder == "asc") ? $sorter(val1, val2) : $sorter(val2, val1);
            } else {
                if(val1<val2){
                    return (sortOrder == "desc") ? 1 : -1;
                } else if (val1 > val2) {
                    return (sortOrder == "desc") ? -1 : 1;
                } else {
                    return 0
                }
            }
        })
    }
     
    if (!opts.pagination)    //是否分页
        return data;
	pager.pagination({
		onSelectPage: function (pageNum, pageSize) {
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh', {
				pageNumber: pageNum,
				pageSize: pageSize
			});
			dg.datagrid('loadData', data);
		}
	});
	
	//翻页后查询数据变化，第一次显示空白问题处理
	if (data.originalRows.length<=opts.pageSize) opts.pageNumber=1;  
	if ((data.originalRows.length>opts.pageSize)&&(data.originalRows.length<=((opts.pageNumber-1)*opts.pageSize))) {
	   opts.pageNumber = Math.ceil(data.originalRows.length/opts.pageSize);  //向上取整
	}
	var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
	var end = start + parseInt(opts.pageSize);
	data.rows = (data.originalRows.slice(start, end));
	return data;
}

function Common_ComboGrpDicID(){
	var ItemCode = arguments[0];
	var DicType = arguments[1];
	var cbox = $HUI.combobox("#"+ItemCode, {
		editable: false,       //因测试组测试输入非字典内容，小字典统一不允许编辑
		valueField: 'myid',
		textField: 'Description', 
		multiple:true,
		allowNull: true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCMed.SSService.DictionarySrv&QueryName=QryDictionary&ResultSetType=array&aType="+DicType;
		    $("#"+ItemCode).combobox('reload',url);
		},
		filter: function(q, row){
			return (row["Description"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	});
	return;
}
function Common_CheckboxToSDRule() {
	var ItemCode = arguments[0];
	var ParRef	 = arguments[1];
	var RuleType = arguments[2];
	var columns	 = arguments[3]? arguments[3] : 4;;
	var strDicList =$m({
		ClassName:"DHCMA.CPW.SDS.QCEntityMatchRuleSrv",
		MethodName:"GetRulesByParref",
		aParRef:ParRef,
		aRuleType:RuleType
	},false);
	var dicList = strDicList.split(String.fromCharCode(1));
	if (dicList[0]=="") {$('#'+ItemCode).html(""); return;}
	var len =dicList.length;	
	if (len==1) {
		var checkStyle=" type='radio' class='hisui-radio' "
	}else{
		var checkStyle=" type='checkbox' class='hisui-checkbox' "
	}	
	var count = parseInt(len/columns)+1;
	var per = Math.round((1/columns) * 100) + '%';  //每列所在百分比，等比分布
	var style = document.body.currentStyle || document.defaultView.getComputedStyle(document.body, '')
    var dFontSize=style.fontSize.replace('px','');
	var divWidth=524;   //默认弹窗原因宽度
	var listHtml=""
	for (var index =0; index< count; index++) {
		var chklen=(((index+1)*columns)<len) ? (index+1)*columns : len;
		listHtml +="<div>"; 
		for (var dicIndex = index*columns; dicIndex < chklen; dicIndex++) {	
			var dicSubList = dicList[dicIndex].split(String.fromCharCode(2));
			var divWordCount=Math.floor(divWidth/dFontSize)
			var divheight=Math.ceil(dicSubList[1].length/divWordCount)*20
			listHtml += "<div style='height:"+divheight+"px'><input id="+ItemCode+dicSubList[0]+checkStyle+(dicSubList[0]==1? "checked='true'":"")+" label= '"+dicSubList[1]+"'  name="+ItemCode+"  value="+dicSubList[0]+"></div>";  
		} 
		listHtml +="</div>"
	}
	$('#'+ItemCode).html(listHtml); 
	$.parser.parse('#'+ItemCode);  //解析checkbox	
	
}
//扩展datagrid:动态添加删除editor
$.extend($.fn.datagrid.methods, {    
    addEditor : function(jq, param) {   
        if (param instanceof Array) {   
            $.each(param, function(index, item) {  
                var e = $(jq).datagrid('getColumnOption', item.field); 
                e.editor = item.editor; }); 
            } else {    
                var e = $(jq).datagrid('getColumnOption', param.field);    
                e.editor = param.editor;  
            }   
        },  
    removeEditor : function(jq, param) {    
        if (param instanceof Array) {   
            $.each(param, function(index, item) {  
                var e = $(jq).datagrid('getColumnOption', item);   
                e.editor = {};  
                }); 
        } else {    
            var e = $(jq).datagrid('getColumnOption', param);
            e.editor = {};  
        }   
    }
});
function Common_CreateMonth() {
	var domId = arguments[0];
	$("#" + domId).datebox({
		validParams:"YM",
        parser: function (s) {//配置parser，返回选择的日期
            if (!s) return new Date();
            var arr = s.split('-');
            return new Date(parseInt(arr[0], 10), parseInt(arr[1], 10) - 1, 1);
        }, 
        formatter: function (d) {
			var Month=parseInt(d.getMonth())+1;
            return d.getFullYear() + '-' + (Month < 10 ? ('0' + Month) : Month);
        }//配置formatter，只返回年月
    });
	var curr_time =new Date();
        $("#" + domId).datebox("setValue",month_formatter(curr_time));
}
 //格式化日期，仅年月
function month_formatter(date) {
	//获取年份
	var y = date.getFullYear();
	//获取月份
	var m = date.getMonth() + 1;
	return y + '-' + m;
}

//获得病历浏览csp配置
var cspUrl = $m({                  
	ClassName:"DHCMA.Util.BT.Config",
	MethodName:"GetValueByCode",
	aCode:"SYSEmrCSP",
	aHospID:session['DHCMA.HOSPID']||""
},false);
//浏览电子病历公用打开方法
function Common_showEMR(){
	var EpisodeID=arguments[0];
	var PatientID=arguments[1];
 	var modal=arguments[2];
 	if (typeof PatientID == 'undefined') PatientID = '';
 	if (typeof modal == 'undefined') modal = '';
 	if (cspUrl=="") cspUrl="./epr.newfw.episodelistbrowser.csp?"
 	var strUrl = cspUrl+"&EpisodeID=" + EpisodeID + "&PatientID=" + PatientID + "&2=2";
 	if (modal) {
		websys_showModal({
			url:strUrl,
			title:"病历浏览",
			iconCls:'icon-w-epr',
			originWindow:window,
			isTopZindex:true,
			width:'98%',
			height:'98%'
		})
	}else{
		if (typeof websys_getMWToken == 'function') strUrl = strUrl + '&MWToken=' + websys_getMWToken();
	  var r_width = window.screen.availWidth-50;
		var r_height = window.screen.availHeight-100;
		var v_left = (window.screen.availWidth - 10 - r_width) / 2;		// 获得窗口的水平位置;
		var v_top = (window.screen.availHeight - 30 - r_height) / 2;	// 获得窗口的垂直位置;
		var r_params = "left=" + v_left +
						",top=" + v_top + 
						",width=" + r_width + 
						",height=" + r_height + 
						",status=yes,toolbar=no,menubar=no,location=no";
		window.open(strUrl, "_blank", r_params);
	}
}
//验证手机号
function Common_CheckPhone(){
	var telNumber=arguments[0];
	var cType=arguments[1];
	if (typeof(telNumber) !== 'string'){
		 return false;
	}
	if (!cType) {  
		 return (telNumber.length==11)
	}else{    
		//验证手机号+座机号
		return /(^(0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$)|(^(()|(\d{3}\-))?(1[358]\d{9})$)/.test(telNumber)
	}	
}


//***搜索框功能  只针对前台分页查询的正常展示列***//
Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
};

/*
*1.searchText()方法支持前台分页查询方式的全部数据检索
*2.如果检索的表格数据可能发生变化（有增、删、改功能），在重新加载数据前需清除初始数据
*3.如果一个界面只有一个检索表格，清除数据可直接写originalData =""，如果是多个检索表格，清除数据需指明清除的表格名称：originalData["表格id"] =""
*/
var originalData =new Array();   //初始数据
function searchText(dg,t){ //参数：$("#datagrid")   
	var tempIndex=[];	   //匹配行	
	var state = dg.data('datagrid');
	var tmptable = state.options.id;   //查询的表格
	if ((! originalData[tmptable])||((originalData[tmptable].length)=='0')) {
	     var rows = state.data.originalRows||state.originalRows; 
	   	 originalData[tmptable] = {
			total: rows.length,
			rows: rows
		}
    } else {
	    var rows = originalData[tmptable].originalRows||originalData[tmptable].rows;
    }

    var columns = dg.datagrid('getColumnFields');
    var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
	
    var searchVal = t;
    if (searchVal) {
	    for(var i=0;i<rows.length;i++){
	        for(var j=1;j<columns.length;j++){
		        var col = dg.datagrid('getColumnOption', fields[j]);
		        if((col.hidden == true)||(col.checkbox == true)) {  //隐藏列、复选框列
					continue;
				}
				if(col.formatter) {   //链接、格式化函数列
					continue;
				}	
				if(!col.title) {  //无标题（非前台展示列）
					continue;
				}
	            if((rows[i][columns[j]])&&(rows[i][columns[j]].indexOf(searchVal)>=0)){
	                if(!tempIndex.contains(i)){
	                    tempIndex.push(i);
	                    break;
	                }
	            }
	        }
	    }
	   var RowsData=[];
	   for(var rowIndex=0;rowIndex<tempIndex.length;rowIndex++){  //匹配行
		    var Index = tempIndex[rowIndex];
		    var row = rows[Index];
		    RowsData.push(row);   
	    }
	    data = {  //搜索数据
			total: tempIndex.length,
			rows: RowsData
		}
		dg.datagrid('loadData', data);
	}else {
		dg.datagrid('loadData', originalData[tmptable]);
		originalData[tmptable]="";
	}
}

// 检查删除按钮是否可用
function chkDelBtnIsAble(code){
	var flg = $m({                  
		ClassName:"DHCMA.Util.BT.DeleteControl",
		MethodName:"GetAllowDel",
		aCode:code
	},false);
	
	if (parseInt(flg)==1){return true;}
	else{ return false;}	 
}

/**
 * @description CA签名的弹窗验证
 * @param {string} productCode 产品代码
 * @param {string} modelCode 签名模块中代码(基础平台中配置)
 * @param {Object} configCACert CA签名的配置项
 * @param {function} succFunc 成功后调用的方法，该方法调用的参数跟在succFunc的后面
 * @author mayanpeng 2021-06-21
 * */
function CASignLogonModal(productCode, modelCode, configCACert, succFunc) {
	if (productCode == '' || modelCode == '' || typeof succFunc != 'function') {
		$.messager.alert("错误","参数不能为空!",'error');
		return false;
	}
	if (typeof configCACert.dhcmaModuleType == 'undefined') configCACert.dhcmaModuleType = productCode;		//默认值处理
	var succFuncArgs =new Array();
	for (var i=4; i<arguments.length; i++) {succFuncArgs.push(arguments[i])}			//succFunc方法的参数(第5个开始)
	
	//configCACert可传配置
	var CACertOption = {
		logonType: "",			// UKEY|PHONE|FACE|SOUND|"" 空时弹出配置签名方式，其它弹出固定方式
		singleLogon: 0, 		//0-弹出多页签签名，1-单种签名方式
		forceOpen: 0,			//1-强制每次都弹出签名窗口
		ModalOption: {
			isHeaderMenuOpen: true,	//是否在头菜单打开签名窗口. 默认true
			SignUserCode: "",		//期望签名人HIS工号，会校验证书用户与HIS工号. 默认空
			signUserType: "",		//默认空，表示签名用户与当前HIS用户一致。ALL时不验证用户与证书
			notLoadCAJs: 1,			//登录成功后，不向头菜单加载CA
			loc: "",				//科室id或描述，默认当前登录科室
			groupDesc: "",			//安全组描述，默认当前登录安全组
			caInSelfWindow: 1		//用户登录与切换科室功能， 业务组不用
		},
		signSave: true,			//是否在基础平台保存签名(默认true保存)
		signData: '',			//在基础平台要签名的数据(保存签名时该值必填，否则不会保存，如报卡保存时为obj.SaveToString())
		dhcmaSignSave: true,	//是否在DHCMA保存签名(默认true保存，保存前提是在基础平台保存成功，否则不保存)
		dhcmaSaveData: '',		//在DHCMA保存的数据(默认存储succFunc的返回值，如报卡为报告ID)
		dhcmaModuleType: '',	//在DHCMA保存的报告类型(默认为产品代码，特殊报告如EPD下的新冠个案调查表则传NCP)
		dhcmaOperaType: 'S'		//在DHCMA保存的操作类型(默认为保存报告S)
	}
	$.extend(true, CACertOption, configCACert);	//jquery深拷贝
	
	//判断是否上线CA
	if (typeof dhcsys_getcacert != 'function') {
		//直接执行签名成功后的方法
		var succFuncReturn = succFunc.apply(this, succFuncArgs);
		if (CACertOption.dhcmaSaveData != '') succFuncReturn = CACertOption.dhcmaSaveData;		//默认值处理
		return succFuncReturn;
	}
	
	//获得是否启用CA系统配置
	var SYSCASignActive = $m({ClassName:"DHCMA.Util.BT.Config", MethodName:"GetValueByCode", aCode:"SYSCASignActive", aHospID:session['DHCMA.HOSPID']||""},false);
	//获得是否启用CA产品配置(优先)
	var ProductCASignActive = $m({ClassName:"DHCMA.Util.BT.Config", MethodName:"GetValueByCode", aCode:productCode+"CASignActive", aHospID:session['DHCMA.HOSPID']||""},false);
	
	//以产品配置中是否启用CA为优先，未维护时再判断系统配置中的配置
	if (ProductCASignActive === '0' || ProductCASignActive === 'false') {
		//直接执行签名成功后的方法
		var succFuncReturn = succFunc.apply(this, succFuncArgs);
		if (CACertOption.dhcmaSaveData != '') succFuncReturn = CACertOption.dhcmaSaveData;		//默认值处理
		return succFuncReturn;
	} else if (ProductCASignActive === '' && SYSCASignActive == false) {
		//直接执行签名成功后的方法
		var succFuncReturn = succFunc.apply(this, succFuncArgs);
		if (CACertOption.dhcmaSaveData != '') succFuncReturn = CACertOption.dhcmaSaveData;		//默认值处理
		return succFuncReturn;
	}
	
	//组装基础平台的配置
	var CALoginModalOption = {
		modelCode: modelCode,		//签名模块中代码
		callback:function(cartn){
			// 签名窗口关闭后,会进入这里
			if (cartn.IsSucc){
				//执行签名成功后的方法
				var succFuncReturn = succFunc.apply(this, succFuncArgs);
				//科室(或用户)未启用CA验证不用签名，cartn.ContainerName为空表示未启用
				if (cartn.ContainerName != "") {
					if (CACertOption.signSave && "object" == typeof cartn && cartn.ContainerName != "") {
						var hashData = cartn.ca_key.HashData(CACertOption.signData);
						var signData = cartn.ca_key.SignedData(hashData, cartn.ContainerName);
						if (signData ==""){
						   $.messager.alert("错误","SignedData 方法失败 签名值为空!",'error');
						   return false;
						} else {
							var userCertCode = cartn.CAUserCertCode;
							var certNo = cartn.CACertNo;
							//调用基础平台保存签名数据方法
							//1.ca用户唯一标识,2.产品代码比如EMR\DOC\NUR,3.原文Hash,4.签名值,5.ca证书唯一标识
							var SignStr = $m({
								ClassName:"CA.DigitalSignatureService",
								MethodName:"Sign",
								UsrCertCode: userCertCode,
								code: productCode,
								contentHash: hashData,
								signValue: signData,
								certNo: certNo
							},false);
							
							if (SignStr.split('^')[0] == 1 && CACertOption.dhcmaSignSave){
								if (CACertOption.dhcmaSaveData != '') succFuncReturn = CACertOption.dhcmaSaveData;		//默认值处理
								//调用DHCMA保存签名数据方法
								var BaseStr = productCode+"^"+CACertOption.dhcmaModuleType+"^"+succFuncReturn+"^"+session['LOGON.USERID']+"^"+CACertOption.dhcmaOperaType;
								var Sign = $m({
									ClassName:"DHCMed.CA.SignVerify",
									MethodName:"SaveSign",
									aBaseInfo: BaseStr,
									aSignID: SignStr.split('^')[1],
									aUserCertCode: userCertCode,
									aHashData: hashData,
									aSignedData: signData,
									aCertNo: certNo
								},false);
								return succFuncReturn;
							}else {
								$.messager.alert("错误", "保存签名信息失败！"+SignStr.split('^')[1], 'error');
								return false;
							}
						}
					}
				}
			 }else {
				$.messager.alert("错误", "签名失败！" ,'error');
				return false;
			 }
		}
	}
	if (typeof configCACert.ModalOption == 'object' && Object.keys(configCACert.ModalOption).length > 0) {
		$.extend(true, CALoginModalOption, configCACert.ModalOption);
	}
	// 基础平台弹出证书验证窗口
	dhcsys_getcacert(CALoginModalOption, configCACert.logonType, configCACert.singleLogon, configCACert.forceOpen);
}

/**
 * @description Lodop打印走Session
 * @param {Object} LODOP ：通过getLodop()获取到的LODOP对象
 * @param {string} url： 需要打印的CSP
 * @param {string} Top： 打印项在纸张内的上边距
 * @param {string} Left： 打印项在纸张内的左边距
 * @param {string} RightMargin： 打印区域相对于纸张的“右边距”
 * @param {string} BottomMargin： 打印区域相对于纸张的“下边距”
 * @author mayanpeng 2022-11-03
 * @usage LodopPrintURL(LODOP,"dhcpedjdtemplate.header.csp?PAADM=660")
 * */
function LodopPrintURL(LODOP,url,Top,Left,RightMargin,BottomMargin) {
	var xmlHttp;
	if ((typeof IsPrint=="undefined")||(IsPrint=="")) IsPrint = true;
	if ((typeof Top=="undefined")||(Top=="")) Top = "5mm";
	if ((typeof Left=="undefined")||(Left=="")) Left = "5mm";
	if ((typeof RightMargin=="undefined")||(RightMargin=="")) RightMargin = "1mm";
	if ((typeof BottomMargin=="undefined")||(BottomMargin=="")) BottomMargin = "1mm";
    if (url == "") {
		$.messager.alert("错误", "请输入网页地址！" ,'error');
        return;
    }
	if (typeof websys_getMWToken == 'function') url = url + '&MWToken=' + websys_getMWToken();
    if (window.XMLHttpRequest) {
       xmlHttp = new XMLHttpRequest();                  //FireFox、Opera等浏览器支持的创建方式
    } else {
       xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");//IE浏览器支持的创建方式
    }
    xmlHttp.onreadystatechange = function(){	 //设置回调函数
	    if (xmlHttp.readyState == 4) {
		    LODOP.ADD_PRINT_HTM(Top,Left,"RightMargin:"+RightMargin,"BottomMargin:"+BottomMargin,xmlHttp.responseText);
   	 	}
	}; 
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
}

// url传参替换特殊字符处理公共方法
function ReplaceURLSpecialChar(str){
	if (str == undefined || str == "" || str == null) return "";
	str=str.replace("/\#/g", '%23')
	str=str.replace("/\%/g", '%25')
	str=str.replace("/\&/g", '%26')
	str=str.replace("/\+/g", '%2B')
	str=str.replace("/\//g", '%2F')
	str=str.replace("/\\/g", '%5C')
	str=str.replace("/\=/g", '%3D')
	str=str.replace("/\?/g", '%3F')
	str=str.replace("/\ /g", '%20')
	str=str.replace("/\./g", '%2E')
	str=str.replace("/\:/g", '%3A')
	return str
}
//快速选择日期(2021-06-02 ShenC)
function Date_QuickSelect(){
	var YearCode = arguments[0];
	var MonthCode = arguments[1];
	var DateFromCode = arguments[2];
	var DateToCode = arguments[3];
	
	var Year = $('#'+YearCode).combobox('getValue');	//年
	var Month 	= $('#'+MonthCode).combobox('getValue');	//月+季度
	if((Year=="")||(Month=="")) return;
		
	if((Month>=1)&&(Month<=12)){	//月
		$('#'+DateFromCode).datebox('setValue', Year+"-"+Month+"-01");    // 日期初始赋值
		var todayDate = new Date(Year,Month,0)   
		var Day=todayDate.getDate();    //31
		$('#'+DateToCode).datebox('setValue', Year+"-"+Month+"-"+Day);    // 日期初始赋值
	}
	if(Month.indexOf("JD")>=0){
		if(Month.indexOf("JD1")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-01-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-03-31");    // 日期初始赋值
		}
		if(Month.indexOf("JD2")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-04-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-06-30");    // 日期初始赋值
		}
		if(Month.indexOf("JD3")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-07-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-09-30");    // 日期初始赋值
		}
		if(Month.indexOf("JD4")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-10-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-12-31");    // 日期初始赋值
		}
	}
	if(Month.indexOf("BN")>=0){
		if(Month.indexOf("BN1")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-01-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-06-30");    // 日期初始赋值
		}
		if(Month.indexOf("BN2")>=0){
			$('#'+DateFromCode).datebox('setValue', Year+"-07-01");    // 日期初始赋值
			$('#'+DateToCode).datebox('setValue', Year+"-12-31");    // 日期初始赋值
		}
	}
	if(Month.indexOf("QN")>=0){
		$('#'+DateFromCode).datebox('setValue', Year+"-01-01");    // 日期初始赋值
		$('#'+DateToCode).datebox('setValue', Year+"-12-31");    // 日期初始赋值
	}
}