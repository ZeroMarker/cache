/*
* @Author cryze 
* @Date 2018-4-20
* @Desc ͳһ�û�ƽ̨ ��װ��һЩ����js  �������������Ҳ�����õ�
* @Modified 2018-5-4
*/
var common={};
String.prototype.escapeJquery=function() {

    // ת��֮��Ľ��
    var escapseResult = this;

    // javascript������ʽ�е������ַ�
    var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",
        "]", "|", "{", "}"
    ];

    // jquery�е������ַ�,����������ʽ�е������ַ�
    var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",
        ":", ";", "<", ">", ",", "/"
    ];

    for (var i = 0; i < jsSpecialChars.length; i++) {
        escapseResult = escapseResult.replace(new RegExp("\\" +
                jsSpecialChars[i], "g"), "\\" +
            jsSpecialChars[i]);
    }

    for (var i = 0; i < jquerySpecialChars.length; i++) {
        escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],
            "g"), "\\" + jquerySpecialChars[i]);
    }

    return escapseResult;
};
(function ($) {
	$.fn.combogrid.methods.setRemoteValue=function (jq,param) {
    	return jq.each(function(){
	    	if (typeof param=="string"){
		    	$(this).combogrid('setValue',param);
		    }else{
			    var val=param['value']||'';
			    var text=param['text']||'';
			    $(this).combogrid('options').keyHandler.query.call(this,text);
				$(this).combogrid('setValue',val).combogrid('setText',text);
			}
	    })
    }
})(jQuery);
common.getData=function(arr,prefix){
	var data={};
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			var key=item.substring((typeof prefix =="string"?prefix.length:0));
			var $JO=$('#'+item.escapeJquery());
			if ($JO.length>0 ) data[key]=$.trim($JO.val());
		}else if(typeof item=="object"){
			var $JO=$('#'+item.id.escapeJquery());
			if (item.type && item.type=="radio"){ //radio ��ָ��id Ϊname
				var $JO=$("input[name='"+item.id+"']:checked");
			}
			if ($JO.length==0 ) continue;
			var val="";
			if (item.type ){
				if ($.fn[item.type]){
					if(item.type=="radio"){
						val=$JO.val();
					}else if(item.type=="checkbox" ||item.type=="switchbox" ){
						val=$JO[item.type]('getValue')?(item.on||'1'):(item.off||'0');
					}else{
						if (item.multiple){
							val=$JO[item.type]('getValues').join(',');
						}else{
							val=$JO[item.type]('getValue');
						}
					}
					
				}else{
					val=$.trim( $JO.val() );
				}
			}else{
				val=$.trim( $JO.val() );
			}
			if (item.fn) val=item.fn(val);
			var key=item.id.substring((typeof prefix =="string"?prefix.length:0));
			data[key]=val;
		}
	}
	return data;
}
//prefixǰ׺�� ҳ��htmlԪ��id �����data�����Զ����ǰ׺   ��ҳ��Ԫ��TId  data.Id  ǰ׺ΪT
common.setData=function(arr,prefix,data){
	var tempObj={};
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			var key=item.substring((typeof prefix =="string"?prefix.length:0));
			var $JO=$('#'+item.escapeJquery());
			if ($JO.length>0 ) $JO.val(data[key]||"");
		}else if(typeof item=="object"){
			var key=item.id.substring((typeof prefix =="string"?prefix.length:0));
			var $JO=$('#'+item.id.escapeJquery());
			if (item.type && item.type=="radio"){ //radio ��ָ��id Ϊname
				var $JO=$("input[name='"+item.id+"'][value='"+data[key]+"']");
			}
			if ($JO.length==0 ) continue;
			var val="";

			if (item.type ){
				if ($.fn[item.type]){
					if(item.type=="radio"){
						val=$JO.radio('check');
					}else if(item.type=="checkbox" ||item.type=="switchbox" ){
						val=$JO[item.type]('setValue' ,data[key]==(item.on||'1'))
					}else{
						if (item.multiple){
							if ((data[key]||"")==""){
								$JO[item.type]('setValues',[]);
							}else{
								$JO[item.type]('setValues',(data[key]||"").split(','));
							}
							
						}else{
							if (item.type=="combogrid"&&item.text) {  //combogrid ���⴦�� 
								var textkey=item.text.substring((typeof prefix =="string"?prefix.length:0));
								$JO.combogrid('setRemoteValue',{value:data[key],text:data[textkey]});
								
							}else{
								$JO[item.type]('setValue',data[key]||data[key]||"");
							}
						}
						
					}
					
				}else{
					$JO.val(data[key]||"");
				}
			}else{
				$JO.val(data[key]||"") ;
			}
		}
	}
}
///��ԭsetDataByRow��Ϊ����common.setData
common.setDataByRow=function(arr,row){
	if (arguments.length==2) common.setData(arr,"",row);
	if (arguments.length==3) common.setData(arguments[0],arguments[1],arguments[2]);
}
common.clearData=function(arr){
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			var $JO=$('#'+item.escapeJquery());	
			if ($JO.length>0 ) $JO.val('');
		}else if(typeof item=="object"){
			var $JO=$('#'+item.id.escapeJquery());
			if (item.type && item.type=="radio"){ //radio ��ָ��id Ϊname
				var $JO=$("input[name='"+item.id+"']:checked");
			}
			if ($JO.length==0 ) continue;
			if (item.type ){
				if ($.fn[item.type]) {
					if(item.type=="radio"){
						$JO.radio('uncheck');
					}else if(item.type=="checkbox" || item.type=="switchbox"){
						$JO[item.type]('setValue',true);
					}else if(item.multiple){
						$JO[item.type]('setValues',[]);
					}else{
						$JO[item.type]('setValue',"");
					}
					
				}else{
					$JO.val("");
				}
			}else{
				$JO.val("");
			}
			
		}
	}
}
common.disable=function(arr,except){
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			var $JO=$('#'+item.escapeJquery());	
			if (except && except.indexOf(item)>-1) continue;
			if ($JO.length>0 ) $JO.attr('disabled','disabled');
		}else if(typeof item=="object"){
			var $JO=$('#'+item.id.escapeJquery());
			if (item.type && item.type=="radio"){ //radio ��ָ��id Ϊname
				var $JO=$("input[name='"+item.id+"']");
			}
			if ($JO.length==0 ) continue;
			if (except && except.indexOf(item.id)>-1) continue;
			if (item.type ){
				if ($.fn[item.type]) {
					$JO[item.type]('disable');
				}else{
					$JO.attr('disabled','disabled');
				}
			}else{
				$JO.attr('disabled','disabled');
			}
			
		}
	}
}
common.enable=function(arr,except){
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			var $JO=$('#'+item.escapeJquery());		
			if (except && except.indexOf(item)>-1) continue;
			if ($JO.length>0 ) $JO.removeAttr('disabled');
		}else if(typeof item=="object"){
			var $JO=$('#'+item.id.escapeJquery());
			if (item.type && item.type=="radio"){ //radio ��ָ��id Ϊname
				var $JO=$("input[name='"+item.id+"']");
			}
			if ($JO.length==0 ) continue;
			if (except && except.indexOf(item.id)>-1) continue;
			if (item.type ){
				if ($.fn[item.type]) {
					$JO[item.type]('enable');
				}else{
					$JO.removeAttr('disabled');
				}
			}else{
				$JO.removeAttr('disabled');
			}
			
		}
	}
}

