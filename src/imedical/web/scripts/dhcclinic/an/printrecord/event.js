function InitViewScreenEvent(obj)
{
obj.btnSch_click=function()
{
  obj.grdPnlResultStore.removeAll();
  obj.grdPnlResultStore.load({
  params : {
  start:0
  ,limit:200
	}
	});
}
obj.cboOpRoom_expand=function()
{
 obj.cboOpRoomStore.reload({})
}
obj.cboOpRoom_select=function()
{
 obj.cboOpRoomH.setValue(obj.cboOpRoom.getValue());
}
obj.cboOpRoom_keyup=function()
{
  if(obj.cboOpRoom.getRawValue()=="")
  obj.cboOpRoomH.setValue("");
  else
  {
  //var store=obj.cboOpRoomStore.query("oprDesc",obj.cboOpRoom.getRawValue())
  //var oprId=store.items[0].data.oprId;
  //obj.cboOpRoomH.setValue(oprId);
  }
}
obj.cboLoc_expand=function()
{
 obj.cboLocStore.reload({})
}
obj.cboLoc_select=function()
{
 obj.cboLocH.setValue(obj.cboLoc.getValue());
}
obj.cboLoc_keyup=function()
{
  if(obj.cboLoc.getRawValue()=="")
  obj.cboLocH.setValue("");
}
 
}