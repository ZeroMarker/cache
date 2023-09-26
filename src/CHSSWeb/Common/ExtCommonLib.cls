/// ext公用lib
Class CHSSWeb.Common.ExtCommonLib Extends %RegisteredObject
{

Parameter pExtLibPath = "/scripts/chss/";

ClassMethod LoadCommonJs()
{
	//<!-- 第三方插件CSS start  -->
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href=""../scripts/chss/plugins/dhcgrid/css/ext-patch.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"plugins/flashmessage/Ext.ux.MessageBox.flash.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"plugins/dhcgrid/css/icons.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"plugins/dhcgrid/css/Ext.ux.grid.RowActions.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"plugins/dhcgrid/css/recordform.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"plugins/dhcgrid/js/Ext.ux.form.LovCombo.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"plugins/ComboBoxGrid/ComboBoxGrid.css"" />"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="".."_..#pExtLibPath_"plugins/css/Common.css"" />"
	
	//<!-- 第三方插件CSS end  -->
	//<!--自动加载JS-->
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"JS/AutoLoadJSFrame.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"URL/CSPUrl.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/Patch/ext-patch.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/VType.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/charscode.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/flashmessage/Ext.ux.MessageBox.flash.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/components.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Config/AppConfig.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/CommunitySelect.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/CommonUrlWindow.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"Common/notification/Ext.ux.Notification.js""></script>"
    s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/dhcgrid/js/Ext.ux.grid.RowActions.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/dhcgrid/js/Ext.ux.state.HttpProvider.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/dhcgrid/js/Ext.ux.IconMenu.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/dhcgrid/js/Ext.ux.grid.RecordForm.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/dhcgrid/js/Ext.ux.grid.Search.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/dhcgrid/js/Ext.ux.util.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/dhcgrid/js/Ext.ux.form.LovCombo.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/ImageField/Ext.ux.form.ImageField.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"UploadFile/crossdomain.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/DataTip/Ext.ux.DataTip.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/EditGridPlug/EditGridActiveEditor.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/ComboBoxGrid/ComboBoxGrid.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/DataDrag/Override.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/DataDrag/Ext.ux.DataDrop.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="".."_..#pExtLibPath_"plugins/dhcgrid/js/Ext.ux.form.LovComboEdit.js""></script>"
	
	//<!-- 第三方插件 end  -->


	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

}
