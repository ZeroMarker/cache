///wfg 2019-8-16  ��������
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
		buttonText: 'ѡ��',
		prompt:'��ѡ��Ҫ�����Excel',
		accept:'application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
		width: 180
		/**
		onChange:function(nv,ov){
			var wb;   //wookbook
			var Type = $("input[name='Type']:checked").val();
			if(isEmpty(Type)){
				$UI.msg('alert','�������Ͳ���Ϊ��!')
				return;
			}
			var filelist=$('#File').filebox("files");
			if(filelist.length==0){
				$UI.msg('alert','��ѡ��Ҫ�����Excel!')
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
            ChangeCm($(e.target).attr("value"));  //�����ǰѡ�е�valueֵ
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
	$UI.linkbutton('#LoadBT',{  //����ģ��
		onClick:function(){
			window.open("../scripts/cssd/System/Excelģ��.zip", "_blank");
		}
	});	
	$UI.linkbutton('#ReadBT',{  //��ȡ����
		onClick:function(){
			var wb;   //wookbook
			var Type = $("input[name='Type']:checked").val();
			if(isEmpty(Type)){
				$UI.msg('alert','�������Ͳ���Ϊ��!')
				return;
			}
			var filelist=$('#File').filebox("files");
			if(filelist.length==0){
				$UI.msg('alert','��ѡ��Ҫ�����Excel!')
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
		//ȡ ��һ��sheet ����
	    var jsonData={};
		var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);
		jsonData.rows=result;
		jsonData.total=result.length
		return jsonData//JSON.stringify(jsonData);
	};
	$UI.linkbutton('#TestImportBT',{  //���Ե���
		onClick:function(){
			ChangeButtonEnable({'#CheckBT':false,'#TestImportBT':false,'#ImportBT':true,'#ClearBT':true,'#ReadBT':true});;
		}
	});
	$UI.linkbutton('#ImportBT',{  //����
		onClick:function(){
			Save();
		}
	});
	var Save=function(){
		var Type=$("input[name='Type']:checked").val();
		if(isEmpty(Type)){
			$UI.msg('alert','�������Ͳ���Ϊ��!')
			return;
		}
		var RowsObject=DataGrid.getRows();		
		var Rows=DataGrid.getRows();
		if(Rows.length==0){
			$UI.msg('alert','û����Ҫ�ϴ�������!')
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
	$UI.linkbutton('#CheckBT',{  //�������
		onClick:function(){
			var Type=$("input[name='Type']:checked").val();
				if(isEmpty(Type)){
					$UI.msg('alert','�������Ͳ���Ϊ��!')
					return;
				}
			showMask();
			if(CheckObj()===false){
				hideMask();
				$UI.msg('error','����У�鲻ͨ��!');
				return;
			}
			hideMask();
			$UI.msg('success','����У��ͨ��!');
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
					Msg = Msg + '��' + (i + 1) + '��' + CheckField[j] + "����Ϊ��!";
					CheckFlag = false;
				}
			}
			if (isEmpty(Msg)) {
				Msg = "��";
			} else {
				$('#DataGrid').datagrid('highlightRow', i);
			}
			Record["У����Ϣ"] = Msg;
			RecordArr.push(Record);
		}
		$('#DataGrid').datagrid('loadData', RecordArr);
		return CheckFlag;
		}
	var CmObj={
		Package:[[{
			title: '����������',
			field: '����������',
			checknull:true,
			width:100
		}, {
			title: '����������',
			field: '����������',
			checknull:true,
			width:100
		}, {
			title: '����������',
			field: '����������',
			width:100
		},{
			title: '����������',
			field: '����������',
			checknull:true,
			width:100
		},{
			title: '������',
			field: '������',
			checknull:true,
			width:100
		},{
			title: '����������',
			field: '����������',
			checknull:true,
			width:100
		},{
			title: '�۸�',
			field: '�۸�',
			width:100
		},{
			title: '��λ',
			field: '��λ',
			width:100
		},{
			title: '�����ʽ',
			field: '�����ʽ',
			checknull:true,
			width:100
		},{
			title: 'ʹ�ñ�־',
			field: 'ʹ�ñ�־',
			width:100
		},{
			title: '���տ���',
			field: '���տ���',
			width:100
		},{
			title: '����������',
			field: '����������',
			width:100
		},{
			title: '��Ч��',
			field: '��Ч��',
			checknull:true,
			width:100
		}
		]],
		PackageItem:[[{
			title: '����������',
			field: '����������',
			checknull:true,
			width:100
		}, {
			title: '������е����',
			field: '������е����',
			checknull:true,
			width:100
		}, {
			title: '��������е���',
			field: '��������е���',
			width:100
		},{
			title: '��������е�۸�',
			field: '��������е�۸�',
			width:100
		},{
			title: 'ʹ�ñ�־',
			field: 'ʹ�ñ�־',
			width:100
		},{
			title: '��е����',
			field: '��е����',
			checknull:true,
			width:100
		},{
			title: '��ע',
			field: '��ע',
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
