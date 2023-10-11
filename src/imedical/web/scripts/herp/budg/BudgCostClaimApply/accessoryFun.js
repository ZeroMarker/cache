function accessoryFun(rowid)
{
	var form = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        url:'upload.php',
        fileUpload:true,
        defaultType: 'textfield',

        items: [{
            xtype: 'textfield',
            fieldLabel: '文件名',
            name: 'userfile',
            value:'name',
            inputType: 'file',
            allowBlank: false,
            blankText: 'File can\'t not empty.',
            anchor: '90%'  // anchor width by percentage
        }]
    });

    var win = new Ext.Window({
        title: '上传附件',
        width: 400,
        height:200,
        minWidth: 300,
        minHeight: 100,
        layout: 'fit',
        plain:true,
        bodyStyle:'padding:5px;',
        buttonAlign:'center',
        items: form,

        buttons: [{
            text: '上传',
            handler: function() {
                    var obj = document.getElementsByName("userfile");
                    var filepath=obj[0].value;
                    
                    ///alert(filepath);
                    var fso = new ActiveXObject("Scripting.FileSystemObject");  
                     
                  exName = fso.GetExtensionName(filepath); //
                   /// alert(exName);
                     

                  ///   reader = new FileReader();
                  //// reader.readASText(filepath);

                  /// var fsource = fso.OpenTextFile("C:\\test.txt",1,false);
                       var fsource = fso.OpenTextFile(filepath,1,false);
                        fcontent = fsource.ReadLine();   
                

                       var s = "";
                      while (!fsource.AtEndOfStream)
                      s += fsource.ReadLine()+"\n";
                       fsource.Close();
                    
               alert("File contents ="+s);  

                if(form.form.isValid()){
                    Ext.MessageBox.show({
                           title: '请稍等',
                           msg: '上传中...',
                           progressText: '',
                           width:300,
                           progress:true,
                           closable:false,
                           animEl: 'loding'
                       });
                    form.getForm().submit({    
                       url:'../csp/herp.budg.costclaimapplyexe.csp?action=upload&rowid='+rowid+"&filename="+filepath+"&fileconte="+encodeURIComponent(s),
                        method:'POST', 
                        success: function(form, action){
                           Ext.Msg.alert('Message from extjs.org.cn',action.result.msg);
                           win.hide();  
                        },    
                       failure: function(){    
                          Ext.Msg.alert('Error', 'File upload failure.');    
                       }
                    })               
                }
           }
        },{
            text: '取消上传',
            handler:function(){win.hide();}
        }]
    });
    win.show();

}


var accessoryButton = new Ext.Toolbar.Button({
	text: '附件',
    tooltip:'附件',        
    iconCls:'add',
	handler:function(){
	accessoryFun();
	}
	
});







lookup = function(){
 alert("查看！");

};







