var source=[];

document.body.onload=function()
{

	$("btnAdd").onclick=function()
	{
		
		var addItem=[];
		var delItem=[];
		var des=[]
		var obj=$('bed');
		for(var j=0;j<obj.options.length;j++)
			{
				if(obj.options[j].selected){
				 des.push(obj.options[j].value);
			  }
			}
	  comp(des,source,addItem);
		comp(source,des,delItem);
		var qstr=cspRunServerMethod($V("AddEditMethod"),$V("grouprowid")+"^"+$V("wardrowid")+"^"+session['LOGON.USERID'],addItem.join(","),delItem.join(","));
    if(qstr=="0"){
    	alert("失败");
    	return;
    }
     if(qstr=="1"){
    	alert("成功");
    	return;
    }
	}
}

function getBed(ward)
{
	
	if($V("wardrowid")=="")
	{
		alert("选择专业组");
		return;
	}
	var groupBeds=cspRunServerMethod($V("GroupBed"),$V("grouprowid"));
	source=groupBeds.split("!");

	DHCC_ClearAllList($("bed"));
	var retDetail=cspRunServerMethod($V("getbedListMethod"),"SetList",$V("wardrowid"),$V("grouprowid"));
  var obj=$('bed');
		for (var i=0;i<source.length;i++) {
				var DocRowId=source[i];
				for (var j=0;j<obj.length;j++) {
					if (obj.options[j].value==DocRowId){
						obj.options[j].selected=true;
					}
				}
			}	
}
function SetList(code,rowid){

	var obj=$('bed');
	obj.options[obj.length] = new Option(code,rowid);
			
}

function comp(arr1,arr2,addItem)
  {
    var arr=addItem;

    for(var i=0;i<arr1.length;i++){
	  var f=0;
	  for(var j=0;j<arr2.length;j++){
         if(arr1[i]==arr2[j])
		  f=1;
		 }
	  if(f==0){
	  arr.push(arr1[i]);
	
	  }

	}
  }