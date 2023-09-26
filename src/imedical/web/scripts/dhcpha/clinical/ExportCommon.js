function browseFolder()
{  
  try {  
	  var Message = "请选择路径"; //选择框提示信息  
	  var Shell = new ActiveXObject("Shell.Application");  
	  var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);//起始目录为：我的电脑  
	  if (Folder != null) 
	  {  
		  Folder = Folder.items(); // 返回 FolderItems 对象  
		  Folder = Folder.item();  // 返回 Folderitem 对象  
		  Folder = Folder.Path;    // 返回路径  
		  if (Folder.charAt(Folder.length - 1) != "\\"){  
			  Folder = Folder + "\\";  
		  }    
		  return Folder;  
	  }  
  }  
  catch(e) 
  {  
	  alert(e.message);  
  }  
}  