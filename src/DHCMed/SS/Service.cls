Class DHCMed.SS.Service Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod Load()
{
	k ^DHCMed.SS.MenusD
	k ^DHCMed.SS.MenusI
	k ^DHCMed.SS.ProductsD
	k ^DHCMed.SS.ProductsI
	k ^DHCMed.SS.SecurityD
	k ^DHCMed.SS.SecurityI
	k ^DHCMed.SS.MenuOperationD
	k ^DHCMed.SS.MenuOperationI
	k ^DHCMed.SS.SecurityOperaD
	k ^DHCMed.SS.SecurityOperaI
	
	//1:Rowid 2:ProCode 3:ProName 4:ProVersion 5:IconClass 6:ShowIndex 7:ProActive 8:ProResume
	set id=##class(DHCMed.SS.Products).Update("^Epdemic^传染病管理^v2.3.0^^3^1^")
	//1:Rowid 2:MenuCode 3:MenuCaption 4:LinkUrl 5:Expression 6:ProductDr 7:ShowIndex 8:IconClass 9:ParentMenuDr
	set mid=##class(DHCMed.SS.Menus).Update("^EpdemicRep^传染病报告^dhc.med.gettree1.csp^^"_id_"^1^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^New^新建")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Edit^编辑")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Delete^删除")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	
	
	set mid=##class(DHCMed.SS.Menus).Update("^InfControl^监控^^^"_id_"^3^^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	
	set mid1=##class(DHCMed.SS.Menus).Update("^InfControl1^日常监控^dhcmed.imppat.imppatcontrol.csp^^"_id_"^1^icon-menu^"_mid)
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid1,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid1_"^New^新建")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid1_"^Edit^编辑")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid1_"^Delete^删除")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	
	
	set mid2=##class(DHCMed.SS.Menus).Update("^InfControl2^监控结论^dhc.med.security.csp?groupId=1^^"_id_"^2^icon-menu^"_mid)
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid2,1)
	
	set id=##class(DHCMed.SS.Products).Update("^DeathReport^医学死亡证明管理^v1.5.0^^2^1^")
	set mid=##class(DHCMed.SS.Menus).Update("^DeathRep^死亡报告^dhc.med.gettree.csp^^"_id_"^1^^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^New^新建")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Edit^编辑")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Delete^删除")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	
	
	set id=##class(DHCMed.SS.Products).Update("^Infection^院内感染管理^v2.6.0^^1^1^")
	set mid=##class(DHCMed.SS.Menus).Update("^InfRep^院感报告^dhcmedinfrepqry.csp^^"_id_"^1^^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^New^新建")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Edit^编辑")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	set oid=##class(DHCMed.SS.MenuOperation).Update("^"_mid_"^Delete^删除")
	set soid=##class(DHCMed.SS.SecurityOpera).Update(1,oid,1)
	
	set mid=##class(DHCMed.SS.Menus).Update("^InfRepCheck^报告审核^dhcmedinsutest.csp^^"_id_"^2^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)	
	
	
	set id=##class(DHCMed.SS.Products).Update("^Systeml^系统管理^v1.1.0^^99^1^")
	set mid=##class(DHCMed.SS.Menus).Update("^Productsl^产品目录^^^"_id_"^1^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	
	set mid=##class(DHCMed.SS.Menus).Update("^Authorityl^菜单授权^dhcmed.main.security.csp^^"_id_"^2^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
	
	set mid=##class(DHCMed.SS.Menus).Update("^Configl^配置项目^^^"_id_"^3^icon-menu^")
	set sid=##class(DHCMed.SS.Security).Update(1,id,mid,1)
}

ClassMethod GetAllProducts() As %String
{
	//^DHCMed.SS.Products	
	set ret=""
	set rowid=$o(^DHCMed.SS.ProductsD(0))
	while rowid'="" {
		set obj=##class(DHCMed.SS.Products).%OpenId(+rowid)
		if $IsObject(obj){
			set ProName=obj.ProName
			set s=rowid_"<$C2>"_ProName
			set ret=ret_"<$C1>"_s
		}
		set rowid=$o(^DHCMed.SS.ProductsD(rowid))
	}
	quit ret
}

ClassMethod BuildProductJson(groupId As %String, ProductId As %String)
{
	new (groupId,ProductId)
	set json=""
	if $d(^DHCMed.SS.SecurityI("IndexOfGPM",groupId,ProductId)){
		 set obj=##class(DHCMed.SS.Products).%OpenId(ProductId)
		 set ProName=obj.ProName
		 set:json'="" json=json_","
		 set json=json_"{"
		 set json=json_"""id"":"""_ProductId_""",""text"":"""_ProName_""","
	     set json=json_"""cls"":""forum-ct"",""iconCls"":""forum-parent"","
	 	 set json=json_"""expanded"":true,""children"":"
	 	 set json=json_..BuildMenuJson(groupId,ProductId,0)
	 	 set json=json_"}"
	}
	quit json
}

ClassMethod BuildMenuJson(groupId As %String, ProductId As %String, ParentId As %String) As %String
{
	new (groupId,ProductId,ParentId)
	set json=""
	//b
	//set rsm=##class(%ResultSet).%New("DHCMed.SS.Menus:QueryByParent")
 	//set %scm=$zobjmethod(rsm,"Execute",ProductId,ParentId)
 	quit:'$d(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId)) "[]"
 	set index=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,""))
 	set menuId=""
 	while (index'="") {
	 	//b   //2
	 	set menuId=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,""))
	 	while (menuId'=""){
		 	set obj=##class(DHCMed.SS.Menus).%OpenId(menuId)
		 	set MenuCaption=obj.MenuCaption
		 	set LinkUrl=obj.LinkUrl
		 	set authority=##class(DHCMed.SS.Security).CheckAuthority(groupId,menuId)
		 	if authority>0{
			 	//b   //3
	 			set:json'="" json=json_","
				set json=json_"{"
				set json=json_"""id"":"""_menuId_""",""text"":"""_MenuCaption_""","
				set json=json_"""iconCls"":""icon-menu"","
	    		//set json=json_"""iconCls"":""icon-forumt"","   ;""linkurl"":"""_LinkUrl_""","
	    		set subjson=##class(DHCMed.SS.Service).BuildMenuJson(groupId,ProductId,menuId)
	    		//w !,"menuId="_menuId
	    		//w !,"subjson="_subjson
	    		if (subjson="[]"){
		    		//w !,"subjson=""""",!!
		    		set json=json_"""leaf"":true,""cls"":""forum"""
		    	}
		    	else{
			    	//w !,"no empty",!!  ""expanded"":true, ""cls"":"""",
			    	set json=json_"""expanded"":true,""leaf"":false,""children"":"_subjson
			    }
	    		//set:subjson='"" json=json_"""children"":["_subjson_"]"
	    		//set:subjson="" json=json_"""leaf"":true"
		 		set json=json_"}"
			}
			set menuId=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index,menuId))
		 }
		 set index=$o(^DHCMed.SS.MenusI("IndexProParentIndex",+ProductId,+ParentId,index))
	 }
	quit "["_json_"]"
}

ClassMethod GetMenuLinkUrl(menuId) As %String [ SqlProc ]
{
	set LinkUrl=""
	set obj=##class(DHCMed.SS.Menus).%OpenId(+menuId)
	if $IsObject(obj){
		set MenuCaption=obj.MenuCaption
		set LinkUrl=obj.LinkUrl
		do obj.%Close()		
		}
	quit LinkUrl
}

//Projection MyProjection As %Projection.Java(ROOTDIR = "d:\temp\java");

}
