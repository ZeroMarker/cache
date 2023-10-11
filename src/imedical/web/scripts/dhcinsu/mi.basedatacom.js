/**
 * FileName: dhcinsu/mi.basedatacom.js
 * Anchor: tangzf
 * Date: 2021-02-02
 * Description: 国家版-基础数据导入导出
 */
 // 加载基础数据字典
 var GLOBAL = {
	SIGNTYPE : init_DicData('SIGNTYPE'), // 签名类型	 
	CONTENTTYPE : init_DicData('CONTENTTYPE'), // 参数类型	
	ARGTYPE : init_DicData('ARGTYPE'), // 签名类型	 
	MDTRTTYPE : init_DicData('MDTRTTYPE'), // 签名类型	 
	NODETYPE : init_DicData('NODETYPE'), // 签名类型	 
	METHODTYPE : init_DicData('METHODTYPE'), // 签名类型	 
	EFFTFLAG : init_DicData('EFFTFLAG'), // 签名类型	 
	INSUMIType : init_DicData('INSUMIType'), // 签名类型	 
	CONTYPE : init_DicData('CONTYPE'), // 签名类型	 
	LV1TYPE : init_DicData('LV1TYPE'), // 签名类型	 
	LV2TYPE : init_DicData('LV2TYPE'), // 签名类型	 
	CALLWAY : init_DicData('CALLWAY'), // 签名类型	 
	PUBLISHSTATUS : init_DicData('PUBLISHSTATUS'), // 签名类型	 
	CONFLAG : init_DicData('CONFLAG'), // 签名类型	 
	MUSTFLAG : init_DicData('MUSTFLAG'), // 签名类型	 
	CODEFLAG : init_DicData('CODEFLAG'), // 签名类型	 
	PARNODETYPE : init_DicData('PARNODETYPE'), // 签名类型	 
	CONTENTMUSTLFLAG : init_DicData('CONTENTMUSTLFLAG') // 签名类型	 	
}
function init_DicData(DicType){
	try{
		var DicStr = $.m({ClassName: "INSU.COM.BaseData", MethodName: "BuildINSUDicDataJson", DicType: DicType}, false);	
		var jsonObj = JSON.parse(DicStr);
		return jsonObj
	}catch(e){
		$.messager.alert('提示','dhcinsu/mi.basedatacom.js：字典信息初始化失败','info');
		return "";		
	}
}
 // portfunlist-接口清单表导入
 function import_PortList(filePath){
	try {
        $.messager.progress({
            title: "提示",
            msg: '正在导入数据',
            text: '导入中....'
        }
        ); 
        if (filePath == "") {
            $.messager.alert('提示', '请选择文件！')
            return;
        } else {
            var ErrMsg = "";     //错误数据
            var errRowNums = 0;  //错误行数
            var sucRowNums = 0;  //导入成功的行数
            var arr= websys_ReadExcel(filePath);
            var rows = arr.length;
            try {

                for (i = 2; i <= rows-1; i++) {
                    var selectROWID = "";
                    var m = 0;
                    var HOSPID = arr[i][m];
                    m++;
                    var TYPE = arr[i][m];
                    m++;
                    var HITYPE = arr[i][m];
                    m++;
                    var INFNO = arr[i][m];
                    m++;
                    var INFNAME = arr[i][m];
                    m++;
                    var LV1TYPE = arr[i][m];
                    m++;
                    var LV2TYPE = arr[i][m];
                    m++;
                    var CALLWAY = arr[i][m];
                    m++;
                    var DATADESC = arr[i][m];
                    m++;
                    var EFFTFLAG = arr[i][m];
                    m++;
                    var NODECODE = arr[i][m];
                    m++;
                    var VER = arr[i][m];
                    var InStr = selectROWID + '^' + HOSPID  + '^' + TYPE + '^' + HITYPE  + '^' + INFNO + '^' + INFNAME  + '^' + LV1TYPE + '^' + LV2TYPE + '^' + CALLWAY;
					InStr = InStr + '^' + DATADESC  + '^' + EFFTFLAG + '^' + NODECODE  + '^' + VER;
					InStr.replace(undefined,'');
					InStr.replace('undefined','');
					
					var savecode = $.m({ClassName: "INSU.MI.PortFunListCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
					if (savecode == '0'){
						sucRowNums = sucRowNums + 1;
					}else{
						errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = savecode;
                        } else {
                            ErrMsg = ErrMsg + "\t" + savecode;
                        }
					}
               
                }
	   
                if (ErrMsg == "") {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    var tmpErrMsg = "成功导入【" + sucRowNums + "/" + (rows - 1) + "】条数据";
                    tmpErrMsg = tmpErrMsg + "失败数据行号如下：\n\n" + ErrMsg;
                    $.messager.alert('提示', tmpErrMsg);
                }
            }
   
            catch (e) {
                $.messager.alert('提示', "导入时发生异常0：ErrInfo：" + e.message);
            }
            finally {
/*                 xlBook.Close(savechanges = false);
                xlApp.Quit();
                xlApp = null;
                xlsheet = null; */
            }
        }
    }
    catch (e) {
        $.messager.alert('提示', "导入时发生异常1：" + e.message);
   
    }
    finally {
        setTimeout('$.messager.progress("close");', 1 * 1000);
    }	 
}
// PortNode-接口参数节点配置表导入
 function import_PortNode(filePath){
	try {
        $.messager.progress({
            title: "提示",
            msg: '正在导入数据',
            text: '导入中....'
        }
        ); 
        if (filePath == "") {
            $.messager.alert('提示', '请选择文件！')
            return;
        } else {
            var ErrMsg = "";     //错误数据
            var errRowNums = 0;  //错误行数
            var sucRowNums = 0;  //导入成功的行数
   
            var arr= websys_ReadExcel(filePath);
            var rows = arr.length;

            try {
				var dgSelect = $('#dg').datagrid('getSelected');
					if(!dgSelect){
						INSUMIAlert('请先选择接口' , 'error');
				        return ;	
					}
					var wdgSelect = $('#wdg').datagrid('getSelected');	
					var wdgSelectIndex = $('#wdg').datagrid('getRowIndex',wdgSelect);					
					var wdgSelectRowId = '';
                for (i = 2; i <= rows-1; i++) {
                    var editorRow = {
							NODECODE: arr[i][0],
							NODENAME: arr[i][1],
							NODETYPE: arr[i][2],
							CLASSNAME: arr[i][3],
							METHODNAME: arr[i][4],
							METHODTYPE: arr[i][5],
							CONFLAG: arr[i][6],
							SUBFLAG: arr[i][7],
							SEQ: arr[i][8],
							PARNODETYPE: arr[i][9],
							PARID:dgSelect.ROWID,
							ROWID : wdgSelectRowId
						}
					var InJson = JSON.stringify(editorRow);
					InJson.replace(undefined,'');
					InJson.replace('undefined','');
					var savecode = $.m({ClassName: "INSU.MI.PortNodeCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);
					if (savecode.split('^')[0] == '0'){
						sucRowNums = sucRowNums + 1;
					}else{
						errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = savecode;
                        } else {
                            ErrMsg = ErrMsg + "\t" + savecode;
                        }
					}
               
                }
	   
                if (ErrMsg == "") {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    var tmpErrMsg = "成功导入【" + sucRowNums + "/" + (rows - 1) + "】条数据";
                    tmpErrMsg = tmpErrMsg + "失败数据行号如下：\n\n" + ErrMsg;
                    $.messager.alert('提示', tmpErrMsg);
                }
            }
   
            catch (e) {
                $.messager.alert('提示', "导入时发生异常0：ErrInfo：" + e.message);
            }
            finally {
/*                 xlBook.Close(savechanges = false);
                xlApp.Quit();
                xlApp = null;
                xlsheet = null; */
            }
        }
    }
    catch (e) {
        $.messager.alert('提示', "导入时发生异常1：" + e.message);
   
    }
    finally {
        setTimeout('$.messager.progress("close");', 1 * 1000);
    }	 
}
// CF.INSU.MI.PORTARGSDIC-数据元字典表导入
 function import_PortArgsDic(filePath){
	try {
        $.messager.progress({
            title: "提示",
            msg: '正在导入数据',
            text: '导入中....'
        }
        ); 
        if (filePath == "") {
            $.messager.alert('提示', '请选择文件！')
            return;
        } else {
            var ErrMsg = "";     //错误数据
            var errRowNums = 0;  //错误行数
            var sucRowNums = 0;  //导入成功的行数
   
            var arr= websys_ReadExcel(filePath);
            var rows = arr.length;

            try {
                for (i = 2; i <= rows-1; i++) {
                    var PUBLISHSTATUS = arr[i][0];
					var CONTENTCODE = arr[i][1];
					var CONTENTNAME = arr[i][2];
					var CONTENTTYPE = arr[i][3];
					var CONTENTLENG = arr[i][4];
					var CONTENTDICFLAG = arr[i][5];
					var CONTENTMUSTLFLAG = arr[i][6];
					var EFFTFLAG = arr[i][7];
					var VER = arr[i][8];

					var InStr = '' + '^' + PUBLISHSTATUS  + '^'  + CONTENTCODE + '^' + CONTENTNAME + '^' + CONTENTTYPE;
					var InStr = InStr + '^' + CONTENTLENG  + '^' + CONTENTDICFLAG + '^' + CONTENTMUSTLFLAG  + '^' + EFFTFLAG+ '^' + VER;					
					InStr.replace(undefined,'');
					InStr.replace('undefined','');
					var savecode = $.m({ClassName: "INSU.MI.PortArgsDicCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);		
					if (savecode == '0'){
						sucRowNums = sucRowNums + 1;
					}else{
						errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = savecode;
                        } else {
                            ErrMsg = ErrMsg + "\t" + savecode;
                        }
					}
               
                }
	   
                if (ErrMsg == "") {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    var tmpErrMsg = "成功导入【" + sucRowNums + "/" + (rows - 1) + "】条数据";
                    tmpErrMsg = tmpErrMsg + "失败数据行号如下：\n\n" + ErrMsg;
                    $.messager.alert('提示', tmpErrMsg);
                }
            }
   
            catch (e) {
                $.messager.alert('提示', "导入时发生异常0：ErrInfo：" + e.message);
            }
            finally {
 /*                xlBook.Close(savechanges = false);
                xlApp.Quit();
                xlApp = null;
                xlsheet = null; */
            }
        }
    }
    catch (e) {
        $.messager.alert('提示', "导入时发生异常1：" + e.message);
   
    }
    finally {
        setTimeout('$.messager.progress("close");', 1 * 1000);
    }	 
}
// -接口入参配置表
 function import_PortInArgs(filePath){
	try {
        $.messager.progress({
            title: "提示",
            msg: '正在导入数据',
            text: '导入中....'
        }
        ); 
        if (filePath == "") {
            $.messager.alert('提示', '请选择文件！')
            return;
        } else {
            var ErrMsg = "";     //错误数据
            var errRowNums = 0;  //错误行数
            var sucRowNums = 0;  //导入成功的行数
   
            var arr= websys_ReadExcel(filePath);
            var rows = arr.length;
           	var dgSelect = $('#wdg').datagrid('getSelected');
			if(!dgSelect){
				INSUMIAlert('请先选择内容节点' , 'error');
				return ;	
			}
            try {
                for (i = 2; i <= rows-1 ; i++) {
					var wdgSelectRowId = '';
					var editorRow = {
							ARGCODE: arr[i][0],
							ARGNAME: arr[i][1],
							CONTYPE: arr[i][2],
							CONINFO : arr[i][3],
							ARGTYPE : arr[i][4],
							MUSTLFLAG : arr[i][5],
							MAXLENG : arr[i][6] ,
							SUBNODE : arr[i][7] ,
							SUBNAME : arr[i][8] ,
							SEQ : arr[i][9],
							CONINFODESC : arr[i][10],
							PARNODETYPE : arr[i][11] ,
							CODEFLAG : arr[i][12],
							DEFVALUE: arr[i][13],
							CONINFODEMO : arr[i][14] ,
							EFFTFLAG :arr[i][15],
							CONINFOSOURCE:arr[i][16],
							DICCODE:arr[i][17],
							LOCALPARCODE:arr[i][18],
							PARID:dgSelect.ROWID,
							ROWID : wdgSelectRowId
						}
					var InJson = JSON.stringify(editorRow);
					InJson.replace(undefined,'');
					InJson.replace('undefined','');
					 // ##class(INSU.MI.PortListCom).Save(InJson)
					var savecode = $.m({ClassName: "INSU.MI.PortInArgsCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);
					if (savecode.split('^')[0] == '0'){
						sucRowNums = sucRowNums + 1;
					}else{
						errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = savecode;
                        } else {
                            ErrMsg = ErrMsg + "\t" + savecode;
                        }
					}
               
                }
	   
                if (ErrMsg == "") {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    var tmpErrMsg = "成功导入【" + sucRowNums + "/" + (rows - 1) + "】条数据";
                    tmpErrMsg = tmpErrMsg + "失败数据行号如下：\n\n" + ErrMsg;
                    $.messager.alert('提示', tmpErrMsg);
                }
            }
   
            catch (e) {
                $.messager.alert('提示', "导入时发生异常0：ErrInfo：" + e.message);
            }
            finally {
/*                 xlBook.Close(savechanges = false);
                xlApp.Quit();
                xlApp = null;
                xlsheet = null; */
            }
        }
    }
    catch (e) {
        $.messager.alert('提示', "导入时发生异常1：" + e.message);
   
    }
    finally {
        setTimeout('$.messager.progress("close");', 1 * 1000);
    }	 
}
// portfunlist-接口清单参数表导入
 function import_PortFunArgsList(filePath){
	try {
        $.messager.progress({
            title: "提示",
            msg: '正在导入数据',
            text: '导入中....'
        }
        ); 
        if (filePath == "") {
            $.messager.alert('提示', '请选择文件！')
            return;
        } else {
            var ErrMsg = "";     //错误数据
            var errRowNums = 0;  //错误行数
            var sucRowNums = 0;  //导入成功的行数
   
            var arr= websys_ReadExcel(filePath);
            var rows = arr.length;

            try {

                for (i = 2; i <= rows-1; i++) {
                    var selectROWID = "";
                    var m = 0;
                    var SEQ = arr[i][m];
                    m++;
                    var INFNO = arr[i][m];
                    m++;
                    var INFNAME = arr[i][m];
                    m++;
                    var PARNODETYPE = arr[i][m];
                    m++;
                    var NODECODE = arr[i][m];
                    m++;
                    var ARGCODE = arr[i][m];
                    m++;
                    var ARGNAME = arr[i][m];
                    m++;
                    var CONTENTTYPE = arr[i][m]; //参数类型
                    m++;
                    var MAXLENG = arr[i][m];
                    m++;
                    var CODEFLAG = arr[i][m];
                    m++;
                    var MUSTLFLAG = arr[i][m];
                    m++;
                    var DATADESC = arr[i][m];
                    m++;
                    var EFFTFLAG = arr[i][m];
                    m++;
                    var VER = arr[i][m];
                   
                    var InStr =  selectROWID + '^' + INFNO  + '^' + INFNAME + '^' + PARNODETYPE  + '^' + NODECODE + '^' + ARGCODE  + '^' + ARGNAME + '^' + CONTENTTYPE + '^' + MAXLENG;
					InStr = InStr + '^' + CODEFLAG  + '^' + MUSTLFLAG + '^' + DATADESC  + '^' + EFFTFLAG + '^' + VER + '^' + SEQ;
					InStr.replace(undefined,'');
					InStr.replace('undefined','');
					var savecode = $.m({ClassName: "INSU.MI.PortFunArgsListCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
					if (savecode == '0'){
						sucRowNums = sucRowNums + 1;
					}else{
						errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = savecode;
                        } else {
                            ErrMsg = ErrMsg + "\t" + savecode;
                        }
					}
               
                }
	   
                if (ErrMsg == "") {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    var tmpErrMsg = "成功导入【" + sucRowNums + "/" + (rows - 1) + "】条数据";
                    tmpErrMsg = tmpErrMsg + "失败数据行号如下：\n\n" + ErrMsg;
                    $.messager.alert('提示', tmpErrMsg);
                }
            }
   
            catch (e) {
                $.messager.alert('提示', "导入时发生异常0：ErrInfo：" + e.message);
            }
            finally {
            }
        }
    }
    catch (e) {
        $.messager.alert('提示', "导入时发生异常1：" + e.message);
   
    }
    finally {
        setTimeout('$.messager.progress("close");', 1 * 1000);
    }	 
}

 // portfunlist-接口清单表导入
 function import_PortListAllData(filePath){
	try {
        $.messager.progress({
            title: "提示",
            msg: '正在导入数据',
            text: '导入中....'
        }
        ); 
        if (filePath == "") {
            $.messager.alert('提示', '请选择文件！')
            return;
        } else {
            var ErrMsg = "";     //错误数据
            var errRowNums = 0;  //错误行数
            var sucRowNums = 0;  //导入成功的行数
   
            var arr= websys_ReadExcel(filePath);
            var rows = arr.length;

            try {

                for (i = 2; i <= rows-1; i++) {
                    var selectROWID = "";
                    var m = 0;
                    var HOSPID = arr[i][m];
                    m++;
                    var TYPE = arr[i][m];
                    m++;
                    var HITYPE = arr[i][m];
                    m++;
                    var INFNO = arr[i][m];
                    m++;
                    var INFNAME = arr[i][m];
                    m++;
                    var LV1TYPE = arr[i][m];
                    m++;
                    var LV2TYPE = arr[i][m];
                    m++;
                    var CALLWAY = arr[i][m];
                    m++;
                    var DATADESC = arr[i][m];
                    m++;
                    var EFFTFLAG = arr[i][m];
                    m++;
                    var NODECODE = arr[i][m];
                    m++;
                    var VER = arr[i][m];
                    var InStr = selectROWID + '^' + HOSPID  + '^' + TYPE + '^' + HITYPE  + '^' + INFNO + '^' + INFNAME  + '^' + LV1TYPE + '^' + LV2TYPE + '^' + CALLWAY;
					InStr = InStr + '^' + DATADESC  + '^' + EFFTFLAG + '^' + NODECODE  + '^' + VER;
					InStr.replace(undefined,'');
					InStr.replace('undefined','');
					
					var savecode = $.m({ClassName: "INSU.MI.PortFunListCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
					if (savecode == '0'){
						sucRowNums = sucRowNums + 1;
					}else{
						errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = savecode;
                        } else {
                            ErrMsg = ErrMsg + "\t" + savecode;
                        }
					}
               
                }
	   
                if (ErrMsg == "") {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    var tmpErrMsg = "成功导入【" + sucRowNums + "/" + (rows - 1) + "】条数据";
                    tmpErrMsg = tmpErrMsg + "失败数据行号如下：\n\n" + ErrMsg;
                    $.messager.alert('提示', tmpErrMsg);
                }
            }
   
            catch (e) {
                $.messager.alert('提示', "导入时发生异常0：ErrInfo：" + e.message);
            }
            finally {
            }
        }
    }
    catch (e) {
        $.messager.alert('提示', "导入时发生异常1：" + e.message);
   
    }
    finally {
        setTimeout('$.messager.progress("close");', 1 * 1000);
    }	 
}
// 导入整个接口的数据
function import_AllData(filePath){
	try {
         
        if (filePath == "") {
            $.messager.alert('提示', '请选择文件！')
            return;
        } else {
	        $.messager.progress({
	            title: "提示",
	            msg: '正在导入数据',
	            text: '导入中....'
	        });
            var ErrMsg = "";     //错误数据
            var errRowNums = 0;  //错误行数
            var sucRowNums = 0;  //导入成功的行数
            var arr= websys_ReadExcel(filePath);
            var rows = arr.length;
            try {
				var PortListID = "";
				var PortNodeId = "";
                for (i = 1; i <= rows-1; i++) {
                    var selectROWID = "";
                    // 1.先导入 portlist
                    if(i==1){
                    	var editorRow = {
								HOSPID: arr[i][0],
								TYPE: arr[i][1],
								HITYPE: arr[i][2],
								INFNO : arr[i][3],
								INFNAME : arr[i][4],
								CONTENTTYPE : arr[i][5],
								SIGNTYPE : arr[i][6] ,
								CHKFLAG : arr[i][7] ,
								EFFTFLAG : arr[i][8] ,
								URL : arr[i][9],
								NODECODE : arr[i][10],
								HISVER : arr[i][11] ,
								CLASSNAME : arr[i][12],
								METHODNAME: arr[i][13],
								OUTNODECODE : arr[i][14] ,
								BUILDINPUT : arr[i][15] ,
								ROWID : ''
							}
						var InJson = JSON.stringify(editorRow);
						InJson.replace(undefined,'');
						InJson.replace('undefined','');
					 	// ##class(INSU.MI.PortListCom).Save(InJson)
						var rtn = $.m({ClassName: "INSU.MI.PortListCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);
                   		if(rtn.split('^')[0] == '0'){
	                   		PortListID = rtn.split('^')[1];	
	                   	}else{
		                   	$.messager.alert('提示','导入接口失败','error');
		                   	ErrMsg = savecode.split('^')[0];
		                	return false;   		
		                }
                    }
                    // 2.导入PortNode
                    if( arr[i][16] && arr[i][16] !=""){
	                    var editorRow = {
								NODECODE: arr[i][16],
								NODENAME: arr[i][17],
								NODETYPE: arr[i][18],
								CLASSNAME: arr[i][19],
								METHODNAME: arr[i][20],
								METHODTYPE: arr[i][21],
								CONFLAG: arr[i][22],
								SUBFLAG: arr[i][23],
								SEQ: arr[i][24],
								PARNODETYPE: arr[i][25],
								PARID:PortListID,
								ROWID : ''
							}
						var InJson = JSON.stringify(editorRow);
						InJson.replace(undefined,'');
						InJson.replace('undefined','');
						var savecode = $.m({ClassName: "INSU.MI.PortNodeCom", MethodName: "Save", InJson: InJson,SessionStr: session['LOGON.USERID']}, false);
						if(savecode.split('^')[0] == '0'){
		                   	PortNodeId = savecode.split('^')[1];
		                }else{
		                   	$.messager.alert('提示','导入节点失败','error');
		                   	ErrMsg = savecode.split('^')[0];
		                	return false;   		
		                }
                    }
					//3.导入PortInArgs
					if( arr[i][26] && arr[i][26] !=""){
						var editorRow = {
								ARGCODE: arr[i][26],
								ARGNAME: arr[i][27],
								CONTYPE: arr[i][28],
								CONINFO : arr[i][29],
								ARGTYPE : arr[i][30],
								MUSTLFLAG : arr[i][31],
								MAXLENG : arr[i][32] ,
								SUBNODE : arr[i][33] ,
								SUBNAME : arr[i][34] ,
								SEQ : arr[i][35],
								CONINFODESC : arr[i][36],
								PARNODETYPE : arr[i][37] ,
								CODEFLAG : arr[i][38],
								DEFVALUE: arr[i][39],
								CONINFODEMO : arr[i][40] ,
								EFFTFLAG :arr[i][41],
								CONINFOSOURCE:arr[i][42],
								DICCODE:arr[i][43],
								LOCALPARCODE:arr[i][44],
								PARID:PortNodeId,
								ROWID : ''
							}
						  var InJsonStr = JSON.stringify(editorRow);
						  InJsonStr.replace(undefined,'');
					      InJsonStr.replace('undefined','');
						//var savecode = $.m({ClassName: "INSU.MI.PortInArgsCom", MethodName: "Save", InJson: InJsonStr,SessionStr: session['LOGON.USERID']}, false);
						var savecode =tkMakeServerCall("INSU.MI.PortInArgsCom","Save",InJsonStr,session['LOGON.USERID']);
						if (savecode.split('^')[0] == '0'){
							
						}else{
		                   	$.messager.alert('提示','导入节点失败','error');
		                   	ErrMsg = savecode.split('^')[0];
		                	return false;   		
				        }
					}
               
                } // end for
                if (ErrMsg == "") {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    $.messager.alert('提示', '数据正确导入完成','success');
                } else {
                    $.messager.alert('提示', '数据正确导入失败','error');
                }
            }
   
            catch (e) {
                $.messager.alert('提示', "导入时发生异常0：ErrInfo：" + e.message);
            }
            finally {
            }
        }
    }
    catch (e) {
        $.messager.alert('提示', "导入时发生异常1：" + e.message);
   
    }
    finally {
        setTimeout('$.messager.progress("close");', 1 * 1000);
    }	 	
}

 // portfunlist-缩略语
 function import_abbreviationsD(filePath){
	try {
        $.messager.progress({
            title: "提示",
            msg: '正在导入数据',
            text: '导入中....'
        }
        ); 
        if (filePath == "") {
            $.messager.alert('提示', '请选择文件！')
            return;
        } else {
            var ErrMsg = "";     //错误数据
            var errRowNums = 0;  //错误行数
            var sucRowNums = 0;  //导入成功的行数
   
            var arr= websys_ReadExcel(filePath);
            var rows = arr.length;

            try {

                for (i = 2; i <= rows-1; i++) {
                    var selectROWID = "";
                    var m = 0;
                    var PUBLISHSTATUS = arr[i][m];
                    m++;
                    var CHINESEPHRASES = arr[i][m];
                    m++;
                    var ENGLISHNAME = arr[i][m];
                    m++;
                    var ABBREVIATIONS = arr[i][m];
                    m++;
                    var EFFTFLAG = arr[i][m];                    
                    var InStr = '' + '^' + PUBLISHSTATUS    + '^' + CHINESEPHRASES + '^' + ENGLISHNAME + '^' + ABBREVIATIONS;
					InStr = InStr + '^' + EFFTFLAG ;
					InStr.replace(undefined,'');
					InStr.replace('undefined','');
					
					var savecode = $.m({ClassName: "INSU.MI.AbbreviationsCom", MethodName: "Save", InStr:InStr,SessionStr: session['LOGON.USERID']}, false);
					if (savecode == '0'){
						sucRowNums = sucRowNums + 1;
					}else{
						errRowNums = errRowNums + 1;
                        if (ErrMsg == "") {
                            ErrMsg = savecode;
                        } else {
                            ErrMsg = ErrMsg + "\t" + savecode;
                        }
					}
               
                }   
                if (ErrMsg == "") {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    $.messager.alert('提示', '数据正确导入完成');
                } else {
                    setTimeout('$.messager.progress("close");', 1 * 1000);
                    var tmpErrMsg = "成功导入【" + sucRowNums + "/" + (rows - 1) + "】条数据";
                    tmpErrMsg = tmpErrMsg + "失败数据行号如下：\n\n" + ErrMsg;
                    $.messager.alert('提示', tmpErrMsg);
                }
            }
   
            catch (e) {
                $.messager.alert('提示', "导入时发生异常0：ErrInfo：" + e.message);
            }
            finally {
            }
        }
    }
    catch (e) {
        $.messager.alert('提示', "导入时发生异常1：" + e.message);
    }
    finally {
        setTimeout('$.messager.progress("close");', 1 * 1000);
    }	 
}