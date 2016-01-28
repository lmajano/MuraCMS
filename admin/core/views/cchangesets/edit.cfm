<!--- This file is part of Mura CMS.

Mura CMS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, Version 2 of the License.

Mura CMS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Mura CMS. If not, see <http://www.gnu.org/licenses/>.

Linking Mura CMS statically or dynamically with other modules constitutes the preparation of a derivative work based on 
Mura CMS. Thus, the terms and conditions of the GNU General Public License version 2 ("GPL") cover the entire combined work.

However, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with programs
or libraries that are released under the GNU Lesser General Public License version 2.1.

In addition, as a special exception, the copyright holders of Mura CMS grant you permission to combine Mura CMS with 
independent software modules (plugins, themes and bundles), and to distribute these plugins, themes and bundles without 
Mura CMS under the license of your choice, provided that you follow these specific guidelines: 

Your custom code 

• Must not alter any default objects in the Mura CMS database and
• May not alter the default display of the Mura CMS logo within Mura CMS and
• Must not alter any files in the following directories.

 /admin/
 /tasks/
 /config/
 /requirements/mura/
 /Application.cfc
 /index.cfm
 /MuraProxy.cfc

You may copy and distribute Mura CMS with a plug-in, theme or bundle that meets the above guidelines as a combined work 
under the terms of GPL for Mura CMS, provided that you include the source code of that other code when and as the GNU GPL 
requires distribution of source code.

For clarity, if you create a modified version of Mura CMS, you are not obligated to grant this special exception for your 
modified version; it is your choice whether to do so, or to make such modified version available under the GNU General Public License 
version 2 without this exception.  You may, if you choose, apply this exception to your own modified versions of Mura CMS.
--->
<cfoutput>
<div class="items-push mura-header">
  <h1><cfif rc.changesetID neq ''>#application.rbFactory.getKeyValue(session.rb,'changesets.editchangeset')#<cfelse>#application.rbFactory.getKeyValue(session.rb,'changesets.addchangeset')#</cfif></h1>

  <div class="mura-item-metadata">
    <div class="label-group">
      
      <cfset csrfTokens= #rc.$.renderCSRFTokens(context=rc.changeset.getchangesetID(),format="url")#>
      <cfinclude template="dsp_secondary_menu.cfm">

    </div><!-- /.label-group -->
  </div><!-- /.mura-item-metadata -->
</div> <!-- /.items-push.mura-header -->

