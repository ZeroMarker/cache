///wfg 2019-8-16  导入数据
//readAsBinaryString function is not defined in IE
//Adding the definition to the function prototype
if (!FileReader.prototype.readAsBinaryString) {
	console.log('readAsBinaryString definition not found');
	FileReader.prototype.readAsBinaryString = function (fileData) {
		var binary = '';
		var pk = this;
		var reader = new FileReader();
		reader.onload = function (e) {
			var bytes = new Uint8Array(reader.result);
			var length = bytes.byteLength;
			for (var i = 0; i < length; i++) {
				var a = bytes[i];
				var b = String.fromCharCode(a)
				binary += b;
			}
			pk.content = binary;
			$(pk).trigger('onload');
		}
		reader.readAsArrayBuffer(fileData);
	}
}
var init = function() {
	var ClearMain=function(){
		$UI.clearBlock('#Conditions');
		$UI.clear(DataGrid);
		$('#File').filebox('clear');
		$('#Msg').panel({'content':" "});
		ChangeButtonEnable({'#CheckBT':false,'#ImportBT':false,'#TestImportBT':false,'#ClearBT':false,'#ReadBT':true});
	}
	$('#File').filebox({
		buttonText: '选择',
		prompt:'请选择要导入的Excel',
		accept:'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		width: 180
		/**
		onChange:function(nv,ov){
			var wb;   //wookbook
			var Type = $("input[name='Type']:checked").val();
			if(isEmpty(Type)){
				$UI.msg('alert','数据类型不能为空!')
				return;
			}
			var filelist=$('#File').filebox("files");
			if(filelist.length==0){
				$UI.msg('alert','请选择要导入的Excel!')
				return 
			}
			showMask();
			var file = filelist[0];
      		var reader = new FileReader();
	        reader.onload = function(e) {
	            if (reader.result){reader.content = reader.result;}
				//In IE browser event object is null
				var data = e ? e.target.result : reader.content;
				//var baseEncoded = btoa(data);
				//var wb = XLSX.read(baseEncoded, {type: 'base64'});
	            wb = XLSX.read(data, {
	                    type: 'binary'
	                });
	            var json=to_json(wb)
	            $("#DataGrid").datagrid("loadData",json);
	            ChangeButtonEnable({'#CheckBT':true,'#ImportBT':false,'#ClearBT':true,'#ReadBT':true});
	            hideMask();
	            }
        	reader.readAsBinaryString(file);
		}
		**/
		
	})	
	$HUI.radio("[name='Type']",{
        onChecked:function(e,value){
            ChangeCm($(e.target).attr("value"));  //输出当前选中的value值
        }
    });
	
	function ChangeCm(CmType){
		$UI.clear(DataGrid);
    	$UI.datagrid('#DataGrid', {	
        queryParams: {
			ClassName: '',
			QueryName: ''				
		},
		pagination:false,
		toolbar:'#operatorBar',
		remoteSort:false,
		columns: CmObj[CmType]
		}) 	
	}
	$UI.linkbutton('#LoadBT',{  //下载模板
		onClick:function(){
			window.open("../scripts/cssd/System/Excel模板.zip", "_blank");
		}
	});	
	$UI.linkbutton('#ReadBT',{  //读取数据
		onClick:function(){
			var wb;   //wookbook
			var Type = $("input[name='Type']:checked").val();
			if(isEmpty(Type)){
				$UI.msg('alert','数据类型不能为空!')
				return;
			}
			var filelist=$('#File').filebox("files");
			if(filelist.length==0){
				$UI.msg('alert','请选择要导入的Excel!')
				return 
			}
			showMask();
			var file = filelist[0];
      		var reader = new FileReader();
	        reader.onload = function(e) {
	            if (reader.result){reader.content = reader.result;}
				//In IE browser event object is null
				var data = e ? e.target.result : reader.content;
				//var baseEncoded = btoa(data);
				//var wb = XLSX.read(baseEncoded, {type: 'base64'});
	            wb = XLSX.read(data, {
	                    type: 'binary'
	                });
	            var json=to_json(wb)
	            $("#DataGrid").datagrid("loadData",json);
	            ChangeButtonEnable({'#CheckBT':true,'#ImportBT':false,'#ClearBT':true,'#ReadBT':true});
	            hideMask();
	            }
        	reader.readAsBinaryString(file);
		}
	});
	function to_json(workbook) {
		//取 第一个sheet 数据
	    var jsonData={};
		var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);
		jsonData.rows=result;
		jsonData.total=result.length
		return jsonData//JSON.stringify(jsonData);
	};
	$UI.linkbutton('#TestImportBT',{  //测试导入
		onClick:function(){
			ChangeButtonEnable({'#CheckBT':false,'#TestImportBT':false,'#ImportBT':true,'#ClearBT':true,'#ReadBT':true});;
		}
	});
	$UI.linkbutton('#ImportBT',{  //导入
		onClick:function(){
			Save();
		}
	});
	var Save=function(){
		var Type=$("input[name='Type']:checked").val();
		if(isEmpty(Type)){
			$UI.msg('alert','数据类型不能为空!')
			return;
		}
		var RowsObject=DataGrid.getRows();		
		var Rows=DataGrid.getRows();
		if(Rows.length==0){
			$UI.msg('alert','没有需要上传的数据!')
			return;
		}
		Rows=JSON.stringify(Rows)
		//alert(Object.keys(RowsObject).length);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.System.DataInput',
			MethodName: 'DataInput',
			Rows: Rows,
			Type:Type,
			RowsLength:Object.keys(RowsObject).length
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$('#Msg').panel({'content':jsonData.msg})
			}else{
				$('#Msg').panel({'content':jsonData.msg})
				//$UI.msg('error',jsonData.msg);		
			}
		});
	}
	$UI.linkbutton('#CheckBT',{  //检测数据
		onClick:function(){
			var Type=$("input[name='Type']:checked").val();
				if(isEmpty(Type)){
					$UI.msg('alert','数据类型不能为空!')
					return;
				}
			showMask();
			if(CheckObj()===false){
				hideMask();
				$UI.msg('error','数据校验不通过!');
				return;
			}
			hideMask();
			$UI.msg('success','数据校验通过!');
			ChangeButtonEnable({'#CheckBT':true,'#TestImportBT':true,'#ImportBT':true,'#ClearBT':true,'#ReadBT':true});
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			ClearMain();
		}
	});
	var CheckObj=function(){
		var CheckField = [];
		var opt = DataGrid.options();
		for (var i = 0; i < opt.columns[0].length; i++) {
			if (opt.columns[0][i].checknull === true) {
				CheckField.push(opt.columns[0][i].field);
			}
		}
		var Rows = DataGrid.getRows();
		var len = Rows.length;
		var CheckFlag = true;
		var RecordArr = [];
		for (var i = 0; i < len; i++) {
			var Msg = "";
			var Record = Rows[i];
			for (var j = 0; j < CheckField.length; j++) {
				var val = Record[CheckField[j]];
				if (isEmpty(val)) {
					Msg = Msg + '第' + (i + 1) + '行' + CheckField[j] + "不能为空!";
					CheckFlag = false;
				}
			}
			if (isEmpty(Msg)) {
				Msg = "√";
			} else {
				$('#DataGrid').datagrid('highlightRow', i);
			}
			Record["校验信息"] = Msg;
			RecordArr.push(Record);
		}
		$('#DataGrid').datagrid('loadData', RecordArr);
		return CheckFlag;
		}
	var CmObj={
		Package:[[{
			title: '消毒包编码',
			field: '消毒包编码',
			checknull:true,
			width:100
		}, {
			title: '消毒包名称',
			field: '消毒包名称',
			checknull:true,
			width:100
		}, {
			title: '消毒包别名',
			field: '消毒包别名',
			width:100
		},{
			title: '消毒包分类',
			field: '消毒包分类',
			checknull:true,
			width:100
		},{
			title: '包类型',
			field: '包类型',
			checknull:true,
			width:100
		},{
			title: '消毒包属性',
			field: '消毒包属性',
			checknull:true,
			width:100
		},{
			title: '价格',
			field: '价格',
			width:100
		},{
			title: '单位',
			field: '单位',
			width:100
		},{
			title: '灭菌方式',
			field: '灭菌方式',
			checknull:true,
			width:100
		},{
			title: '使用标志',
			field: '使用标志',
			width:100
		},{
			title: '接收科室',
			field: '接收科室',
			width:100
		},{
			title: '消毒包基数',
			field: '消毒包基数',
			width:100
		},{
			title: '有效期',
			field: '有效期',
			checknull:true,
			width:100
		}
		]],
		PackageItem:[[{
			title: '消毒包名称',
			field: '消毒包名称',
			checknull:true,
			width:100
		}, {
			title: '消毒器械名称',
			field: '消毒器械名称',
			checknull:true,
			width:100
		}, {
			title: '消毒包器械规格',
			field: '消毒包器械规格',
			width:100
		},{
			title: '消毒包器械价格',
			field: '消毒包器械价格',
			width:100
		},{
			title: '使用标志',
			field: '使用标志',
			width:100
		},{
			title: '器械数量',
			field: '器械数量',
			checknull:true,
			width:100
		},{
			title: '备注',
			field: '备注',
			width:100
		}
		]]
	}
	var DataGrid = $UI.datagrid('#DataGrid', {
		queryParams: {
			ClassName: '',
			QueryName: ''				
		},
		toolbar:'#UomTB',
		remoteSort:false,
		pagination:false,
		columns: CmObj.Package,
		singleSelect:true
	})
	ClearMain();
}
$(init);
