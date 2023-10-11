/*
	Zhan 20140812
*/
if (typeof JSON !== 'object') {
    JSON = {};
}

(function () {
    'use strict';

    function f(n) {
        return n < 10 ? '0' + n : n;
    }

    if (typeof Date.prototype.toJSON !== 'function') {

        Date.prototype.toJSON = function () {

            return isFinite(this.valueOf())
                ? this.getUTCFullYear()     + '-' +
                    f(this.getUTCMonth() + 1) + '-' +
                    f(this.getUTCDate())      + 'T' +
                    f(this.getUTCHours())     + ':' +
                    f(this.getUTCMinutes())   + ':' +
                    f(this.getUTCSeconds())   + 'Z'
                : null;
        };

        String.prototype.toJSON      =
            Number.prototype.toJSON  =
            Boolean.prototype.toJSON = function () {
                return this.valueOf();
            };
    }

    var cx,
        escapable,
        gap,
        indent,
        meta,
        rep;


    function quote(string) {


        escapable.lastIndex = 0;
        return escapable.test(string) ? '"' + string.replace(escapable, function (a) {
            var c = meta[a];
            return typeof c === 'string'
                ? c
                : '\\u' + ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
        }) + '"' : '"' + string + '"';
    }


    function str(key, holder) {



        var i,          // The loop counter.
            k,          // The member key.
            v,          // The member value.
            length,
            mind = gap,
            partial,
            value = holder[key];

        if (value && typeof value === 'object' &&
                typeof value.toJSON === 'function') {
            value = value.toJSON(key);
        }

        if (typeof rep === 'function') {
            value = rep.call(holder, key, value);
        }

        switch (typeof value) {
        case 'string':
            return quote(value);

        case 'number':

            return isFinite(value) ? String(value) : 'null';

        case 'boolean':
        case 'null':

            return String(value);

        case 'object':

            if (!value) {
                return 'null';
            }

            gap += indent;
            partial = [];

            if (Object.prototype.toString.apply(value) === '[object Array]') {

                length = value.length;
                for (i = 0; i < length; i += 1) {
                    partial[i] = str(i, value) || 'null';
                }

                v = partial.length === 0
                    ? '[]'
                    : gap
                    ? '[\n' + gap + partial.join(',\n' + gap) + '\n' + mind + ']'
                    : '[' + partial.join(',') + ']';
                gap = mind;
                return v;
            }

            if (rep && typeof rep === 'object') {
                length = rep.length;
                for (i = 0; i < length; i += 1) {
                    if (typeof rep[i] === 'string') {
                        k = rep[i];
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            } else {

                for (k in value) {
                    if (Object.prototype.hasOwnProperty.call(value, k)) {
                        v = str(k, value);
                        if (v) {
                            partial.push(quote(k) + (gap ? ': ' : ':') + v);
                        }
                    }
                }
            }
            v = partial.length === 0
                ? '{}'
                : gap
                ? '{\n' + gap + partial.join(',\n' + gap) + '\n' + mind + '}'
                : '{' + partial.join(',') + '}';
            gap = mind;
            return v;
        }
    }

    if (typeof JSON.stringify !== 'function') {
        escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;
        meta = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"' : '\\"',
            '\\': '\\\\'
        };
        JSON.stringify = function (value, replacer, space) {
            var i;
            gap = '';
            indent = '';

            if (typeof space === 'number') {
                for (i = 0; i < space; i += 1) {
                    indent += ' ';
                }

            } else if (typeof space === 'string') {
                indent = space;
            }

            rep = replacer;
            if (replacer && typeof replacer !== 'function' &&
                    (typeof replacer !== 'object' ||
                    typeof replacer.length !== 'number')) {
                throw new Error('JSON.stringify');
            }

            return str('', {'': value});
        };
    }

    if (typeof JSON.parse !== 'function') {
        cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g;
        JSON.parse = function (text, reviver) {

            var j;

            function walk(holder, key) {

                var k, v, value = holder[key];
                if (value && typeof value === 'object') {
                    for (k in value) {
                        if (Object.prototype.hasOwnProperty.call(value, k)) {
                            v = walk(value, k);
                            if (v !== undefined) {
                                value[k] = v;
                            } else {
                                delete value[k];
                            }
                        }
                    }
                }
                return reviver.call(holder, key, value);
            }

            text = String(text);
            cx.lastIndex = 0;
            if (cx.test(text)) {
                text = text.replace(cx, function (a) {
                    return '\\u' +
                        ('0000' + a.charCodeAt(0).toString(16)).slice(-4);
                });
            }

            if (/^[\],:{}\s]*$/
                    .test(text.replace(/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g, '@')
                        .replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']')
                        .replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {

                j = eval('(' + text + ')');

                return typeof reviver === 'function'
                    ? walk({'': j}, '')
                    : j;
            }

            throw new SyntaxError('JSON.parse');
        };
    }
}());

/*ҽ����jqueryʹ�õĹ��ú���JS
*Zhan 20140903
*/
var SplCode=String.fromCharCode(36);
var ArgSpl=String.fromCharCode(64);
var ROOTID=session['LOGON.USERID']+TRELOADID;
var CSPURL="";
var jsonQueryUrl="";
var ExportTitle=""
var ExportMed=1	//1Ϊ�ӷ��������ɣ�0Ϊ��������ֱ������
var runqianurl="";
//��ȡCSP·��
function GetCSPURL(){
	/*
	var RtnURL="";
	var TmpStr=location.href;
	var tmpArr=TmpStr.split("/");
	for(var i=0;i<tmpArr.length-1;i++)
	{
	    
	    RtnURL=RtnURL+tmpArr[i]+"/"
    }
	CSPURL=RtnURL;
	*/
	CSPURL="../csp/"
	//CSPURL="http://baidudisk.8866.org:8083/dthealth/web/csp/"
	runqianurl=tkMakeServerCall("web.DHCBL.RQ.WebServerConfig","GetProjectURL")+"reportServlet?action=5&file="
}
function GetjsonQueryUrl(){
	GetCSPURL()
	//jsonQueryUrl=CSPURL+ 'insujsonbuilder.csp'+"?ARGUS="+ROOTID+SplCode  
    jsonQueryUrl=CSPURL+ 'insujsonbuilder.csp?'   
    if ("undefined" !== typeof websys_getMWToken){ 
        jsonQueryUrl += "MWToken="+websys_getMWToken()     //+���� MWToken DingSH 20230209
        jsonQueryUrl +="&"
        } 
    jsonQueryUrl+=("ARGUS="+ROOTID+SplCode)

}
/*������
//jsonתCSV
//���objArray:jsonObject�����磺var jsonObject=JSON.stringify(items.rows);
function ConvertToCSV(objArray) {
	
    var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;
    var str = '';

    for (var i = 0; i < array.length; i++) {
        var line = '';
        for (var index in array[i]) {
            if (line != '') line += ','
			//if (line != '') line +=String.fromCharCode(9)
            line += array[i][index];
        }

        str += line + '\r\n';
    }
    return str;
}
*/


/*
	json���ݶ��󵼳�CSV�ļ�������ֱ����EXCEL��
	��Σ�filename���ļ�·�������֣���ʽ:c://file.xls
	title:excel�е�������
	jsobj��json���ݶ���
*/
function ExportToCSV(filename,title,jsobj){
	try
	{
		var tmpjsonObject = JSON.stringify(jsobj.rows);
		//var tmpjsonObject=JSONstringify(jsobj.rows)
		//var file_name=window.prompt("��ָ������ļ�����(.xls)","C://Export.xls");
		if(filename.length<9){return false}
		
		var FSO=new ActiveXObject("Scripting.FileSystemObject");
		if(FSO.FileExists(filename)){
			FSO.MoveFile(filename,filename+"."+parseInt(10*Math.random())+".bak")
		}
		var file_name=filename	//.split("//").join("////");
		var fs = FSO.CreateTextFile(file_name,true);
		if(title.length>2){fs.write(title);}
	    var array = typeof tmpjsonObject != 'object' ? JSON.parse(tmpjsonObject) : tmpjsonObject;
	    var str = '';
	    for (var i = 0; i < array.length; i++) {
	        var line = '';
	        for (var index in array[i]) {
	            //if (line != '') line += ','	//to CSV
				if (line != '') line +=String.fromCharCode(9)	//to xls
	            line += array[i][index];
	        }
	        //str += line + '\r\n';
	        fs.write(line + '\r\n');
	    }
		//fs.write(cvsstr);
		fs.close();
		return true
		//$.messager.alert("�����ɹ�!�ļ���:"+file_name)
	} catch(e) {
		$.messager.alert("����",e.message);
		fs.close();
	};
}

/*
	textԭʼ���ݵ���CSV�ļ�������ֱ����EXCEL��
	��Σ�filename���ļ�·�������֣���ʽ:c://file.xls
	textval��textval�ַ���
*/
function textToCSV(filename,textval){
	try
	{
		//var tmpjsonObject=JSONstringify(jsobj.rows)
		//var file_name=window.prompt("��ָ������ļ�����(.xls)","C:\\Export.xls");
		if(filename.length<8){return false}
		var FSO=new ActiveXObject("Scripting.FileSystemObject");
		if(FSO.FileExists(filename)){
			var tmpfile=filename+"."+parseInt(10*Math.random())+".bak"
			try{
				FSO.MoveFile(filename,tmpfile)
			}catch(e){
				if(e.message.indexOf("û��Ȩ��")>=0){
					$.messager.alert("����1","����ͬ���ļ�����Ȩ�޲���,��ȷ���Ƿ��Ǵ�״̬!");
				}
				fs.close();
				return false;
			}
			MSNShow('��ʾ','��ͬ���ļ�,ԭ�ļ�����Ϊ:'+tmpfile,4000) 
		}
		//var file_name=filename.split("//").join("////");
		var file_name=filename
		var fs = FSO.CreateTextFile(file_name,true);
		if(textval.length>10){fs.write(textval);}
		//fs.write(cvsstr);
		//alert(file_name)
		fs.close();
		return true
		//$.messager.alert("�����ɹ�!�ļ���:"+file_name)
	} catch(e) {
		//$.messager.progress('close');
		$.messager.alert("����",e.message);
		try{
			fs.close();
		}catch(ee)
		{}
	};
}

function cspUnEscape(inargs){
	try
	{
		if(inargs.indexOf("%")>=0)
		{
			return unescape(inargs.replace('%2B','+'))
		}else{
			return inargs
		}
		
	} catch(e) {
		return 	inargs	
	};
	
}

/*
	���Ի���ĵ���EXCEL
	UrlArgs:���ݲ�ѯ����ƴ��
*/
function ExportPrompt(UrlArgs){
	try
	{
		var title="";
		var tmpurl=UrlArgs
		var file_name,filename;
		var tmpargs=UrlArgs.split(SplCode)
		var rArgs=tmpargs[tmpargs.length-1]
		var qClassName=tmpargs[tmpargs.length-3]
		var qMethodName=tmpargs[tmpargs.length-2]
		/*
		$.messager.prompt('��ʾ', '�������ļ���!\r\n�ļ�Ĭ�ϱ�����C�̸�Ŀ¼��\r\n����������Ļ����Զ���ԭ�ļ�����', function(r){
			if (r){
				r=r.replace(".","")
				r=r.replace("\\","")
				r=r.replace(":","")
				r=r.replace("/","")
				filename=r+".xls"
				file_name="C:\\"+filename

			}
		});
		*/
		
			/*
		    $.messager.progress({
		        msg: '���ڴ������Ժ�...',
		        interval: 500
		    });
		    */
		    filename=""
		    var tmpdate=new Date();
		    filename="INSU"+tmpdate.getFullYear()+tmpdate.getMonth()+tmpdate.getDate()+tmpdate.getHours()+tmpdate.getMinutes()+tmpdate.getSeconds()+".xls"
		    file_name="C:\\"+filename
		    MSNShow('��ʾ','���ڴ������Ժ�...',3000) 
		    if (1==ExportMed){
			    location.href="../"+tkMakeServerCall("web.INSUJSONBuilder","ToExcel",cspEscape(filename),ExportTitle,qClassName,qMethodName,rArgs);
			}else if(ExportMed==2){	//��Ǭ��ʽ����
				var tmpargs="&columns=0&srcType=file&cachedId=&width=-1&height=0&reportParamsId=&t_i_m_e=&excelFormat=xlsx&pageStyle=0&formula=0&tips=yes"
				location.href=runqianurl+rArgs+tmpargs;
			}else{
			    //�Ӻ�̨ȡ��������������ݣ����Է�ҳ��qid=1ʱ�����²�ѯ����
				$.ajax({
				 type: "GET",
				 url: tmpurl,
				 data: {qid:0,txtflag:1},//ע��qidΪ0����Ӻ�̨��ѯ�����ֱ��ȡ�����ݣ�����ִ�в�ѯ
				 async:false,
				 dataType: "text",
				 success: function(data){
					 			if(""!=ExportTitle){data=ExportTitle.replace(/\^/g,String.fromCharCode(9))+data}
								if(textToCSV(file_name,data)){
									$.messager.alert("��ʾ��Ϣ","�����ɹ�!"+file_name)
								}else{
									$.messager.alert("����","����ʧ��!")
								}
				          }
				});
			}

			$.messager.progress('close');
		
	} catch(e) {
		$.messager.progress('close');
		$.messager.alert("����",e.message);
		
	};
}