/*

      // ##### 
      // ## showFtpFile () 
      // ## return: 1 - invalid ftp settings || 2 - not able to connect; 
      function showFtpFile () { 
         var oFtpSettings = checkFtpSettings (); 
         if (oFtpSettings == null) return 1; 
 
         var oSupport = CSupport.getInstance (); 
 
         if (!oSupport.isEmpty (buffDivFileListFtpArea)) showHideFileListFtpArea 

(); 
 
         oSupport.pleaseWaitBox (true); 
         disableDownloadBttns (true); 
 
         var hRet = oSupport.getFtpFileList (oFtpSettings.host, 

oFtpSettings.user, oFtpSettings.pass, oFtpSettings.path);  
          
         if (hRet.errorCode > 0) { 
            var dlgErrMsg = "Possibly problem with remote server settings.";     

          
            dlgErrMsg += "\n\nError description: " + hRet.errorDesc; 
 
            alert (dlgErrMsg); 
 
            oSupport.pleaseWaitBox (false); 
            disableDownloadBttns (false); 
 
            return 2; 
         } 
 
         var tblFileList = "<table id='tblDownloadFiles' cellpadding='5' 

cellspacing='0' border='0' class='sortable'>"; 
		 tblFileList += "<thead><tr><th>"+ cSpacer3 

+"</th><th>&nbsp;#&nbsp;</th><th 

class='sorttable_nosort'>&nbsp;Select&nbsp;</th><th>&nbsp;Name&nbsp;</th><th>&nb

sp;Type&nbsp;</th><th>&nbsp;Size&nbsp;</th><th>&nbsp;Modified&nbsp;Date&nbsp;</t

h><th>Owner</th><th>rights</th><th class='sorttable_nosort'></th><th 

class='sorttable_nosort'></th><th 

class='sorttable_nosort'></th></tr></thead><tbody>"; 
 
         var aFileList = hRet.fileList; 
         var fileNum = 0; 
 
         for (var fileLineIndx in aFileList) { 
            var oFileLine = oSupport.getFtpFileListParceLine (aFileList

[fileLineIndx]); 
 
            if (oFileLine.type != "unknown") 
            {  
               var fileName = oFileLine.name.replace (oFtpSettings.path +"/", 

""); 
               var fileTypeStr = (oFileLine.type == "file") ? oFileLine.type : 

"<b>"+ oFileLine.type +"</b>"; 
               var cbSelectStr = ""; 
               var bttnViewStr = ""; 
               var bttnDownloadStr = ""; 
               var bttnDeleteStr = "<input type='button' value='Delete' 

onclick='divFileListFtp_bttnDelete(\""+ fileName +"\");' />"; 
               fileNum++; 
 
               if (oFileLine.type == "file") { 
                  cbSelectStr = "<input type='checkbox' id=\""+ fileName +"\">"; 
                  bttnViewStr = "<input type='button' value='View' 

onclick='divFileListFtp_bttnView(\""+ fileName +"\");' />"; 
                  bttnDownloadStr = "<input type='button' value='Download' 

onclick='divFileListFtp_bttnDownload(\""+ fileName +"\");' />"; 
               } 
 
               tblFileList += "<tr><td></td><td>"+ fileNum +"</td><td>"+ 

cbSelectStr +"</td><td>"+ fileName +"</td><td align='center'>"+ fileTypeStr 

+"</td><td>"+ oFileLine.size +"</td><td align='center'>"+ oFileLine.changed 

+"</td><td>"+ 

oFileLine.owner +"</td><td>"+ oFileLine.rights +"</td><td>"+ bttnViewStr 

+"</td><td>"+ bttnDeleteStr +"</td><td>"+ bttnDownloadStr 

+"</td></tr>"; 
            } 
         } 
 
         tblFileList += "</tbody></table>"; 
 
         divFileListFtp.innerHTML = tblFileList; 
 
         sortables_init (); 
 
         oSupport.pleaseWaitBox (false); 
         disableDownloadBttns (false); 
      } 
 
      // ##### 
      // ## divFileListFtp_bttnView (fileName) 
      // ## return: 0 || 1; 
      function divFileListFtp_bttnView (fileName) { 
         var oSupport = CSupport.getInstance(); 
 
         oSupport.pleaseWaitBox (true); 
 
         var oFileInfo = downloadFile (fileName); 
         var fileTmpLoc = "\""+ oFileInfo.localPathExpand +"\\"+ 

oFileInfo.fileName +"\""; 
 
         try { 
            oSupport.getShellObj().Run (fileTmpLoc, 1, false); 
         } catch (exp) { 
           alert("Can't open file: "+ fileName +"\n\n"+ exp.description); 
         } 
 
         oSupport.pleaseWaitBox (false); 
 
         return 0; 
      } 
 
      // ##### 
      // ## downloadFile (fileName) 
      // ## return: oFileInfo; 
      function downloadFile (fileName) { 
         var oFtpSettings = checkFtpSettings (); 
         if (oFtpSettings == null) return 1; 
 
         var oFtpFileManager = CFtpFileManager.getInstance(); 
         var oFileInfo = oFtpFileManager.getFile (fileName, oFtpSettings.host, 

oFtpSettings.user, oFtpSettings.pass, 

oFtpSettings.path, fileName); 
          
         return oFileInfo; 
      } 
 
 
      // ##### 
      // ## bttnShowLocalFiles () 
      // ## return: none; 
      function bttnShowLocalFiles () { 
         var oSupport = CSupport.getInstance(); 
         var localWorkingPath = getLocalWorkingPath(); 
 
         if (!oSupport.getFsoObj().FolderExists (localWorkingPath)) { 
            alert ("Local path doesn't exist."); 
            return 1; 
         } 
 
         oSupport.pleaseWaitBox (true); 
         disableUploadBttns(true); 
 
         var tblFileList = "<table id='tblUploadFiles' cellpadding='5' 

cellspacing='0' border='0' class='sortable'>"; 
         tblFileList += "<thead><tr><th>"+ cSpacer3 

+"</th><th>&nbsp;#&nbsp;</th><th 

class='sorttable_nosort'>&nbsp;Select&nbsp;</th><th>&nbsp;Name&nbsp;</th><th>&nb

sp;Size&nbsp;</th><th>&nbsp;Modified&nbsp;Date&nbsp;</th><th>&nbsp;File&nbsp;Typ

e&nbsp;</th><th class='sorttable_nosort'></th><th 

class='sorttable_nosort'></th><th 

class='sorttable_nosort'></th></tr></thead><tbody>"; 
 
         var oFolder = oSupport.getFsoObj().GetFolder(localWorkingPath); 
         var enumFiles = new Enumerator (oFolder.Files); 
         var fileNum = 0; 
          
         for (; !enumFiles.atEnd(); enumFiles.moveNext()) { 
            var oFileItem = enumFiles.item(); 
            fileNum++; 
 
            var cbSelectStr = "<input type='checkbox' id=\""+ oFileItem.Name 

+"\">"; 
            var bttnViewLocalStr = "<input type='button' value='View' 

onclick='divFileListLocal_bttnView(\""+ oFileItem.Name +"\");' />"; 
            var bttnDeleteLocalStr = "<input type='button' value='Delete' 

onclick='divFileListLocal_bttnDelete(\""+ oFileItem.Name +"\");' />"; 
            var bttnUploadStr = "<input type='button' value='Upload' 

onclick='divFileListLocal_bttnUpload(\""+ oFileItem.Name +"\");' />"; 
            tblFileList += "<tr><td></td><td>"+ fileNum +"</td><td>"+ 

cbSelectStr +"</td><td>"+ oFileItem.Name +"</td><td>"+ oFileItem.Size +"</td><td 

align='center'>"+ oFileItem.DateLastModified +"</td><td align='center'>"+ 

oFileItem.Type +"</td><td>"+bttnViewLocalStr +"</td><td>"+ bttnDeleteLocalStr 

+"</td><td>"+ bttnUploadStr +"</td></tr>"; 
         } 
 
         tblFileList += "</tbody></table>"; 
 
         divFileListLocal.innerHTML = tblFileList; 
 
         sortables_init (); 
 
         oSupport.pleaseWaitBox (false); 
         disableUploadBttns (false); 
      } 
 
 
      // ##### 
      // ## divFileListLocal_bttnView (fileName) 
      // ## return: 0 || 1; 
      function divFileListLocal_bttnView (fileName) { 
         var oSupport = CSupport.getInstance(); 
 
         oSupport.pleaseWaitBox (true); 
 
         var localWorkingPath = getLocalWorkingPath(); 
         var fileLoc = "\""+ localWorkingPath +"\\"+ fileName +"\""; 
 
         try { 
            oSupport.getShellObj().Run (fileLoc, 1, false); 
         } catch (exp) { 
           alert("Can't open file.\n\n"+ exp.description); 
         } 
 
         oSupport.pleaseWaitBox (false); 
 
         return 0; 
      } 
 
 
      // ##### 
      // ## divFileListLocal_bttnDelete (fileName) 
      // ## return: none; 
      function divFileListLocal_bttnDelete (fileName) { 
         var dlgErrMsg = "Are you sure you want to delete: "+ fileName +"?"; 
 
         if (!confirm (dlgErrMsg)) return; 
 
         var oSupport = CSupport.getInstance (); 
         var localWorkingPath = getLocalWorkingPath(); 
         var fileLoc = localWorkingPath +"\\"+ fileName; 
 
         oSupport.pleaseWaitBox (true); 
 
         oSupport.deleteFile (fileLoc); 
 
         oSupport.pleaseWaitBox (false); 
 
         bttnShowLocalFiles(); 
      } 
 
 
      // ##### 
      // ## divFileListLocal_bttnUpload (fileName) 
      // ## return: none; 
      function divFileListLocal_bttnUpload (fileName) { 
         var oFtpSettings = checkFtpSettings (); 
         if (oFtpSettings == null) return 1; 
 
         var oSupport = CSupport.getInstance(); 
 
         oSupport.pleaseWaitBox (true); 
 
         var localWorkingPath = getLocalWorkingPath(); 
         var oFtpFileManager = CFtpFileManager.getInstance(); 
         oFtpFileManager.putFile (fileName, oFtpSettings.host, 

oFtpSettings.user, oFtpSettings.pass, oFtpSettings.path, fileName, 

localWorkingPath, false, true); 
 
         oSupport.pleaseWaitBox (false); 
 
         showFtpFile (); 
      } 
  
*/


