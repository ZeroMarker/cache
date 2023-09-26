//
function BodyLoadHandler()
{

	
	var obj=document.getElementById("Update")
	if (obj) {obj.onclick=Update}
	
	var obj=document.getElementById("Delete")
	if (obj) {obj.onclick=Delete}
	
	var obj=document.getElementById("Add")
	if (obj) {obj.onclick=Add}

	
  
}

function Update()
{

	var obj=document.getElementById("Desc")
	if (obj) {var desc=obj.value}
	
	var obj=document.getElementById("Item")
	if (obj) {var item=obj.value}
	if (item=="") {alert("项目不能为空");}
	
	var obj=document.getElementById("Config")
	if (obj) {var config=obj.value}
	
	
	var str=trim(desc)+"^"+trim(item)+"^"+trim(config)
	
    Config(str,"Update")
	
}
function Delete()
{
	var obj=document.getElementById("Item")
	if (obj) {var item=obj.value}
	if (item=="") {alert("请选择删除项目");return;}
	if (confirm("确认删除?")==true)
		{
			Config(item,"Delete")
		}
	
}

function Add()
{
	var obj=document.getElementById("Desc")
	if (obj) {var desc=obj.value}
	if (desc=="") {alert("描述不能为空");}
	
	var obj=document.getElementById("Item")
	if (obj) {var item=obj.value}
	if (item=="") {alert("项目不能为空");}
	
	var obj=document.getElementById("Config")
	if (obj) {var config=obj.value}
	
	
	var str=trim(desc)+"^"+trim(item)+"^"+trim(config)
	
    Config(str,"Add")
}

function Config(str,flag)
{
	
	var objUpd=document.getElementById("updstr") ;
	if (objUpd) {var encmeth=objUpd.value;} else {var encmeth='';}
	var ret=cspRunServerMethod(encmeth,str,flag)
	
	if (ret==-3){alert("该项目已存在,请重新输入");return;}
	
	if (ret<0){alert("配置失败,请重试");return;}
    
    window.location.reload();
}

function SelectRowHandler()
 {
	var row=selectedRow(window);
	
	var objTdesc=document.getElementById("Tdesc"+"z"+row) ;
	var desc=objTdesc.innerText
	
	var objTitem=document.getElementById("Titem"+"z"+row) ;
	var item=objTitem.innerText
	
	var objTconfig=document.getElementById("Tconfig"+"z"+row) ;
	var config=objTconfig.innerText

    var objDesc=document.getElementById("Desc")
	if (objDesc) {objDesc.value=desc}
	
	var objItem=document.getElementById("Item")
	if (objItem) 
		{
			objItem.value=item;
			objItem.disabled="disabled";
		}
	
   
    var objConfig=document.getElementById("Config")
	if (objConfig) {objConfig.value=config}
   
}










document.body.onload=BodyLoadHandler;