<div class="block block-constrain">

      <cfif not structIsEmpty(rc.changeset.getErrors())>
  <p class="alert alert-error">#application.utility.displayErrors(rc.changeset.getErrors())#</p>
      </cfif>

      <cfif rc.changeset.getPublished()>
      <p class="alert">
      #application.rbFactory.getKeyValue(session.rb,'changesets.publishednotice')#
      </p>
      <cfelse>
  <cfset hasPendingApprovals=rc.changeset.hasPendingApprovals()>
  <cfif hasPendingApprovals>
    <div class="alert alert-error">
        #application.rbFactory.getKeyValue(session.rb,'changesets.haspendingapprovals')# 
    </div>  
  </cfif>
      </cfif>
      
      <cfif len(trim(application.pluginManager.renderEvent("onChangesetEditMessageRender", request.event)))>
        <span id="msg">#application.pluginManager.renderEvent("onChangesetEditMessageRender", request.event)#</span>
      </cfif>

      <cfset tablist="tabBasic">
      <cfset tablabellist="Basic">
      <cfset hasCategories=application.categoryManager.getCategoryCount(rc.siteid)>
      <cfif hasCategories>
    <cfset tablist=listAppend(tablist,'tabCategorization')>
    <cfset tablabellist=listAppend(tablabellist,'Categorization')>
      </cfif>
 <cfset tablist=listAppend(tablist,'tabTags')>
      <cfset tablabellist=listAppend(tablabellist,'Tags')>
      <ul class="mura-tabs nav-tabs nav-tabs-alt initActiveTab" data-toggle="tabs">
    <cfloop from="1" to="#listlen(tabList)#" index="t">
         <li<cfif t eq 1> class="active"</cfif>><a href="###listGetAt(tabList,t)#" onclick="return false;"><span>#listGetAt(tabLabelList,t)#</span></a></li>
    </cfloop>
    </ul>

      <form novalidate="novalidate" action="./?muraAction=cChangesets.save&siteid=#esapiEncode('url',rc.siteid)#" method="post" name="form1" onsubmit="return validate(this);">

      <div class="block-content tab-content">
      <div id="tabBasic" class="tab-pane active">
        <div class="block block-bordered">
          <!-- block header -->
          <div class="block-header bg-gray-lighter">
            <ul class="block-options">
                <li>Something here?</li>
                <li>
                    <button type="button" data-toggle="block-option" data-action="refresh_toggle" data-action-mode="demo"><i class="si si-refresh"></i></button>
                </li>
                <li>
                    <button type="button" data-toggle="block-option" data-action="content_toggle"><i class="si si-arrow-up"></i></button>
                </li>
            </ul>
            <h3 class="block-title">Basic Settings</h3>
          </div> <!-- /.block header -->            
          <div class="block-content">
          <div class="mura-control-group">
            <label>
          #application.rbFactory.getKeyValue(session.rb,'changesets.name')#
        </label>
            <input name="name" type="text" required="true" message="#application.rbFactory.getKeyValue(session.rb,'changesets.titlerequired')#" value="#esapiEncode('html_attr',rc.changeset.getName())#" maxlength="50">
      </div>

          <div class="mura-control-group">
            <label>
          #application.rbFactory.getKeyValue(session.rb,'changesets.description')#
        </label>
            <textarea name="description" rows="6">#esapiEncode('html',rc.changeset.getDescription())#</textarea>
      </div>

          <div class="mura-control-group">
            <label>
    <span data-toggle="popover" title="" data-placement="right" 
      data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.changesetclosedate"))#" 
      data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"changesets.closedate"))#">#application.rbFactory.getKeyValue(session.rb,'changesets.closedate')# <i class="mi-question-circle"></i></span>
          </label>
           <cfif rc.changeset.getPublished()>
              <cfif lsIsDate(rc.changeset.getCloseDate())>
                #LSDateFormat(rc.changeset.getCloseDate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getCloseDate(),"medium")#
              <cfelse>
                 #LSDateFormat(rc.changeset.getLastUpdate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getLastUpdate(),"medium")#
              </cfif>
          <cfelse>
  <!--- TODO GoWest : datepicker custom tag markup : 2016-01-25T12:55:33-07:00 --->                            
             <cf_datetimeselector name="closeDate" datetime="#rc.changeset.getCloseDate()#" defaulthour="23" defaultminute="59">
          
        </cfif>
        </div>

            <div class="mura-control-group">
              <label>
      <span data-toggle="popover" title="" data-placement="right" 
        data-content="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"tooltip.changesetpublishdate"))#" 
        data-original-title="#esapiEncode('html_attr',application.rbFactory.getKeyValue(session.rb,"changesets.publishdate"))#">  
            #application.rbFactory.getKeyValue(session.rb,'changesets.publishdate')# <i class="mi-question-circle"></i></span>
          </label>
          <cfif rc.changeset.getPublished()>
          #LSDateFormat(rc.changeset.getLastUpdate(),session.dateKeyFormat)# #LSTimeFormat(rc.changeset.getLastUpdate(),"medium")#
        <cfelse>
          <cf_datetimeselector name="publishDate" datetime="#rc.changeset.getpublishdate()#">
        </cfif>
            </div>

        </div>
      </div>
      </div> <!--- /.tab-pane --->

      <cfif hasCategories> 
        <div id="tabCategorization" class="tab-pane">

          <div class="block block-bordered">
            <!-- block header -->
            <div class="block-header bg-gray-lighter">
              <ul class="block-options">
                  <li>Something here?</li>
                  <li>
                      <button type="button" data-toggle="block-option" data-action="refresh_toggle" data-action-mode="demo"><i class="si si-refresh"></i></button>
                  </li>
                  <li>
                      <button type="button" data-toggle="block-option" data-action="content_toggle"><i class="si si-arrow-up"></i></button>
                  </li>
              </ul>
              <h3 class="block-title">Categories</h3>
            </div> <!-- /.block header -->            
            <div class="block-content">

              <div class="mura-control-group">
            <!--- Category Filters --->
                <label>#application.rbFactory.getKeyValue(session.rb,'changesets.categoryassignments')#</label>
                <div id="mura-list-tree" class="mura-control justify">
    <!--- TODO GoWest : categories custom tag markup : 2016-01-25T12:56:11-07:00 --->
              <cf_dsp_categories_nest siteID="#rc.siteID#" parentID="" nestLevel="0" categoryid="#rc.changeset.getCategoryID()#">
            </div>
          </div>
        </div>
      </div>

        </div> <!--- /.tab-pane --->
    </cfif>

      <div id="tabTags" class="tab-pane">
   
        <div class="block block-bordered">
          <!-- block header -->
          <div class="block-header bg-gray-lighter">
            <ul class="block-options">
                <li>Something here?</li>
                <li>
                    <button type="button" data-toggle="block-option" data-action="refresh_toggle" data-action-mode="demo"><i class="si si-refresh"></i></button>
                </li>
                <li>
                    <button type="button" data-toggle="block-option" data-action="content_toggle"><i class="si si-arrow-up"></i></button>
                </li>
            </ul>
            <h3 class="block-title">Tags</h3>
          </div> <!-- /.block header -->            
          <div class="block-content">

        <div class="mura-control-group"> 
          <label>
          #application.rbFactory.getKeyValue(session.rb,'sitemanager.content.fields.tags')#
          </label>      
          <input type="text" name="tags">
            <div id="tags" class="mura-control justify tagSelector">
              <cfif len(rc.changeset.getTags())>
                <cfloop list="#rc.changeset.getTags()#" index="i">
                  <span class="tag">
                  #esapiEncode('html',i)# <a><i class="mi-times-circle"></i></a>
                  <input name="tags" type="hidden" value="#esapiEncode('html_attr',i)#">
                  </span>
                </cfloop>
              </cfif>
          </div>

          <script>
          $(document).ready(function(){
            $.get('?muraAction=cChangesets.loadtagarray&siteid=' + siteid).done(function(data){
            var tagArray=eval('(' + data + ')'); 
            $('##tags').tagSelector(tagArray, 'tags');
            });
          });
        </script>
      </div>
    </div>
  </div>
    </div> <!--- /.tab-pane --->

  </div> <!--- /.tab-content --->

      <div class="form-actions">
  <cfif rc.changesetID eq ''>
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'add');" value="#application.rbFactory.getKeyValue(session.rb,'changesets.add')#" /><input type=hidden name="changesetID" value="#rc.changeset.getchangesetID()#">
  <cfelse>
    <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'changesets.delete')#" onclick="confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'changesets.deleteconfirm'))#','./?muraAction=cChangesets.delete&changesetID=#rc.changeset.getchangesetID()#&siteid=#esapiEncode('url',rc.changeset.getSiteID())##csrfTokens#')" /> 
    <input type="button" class="btn" onclick="submitForm(document.forms.form1,'update');" value="#application.rbFactory.getKeyValue(session.rb,'changesets.update')#" />
    <cfif not rc.changeset.getPublished() and not hasPendingApprovals>
      <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'changesets.publishnow')#" onclick="confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'changesets.publishnowconfirm'))#','./?muraAction=cChangesets.publish&changesetID=#rc.changeset.getchangesetID()#&siteid=#esapiEncode('url',rc.changeset.getSiteID())##csrfTokens#')" /> 
    </cfif>
    <cfif rc.changeset.getPublished()>
        <input type="button" class="btn" value="#application.rbFactory.getKeyValue(session.rb,'changesets.rollback')#" onclick="confirmDialog('#esapiEncode('javascript',application.rbFactory.getKeyValue(session.rb,'changesets.rollbackconfirm'))#','./?muraAction=cChangesets.rollback&changesetID=#rc.changeset.getchangesetID()#&siteid=#esapiEncode('url',rc.changeset.getSiteID())##csrfTokens#')" /> 
    </cfif>
     <input type=hidden name="changesetID" value="#rc.changeset.getchangesetID()#">
  </cfif>
  <input type="hidden" name="action" value="">
  #rc.$.renderCSRFTokens(context=rc.changeset.getchangesetID(),format="form")#
      </div>
      </form>

</div> <!-- /.block-constrain -->
</cfoutput>
