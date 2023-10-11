$(function(){
	initEditor();
});

function initEditor()
{
	pluginAdd();
	createEditor();
	
}
	function plugin()
        {
            return document.getElementById('plugin');
        }
        
        function addEvent(obj, name, func)
        {
            //if (window.addEventListener) {
            //    obj.addEventListener(name, func, false); 
            //} else {
            //   obj.attachEvent("on"+name, func);
            //}
			
            if (obj.attachEvent) {
                obj.attachEvent("on"+name, func);
            } else {
                obj.addEventListener(name, func, false); 
            }
		}
         
		function testEvent()
        {
            plugin().testEvent();
        }
     
        function load()
        {
            addEvent(plugin(), 'test', function(){
                //alert("Received a test event from the plugin.")
            });
			addEvent(plugin(), 'onFailure', function(command){
				var varJson = JSON.parse(command);
				//alert('onFailure事件：'+ varJson.action+ ": "+varJson.args);
				if(output.value != '')
					output.value += '\n';
				output.value+='错误事件-->'+ varJson.action+ ': '+JSON.stringify(varJson.args);
			});
            addEvent(plugin(), 'onExecute', function(command){
			//alert(command);
			try
			{
				var varJson = JSON.parse(command);
			}
			catch(error)
			{
			}
				//alert('onExecute事件：'+ varJson.action+ ': '+varJson.args);
				if(output.value != '')
					output.value += '\n';
				output.value+='通知事件-->'+ varJson.action+ ': '+JSON.stringify(varJson.args);
            });
        }

        function pluginLoaded() 
		{
            //alert("Plugin loaded!");
        } 
        function pluginValid()
        {
        	if(!plugin())
            alert("Invalid");
			else
            alert(plugin().valid);
        }
        function pluginAdd(){
        	var objString = ""
			
			//objString += "<object id='plugin' classid='clsid:f375428e-7aaf-586f-bb66-92ca590f1afb' width='100%' height='65%'>";
        	objString += "<object id='plugin' type='application/x-iemrplugin' width='100%' height='65%'>";
			objString += "<param name='plugin-version' value='1.0.0.0' />";
			objString += "<param name='install-url' value='http://127.0.0.1/iemrplugin/' />";
			objString += "<param name='product' value='GlobalEMR' />";
			objString += "</object>";
					
        	document.getElementById("container").innerHTML=objString;
        	
        	load();
        }
        function pluginRemove(){
        		document.getElementById("container").innerHTML="";
        }
        function RunScript(scripts) {
            if (!plugin())
                return;

            var argResult = { Script: scripts };
            var strJson = { action: "RUN_SCRIPT", args: JSON.stringify(argResult) };
            //alert(JSON.stringify(strJson));
            plugin().execute(JSON.stringify(strJson));
        }
		
        function RunJsonCommand(jsonCommand, bSync) {
            if (!plugin())
                return;

			if(bSync)
			{
				var strResult = plugin().syncExecute(jsonCommand);
				
				if(output.value != '')
				{
					output.value += '\n';
				}
				output.value += '调用结果：'+strResult;
			}
			else
				plugin().execute(jsonCommand);	
        }
		function SetSimpleCommand(jsonName, args)
		{
			input.value = '{"action":"'+jsonName+'", "args":"'+args+'"}';
		}

		function JsonCommandString(jsonName, args)
		{
			return '{"action":"'+jsonName+'", "args":"'+args+'"}';
		}
		
        function createEditor()
        {
        	plugin().initWindow("iEditor");
        }
        function LoadLocalDocument()
        {
			//var argURL = { path: "D:\\Workspace\\fc_control3.0\\data\\160403.xml" };
			var argURL = { path: "" };
			var strJson = {action : "LOAD_LOCAL_DOCUMENT", args: JSON.stringify(argURL)};
			plugin().execute(JSON.stringify(strJson));
			
			//SetDocReadonly(true);
		}
		

		
        function SaveLocalDocument()
        {
			var argURL = { path: "" };
			var strJson = {action : "SAVE_LOCAL_DOCUMENT", args: JSON.stringify(argURL)};
			plugin().execute(JSON.stringify(strJson));
			
			plugin().testEvent();
			SetDocReadonly(true);
			SetDocReadonly(false);
			
			if(output.value != '')
			{
				output.value += '\n';
			}
			output.value+='通知事件-->文档【保存】完成';
				
			
		}

		
		function SetRevisionVisible()
		{
			var commandString = '{ "action": "SET_REVISION_VISIBLE", "args": {"Visible":true} }';
			
			RunJsonCommand(commandString,true)
		
		}
		function CleanAllRevisions()
		{
			var commandString = '{ "action": "CLEAN_ALL_REVISIONS", "args": "" }';
			RunJsonCommand(commandString,true)
		}
		
		
		
		
		
		//按照实例ID下载文件
		//fso = new ActiveXObject("Scripting.FileSystemObject");
		//会抛出“Automation 服务器不能创建对象”的异常。
		//IE -> Internet选项 -> 安全 -> 自定义级别 -> ActiveX控件和插件 -> 对未标记为可安全执行脚本的ActiveX控件初始化并执行脚本（不安全） -> 启用
		function downLoadXML()
		{
			
			var instanceId= $("#iptInstanceID").val();
			
			//var patt1 = /[1-9][0-9]+\|\|[0-9]+/g;
			var patt1 = /[0-9]+\|\|[0-9]+/;
			
			arr = instanceId.match(patt1);
			
			for (var i = 0; i < arr.length ; i++) {
				instanceId =arr[i];
			}
			
			
			$.ajax({
				type: 'POST',
				dataType: 'text',
				url: "../EMRservice.Ajax.fbEditorService.cls",
				async: false,
				data: {
					"AInstanceID":instanceId,
					"Action":"GetDocument"
				},
				success: function(d) {
					//支持Utf-8格式
					 var fs = new ActiveXObject("Adodb.Stream");
					 fs.Charset = "utf-8";
					 fs.Open();
					 fs.WriteText(d);
					 fs.SaveToFile("D:\\DownloadXMLFiles\\SAVE_DOCUMENT_"+instanceId.replace("||","__")+".xml", 2); // 这里的2表示覆盖模式
					 fs.Close();
					if(output.value != '')
					{
						output.value += '\n';
					}
    					output.value+='通知事件-->文档【下载】完成';
					console.log("下载完成");			
				},
				error: function(d) {alert(d);}
			});
			
		}
		
		
		
		//按照实例ID上传文件
		function upLoadXML()
		{
			
			var instanceId= $("#iptInstanceID").val();
			
			var patt1 = /[0-9]+\|\|[0-9]+/;
			
			arr = instanceId.match(patt1);
			
			for (var i = 0; i < arr.length ; i++) {
				instanceId =arr[i];
			}
			
			var fs = new ActiveXObject("Adodb.Stream");
			fs.CharSet = "utf-8"
			fs.Open()
			fs.LoadFromFile("D:\\DownloadXMLFiles\\SAVE_DOCUMENT_"+instanceId.replace("||","__")+".xml")
			var filedata = fs.ReadText()
			fs.Close();
					 
			
			$.ajax({
				type: 'POST',
				dataType: 'text',
				url: "../EMRservice.Ajax.fbEditorService.cls",
				async: false,
				data: {
					"AInstanceID":instanceId,
					"ADocumentStream":filedata,
					"Action":"SaveDocument"
				},
				success: function(d) {
					if(output.value != '')
					{
						output.value += '\n';
					}
					output.value+='通知事件-->文档【上传】完成';
					console.log(d);
				},
				error: function(d) {
					alert(d);
				}
			});
			
		}