common.validate=function(arr,except){
	var flag=true;
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			var $JO=$('#'+item.escapeJquery());		
			if (except && except.indexOf(item)>-1) continue;
			if ($JO.length>0 && $JO.hasClass('validatebox-text') ) flag=flag&&$JO.validatebox('isValid');
		}else if(typeof item=="object"){
			var $JO=$('#'+item.id.escapeJquery());
			if (item.type && item.type=="radio"){ //radio ��ָ��id Ϊname
				var $JO=$("input[name='"+item.id+"']");
			}
			if ($JO.length==0 ) continue;
			if (except && except.indexOf(item.id)>-1) continue;
			if (item.type ){
				if ($.fn[item.type]) {
					try{
						flag=flag&&$JO[item.type]('isValid');
					}catch (e){}
				}
			}else{
				if ($JO.hasClass('validatebox-text') ) flag=flag&&$JO.validatebox('isValid');
			}
			
		}
	}
	return flag;
}

///files �ļ��б����
///����ļ����ж�λص�
///cfg {allSheet:true , callbackOnce:true} //allSheet ��ȡ����sheet,Ĭ��ֻ����һ��  callbackOnce�Ƿ�һ��ص� Ĭ��һ���ļ���ȡ��ɻص�һ��
///fn �ص����� ������ ��ȡ�������첽��
///fn (json){} name �ļ��� json {"�ļ���":[[{},{},{}],[{},{},{}],[{},{},{}]], "�ļ���":[[{},{},{}],[{},{},{}],[{},{},{}]]} //ÿ��sheet����һ������ ���sheet�������ڷŵ�ͬһ����
///bug ���ڸ�ʽת�Ĳ��� �������1940-4-1 ת������4/1/49  
//����1 �Լ���ת����4/1/49�����ٽ��д���49ֻ���Լ��ж���1949����2049�ˣ� 
// ����2 �ɽ�xlsx.core�� e[14] = "m/d/yy"; ��Ϊ e[14] = "YYYY-MM-DD"; ����û������Ӱ�첻����� 
common.transExcelData=function(files,cfg,fn){
	var wb,rABS = false;
	if (typeof cfg=="function") {
		fn=cfg;
		cfg={}
	}
	cfg = cfg || {};
	function setup_reader(file) {
	 var filename = file.name;
	 var reader = new FileReader();
	 ///��ΪIE�������ʶ��readAsBinaryString����������������дreadAsBinaryString����
	 if (!FileReader.prototype.readAsBinaryString) {
	     FileReader.prototype.readAsBinaryString = function (f) {
	         var binary = "";
	         var pt = this;
	         var reader = new FileReader();
	         reader.onload = function (e) {
	             var bytes = new Uint8Array(reader.result);
	             var length = bytes.byteLength;
	             for (var i = 0; i < length; i++) {
	                 binary += String.fromCharCode(bytes[i]);
	             }
	             pt.content = binary;
	             $(pt).trigger('onload');
	         };
	         reader.readAsArrayBuffer(f);
	     }
	 }

	 reader.onload = function (e) {
	     //alert("onload");
	     if (reader.result) reader.content = reader.result;
	     data = reader.content;
	     if (rABS) {
	         wb = XLSX.read(btoa(fixdata(data)), { //�ֶ�ת��
	             type: 'base64'
	         });
	     } else {
	         wb = XLSX.read(data, {
	             type: 'binary'
	         });
	     }
	     var sheetArr=[];
	     if (cfg.allSheet){
		     for (var j=0,len=wb.SheetNames.length;j<len;j++){
			     var sheetItem=XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[j]]);
			     sheetArr.push(sheetItem);
			 }
		 }else{
			 var sheetItem=XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
			 sheetArr.push(sheetItem);
		 }
		 if (cfg.callbackOnce){
			 AllJson[filename]=sheetArr;
			 completedCount++;
			 if (length==completedCount && typeof fn=="function") fn(AllJson);
		 }else{
			 if (typeof fn=="function"){
				 var json={};
				 json[filename]=sheetArr;
				 fn(json);
			 }
		 }

	    
	 };

	 if (rABS) {
	     reader.readAsArrayBuffer(file);
	 } else {
	     reader.readAsBinaryString(file);
	 }

	 function fixdata(data) { //�ļ���תBinaryString
	     var o = "",
	         l = 0,
	         w = 10240;
	     for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
	     o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
	     return o;
	 }
	}
	var AllJson={};
	var length=files.length,completedCount=0
	for(var i=0;i<length;i++){
		setup_reader(files[i]);
	}
}

