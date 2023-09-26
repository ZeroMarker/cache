try {
    if ((window.ActiveXObject)||("ActiveXObject" in window)) {
        document.writeln("<OBJECT classid=\"CLSID:B26A83D0-A7D3-44c2-8514-041343B32E13\" height=1 id=pdfCreator style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
        document.writeln("</OBJECT>");
        //document.writeln("<OBJECT classid=\"CLSID:CA87E7AC-743C-49F5-87AA-BDAAF9EC6472\" height=1 id=bjcaPDFSeal style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
        document.writeln("<OBJECT classid=\"CLSID:B89FD3B7-C49E-4FAB-8D33-6D44DC6AF599\" height=1 id=sealDemo style=\"HEIGHT: 1px; LEFT: 10px; TOP: 28px; WIDTH: 1px\" width=1 VIEWASTEXT>");
        document.writeln("</OBJECT>");
        pdfCreator.IsInstanceRunning();
    }
} catch (e) {
    //alert("请检查证书应用环境是否正确安装!");
}

function sleep(ms) {
    for(var t = Date.now();Date.now() - t <= ms;);
}
/*
 * PDF_GEN
 * Para: pdfName    PDF FileName
 *       outPath    Output Path
 *       emrEditor   CallBack function to send PrintJob to clawPDF
 * Out:  PDF Full Name
 */
function genPDF(pdfName,outPath, emrEditor) {
    var defPrinter = "";
    //pdfCreator.ViewPDF("D:\\pdfCreator\\2399917\\2399917.pdf");
    pdfCreator.SetPDFName(pdfName);
    //pdfCreator.SetOutPath("D:\\pdfCreator\\20190314");
    if (outPath!="") pdfCreator.SetOutPath(outPath);
    else pdfCreator.SetOutPath("");
    
    var fName = pdfCreator.GetOutPath() + pdfCreator.GetPDFName() + ".pdf";
    //if(path.value=="") path.value += fName;
    pdfCreator.SetLandscape("");
    defPrinter = pdfCreator.GetDefaultPrinter();
    
    if (!emrEditor) return;
    pdfCreator.SwitchDefaultPrinter("clawPDF");
    //emrEditor.printDoc('Print')
    //emrEditor.printDoc('PrintDirectly');
    var documentContext = emrEditor.getDocContext();
    if (!documentContext) return;
    /*ret = documentContext.privelege.canPrint == '1';
    if (!ret) {
        showEditorMsg('没有合法签名，不允许进行打印！', 'warning');
        return;
    }*/
    var ret = "";
    ret = iEmrPlugin.PRINT_DOCUMENT({
        args: 'PrintDirectly',
        isSync: true
    });
    //alert(pdfCreator.PrintJobCnt());
    if(pdfCreator.PrintJobCnt()==0) {
        sleep(3000);
        //if ('OK' === ret.params.result) {
	    if (1 == 1) {
            pdfCreator.SwitchDefaultPrinter(defPrinter);
            return fName;
        } else {
            return false;
        }
    }
}

function viewPDF(pFile) {
    pdfCreator.ViewPDF(pFile);
}

function readPDFB64(pFile) {
    return pdfCreator.Bin2B64(pFile);
}

function delPDF(pFile) {
    return pdfCreator.DelPDF(pFile);
}

function delPDFs(pPath) {
    return pdfCreator.DelPDFs(pPath, true);
}

function pdfPreview(pdfB64, pdfName) {
    var prevPath = pdfCreator.B642Bin2TMP(pdfB64, pdfName);
    viewPDF(prevPath+"\\"+pdfName);
    delPDF(prevPath+"\\"+pdfName);
}

function printToRealPrint(pdfB64, pdfName) {
    var tmpPath = pdfCreator.B642Bin2TMP(pdfB64, pdfName);
    pdfCreator.Print2Printer(tmpPath+"\\"+pdfName);
    delPDF(tmpPath+"\\"+pdfName);
}

function genTS(){
    var dt = new Date();
    var fYear = dt.getFullYear()

    var month = dt.getMonth()+1
    month = "00" + month;
    month = month.substring(month.length-2);

    var dat   = dt.getDate()
    dat = "00" + dat;
    dat = dat.substring(dat.length-2);

    var hours = dt.getHours()
    hours = "00" + hours;
    hours = hours.substring(hours.length-2);

    var min   = dt.getMinutes()
    min = "00" + min;
    min = min.substring(min.length-2);

    var sec   = dt.getSeconds()
    sec = "00" + sec;
    sec = sec.substring(sec.length-2);
    
    var msec  = dt.getMilliseconds()
    msec = "00" + msec;
    msec = msec.substring(msec.length-3);
    
    return fYear+month+dat+hours+min+sec+msec;
}

function emrPDFSeal(signArgs, pdfName, outPath, emrEditor) {
    var timeStamp = "-" + genTS();
    pdfName = pdfName+timeStamp;
    var pdfFull = genPDF(pdfName,outPath, emrEditor);
    //var pdfB64  = readPDFB64(pdfName)
    var sealRet = "";
    try {
        //sealRet = bjcaPDFSeal.PDFSign("10.146.9.71", "8002", "", "6ABD3BD2DE15AF15", pdfFull);
        sealRet = sealDemo.PDFSign(pdfFull.split(".")[0], ".pdf", "350", "100");
        //sealRet = JSON.parse(sealRet);
    } catch(e) {
        alert("使用模拟签章，错误："+e.message);
    }

    if(sealRet.statuscode=="200") {
        var signedpdfB64 = sealRet.pdfb64;
        var suffix = ".sealed.pdf"
        pdfCreator.B642Bin(signedpdfB64, pdfFull+suffix);
        viewPDF(pdfFull+suffix);
        //debugger;
        //var fullpath = pdfCreator.FtpUpload(pdfName+suffix, pdfFull+suffix, "10.146.9.21", "21", "ftpuser", "1_ftp_2", "2000");
        var argsData = {
            action: 'savePDFInfo',
            episodeID: signArgs.episodeID,
            printDocID: signArgs.printDocID,
            eprNum: signArgs.eprNum,
            insID: signArgs.insID,
            userID: signArgs.userID,
            // 签名类型：患者签名——patsigned 机构签章orgsealed
            signAct: 'orgsealed',
            //// 存储类型：FTP——ftp 数据库存储Base64—-db
            storeType: 'dup',
            pdfName: pdfName+suffix,
            pdfPath: fullpath,
            pdfB64: signedpdfB64
        };
        
        $.ajax({
            type: 'POST',
            dataType: 'text',
            url: '../CA.Ajax.anySign.cls',
            async: false,
            cache: false,
            data: argsData,
            success: function (ret) {
                ret = $.parseJSON(ret);
            },
            error: function (err) {
                throw { message : 'savePDFInfo error:' + err };
            }
        });
        if (delPDF(pdfFull)) {
            delPDF(pdfFull+suffix);
        }
        alert("审核签章成功");
    } else {
        (typeof sealRet.msg == "undefined")?alert("模拟审核签章成功"):alert(sealRet.msg)
    }
}