common.isIE=function() { //ie?
	if (!!window.ActiveXObject || "ActiveXObject" in window)
		return true;
	else
		return false;
}

///2018-4-23 add 
///����xlsx github
///���� Blob.js FileSaver.js
// columns ȡhisui-datagrid columns 
// cfg {sheetname:"sheet1",filename:"������",showHidden:false}  sheetname-sheet���� filename-����ļ���  showHidden �Ƿ���ʾ������
common.exportExcelByXLSX=(function(){
	
	function transrow(row,columns,ind,showHidden){
		var newrow={};
	    for (var i = 0; i < columns.length; i++) {
	        var cols = columns[i];
	        for (var j = 0; j < cols.length; j++) {
	            var col = cols[j];
	    		console.info('col',col);
	            if ((col.hidden && ! showHidden )|| !col.field) {
	                continue;
	            }else{
		            var key=col.title||col.field;
	                if (typeof col.formatter=="function"){
						var content= col.formatter(row[col.field]||"",row,ind);
						newrow[key]=content;
	                }else{
	                    newrow[key]=row[col.field]||"";
	                }
	            }
	        }
	    }
	    return newrow;
	}
	return function(rows, columns,cfg){
		cfg=cfg||{};
		cfg.sheetname=cfg.sheetname || "sheet1";
		cfg.filename=cfg.filename || "������";
		cfg.showHidden=!!cfg.showHidden;
		var newrows=[];
		for (var i=0,len=rows.length;i<len;i++){
			newrows.push(transrow(rows[i],columns,i,cfg.showHidden))
		}
		var wb = XLSX.utils.book_new();
		var sheet=XLSX.utils.json_to_sheet(newrows);
		XLSX.utils.book_append_sheet(wb, sheet, cfg.sheetname);
		
		XLSX.writeFile(wb, cfg.filename+'.xlsx');

	}
})()
//exportExcelWithName �Ѿ�����Ҫ�� ֱ��ָ��common.exportExcelByXLSX
common.exportExcelWithName=common.exportExcelByXLSX;