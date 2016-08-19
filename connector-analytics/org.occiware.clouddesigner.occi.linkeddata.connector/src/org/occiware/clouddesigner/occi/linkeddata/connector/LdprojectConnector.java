/**
 * Copyright (c) 2016 Inria
 *  
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 * - Philippe Merle <philippe.merle@inria.fr>
 *
 * Generated at Fri Jun 03 17:38:12 CEST 2016 from platform:/resource/org.occiware.clouddesigner.occi.linkeddata/model/linkeddata.occie by org.occiware.clouddesigner.occi.gen.connector
 */
package org.occiware.clouddesigner.occi.linkeddata.connector;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.stream.Collectors;

import javax.ws.rs.NotFoundException;
import javax.ws.rs.WebApplicationException;

import org.apache.commons.io.IOUtils;
import org.oasis.datacore.common.context.SimpleRequestContextProvider;
import org.oasis.datacore.rest.api.DCResource;
import org.oasis.datacore.rest.api.DatacoreApi;
import org.oasis.datacore.rest.api.util.UriHelper;
import org.oasis.datacore.rest.client.DatacoreCachedClient;
import org.occiware.clouddesigner.occi.Link;
import org.occiware.clouddesigner.occi.infrastructure.Compute;
import org.occiware.clouddesigner.occi.linkeddata.Lddatabaselink;
import org.occiware.clouddesigner.occi.linkeddata.Ldproject;
import org.occiware.clouddesigner.occi.linkeddata.Ldprojectlink;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.security.authentication.TestingAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;

import com.google.common.collect.ImmutableMap;


/**
 * Connector implementation for the OCCI kind:
 * - scheme: http://occiware.org/linkeddata#
 * - term: LDProject
 * - title: 
 */
public class LdprojectConnector extends org.occiware.clouddesigner.occi.linkeddata.impl.LdprojectImpl
{
	/**
	 * Initialize the logger.
	 */
	private static Logger LOGGER = LoggerFactory.getLogger(LdprojectConnector.class);

	private static ClassPathXmlApplicationContext ctx = null;
	private DatacoreCachedClient ldc = null;
	private URI ldContainerUrl = null;
	private String ldContainerUrlString;
	
	/**
	 * Constructs a LDProject connector.
	 */
	LdprojectConnector()
	{
		LOGGER.debug("Constructor called on " + this);
		
		synchronized (LdprojectConnector.class) {
			if (ctx == null) {
				ctx = new ClassPathXmlApplicationContext("oasis-datacore-rest-client-custom-context.xml");
			}
		}
		ldc = (DatacoreCachedClient) ctx.getBean("datacoreApiCachedJsonClient");
		ldContainerUrlString = ctx.getBeanFactory().resolveEmbeddedValue("${datacoreApiClient.containerUrl}");
		try {
			ldContainerUrl = new URI(ldContainerUrlString);
		} catch (URISyntaxException e) {
			LOGGER.error("bad conf " + ldContainerUrlString, e);
			e.printStackTrace();
		}
	}

	//
	// OCCI CRUD callback operations.
	//

	/**
	 * Called when this LDProject instance is completely created.
	 */
	@Override
	public void occiCreate()
	{
		LOGGER.debug("occiCreate() called on " + this);

		// TODO: Implement this callback or remove this method.
	}

	/**
	 * Called when this LDProject instance must be retrieved.
	 */
	@Override
	public void occiRetrieve()
	{
		LOGGER.debug("occiRetrieve() called on " + this);

		// TODO: Implement this callback or remove this method.
	}

	/**
	 * Called when this LDProject instance is completely updated.
	 */
	@Override
	public void occiUpdate()
	{
		LOGGER.debug("occiUpdate() called on " + this);

		// TODO: Implement this callback or remove this method.
	}

	/**
	 * Called when this LDProject instance will be deleted.
	 */
	@Override
	public void occiDelete()
	{
		LOGGER.debug("occiDelete() called on " + this);

		// TODO: Implement this callback or remove this method.
	}

	//
	// LDProject actions.
	//

	/**
	 * Implement OCCI action:
     * - scheme: http://occiware.org/linkeddata/LDProject/action#
     * - term: publish
     * - title: 
	 */
	@Override
	public void publish()
	{
		LOGGER.debug("Action publish() called on " + this);
		
		if (this.published) {
			return; // TODO explode ?
		}
		
		try {

			authenticate();
		      
			// getting DCResource (especially version) :
			DCResource ldResource = ldc.getData("dcmp:Project_0", this.name);
			
			// updating attributes :
			ArrayList<String> frozenModelNames = new ArrayList<String>(2);
			frozenModelNames.add("*");
			ldResource.set("dcmp:frozenModelNames", frozenModelNames);
			
			// saving OCCI resource as DCResource :
			ldResource = ldc.putDataInType(ldResource); // NOT POST else list values are merged, rather replace
			
			this.setPublished(true);
			
		} catch (NotFoundException e) {
			LOGGER.error("NotFoundException", e);
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			LOGGER.error("IllegalArgumentException", e);
			e.printStackTrace();
		} catch (WebApplicationException e) {
			System.out.println(readBodyAsString(e));
			LOGGER.error("WebApplicationException", e);
			e.printStackTrace();
		}
	}

	/**
	 * Implement OCCI action:
     * - scheme: http://occiware.org/linkeddata/LDProject/action#
     * - term: unpublish
     * - title: 
	 */
	@Override
	public void unpublish()
	{
		LOGGER.debug("Action unpublish() called on " + this);

		if (!this.published) {
			return; // TODO explode ?
		}
		
		try {

			authenticate();
		      
			// getting DCResource (especially version) :
			DCResource ldResource = ldc.getData("dcmp:Project_0", this.name);
			
			// updating attributes :
			ldResource.set("dcmp:frozenModelNames", new ArrayList<String>(2));
			
			// saving OCCI resource as DCResource :
			ldResource = ldc.putDataInType(ldResource); // NOT POST else list values are merged, rather replace
			
			this.setPublished(false);
			
		} catch (NotFoundException e) {
			LOGGER.error("NotFoundException", e);
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			LOGGER.error("IllegalArgumentException", e);
			e.printStackTrace();
		} catch (WebApplicationException e) {
			System.out.println(readBodyAsString(e));
			LOGGER.error("WebApplicationException", e);
			e.printStackTrace();
		}
	}

	/**
	 * Implement OCCI action:
     * - scheme: http://occiware.org/linkeddata/LDProject/action#
     * - term: update
     * - title: 
	 */
	@Override
	public void update()
	{
		LOGGER.debug("Action update() called on " + this);
		
		try {
			authenticate();
		    
			DCResource ldResource = getExistingOrNew("dcmp:Project_0", this.name);
			
			updateAttributes(ldResource);
			
			createOrUpdate(ldResource); // saving OCCI resource as DCResource
			
		} catch (IllegalArgumentException e) {
			LOGGER.error("IllegalArgumentException", e);
			e.printStackTrace();
		} catch (WebApplicationException e) {
			System.out.println(readBodyAsString(e));
			LOGGER.error("WebApplicationException", e);
			e.printStackTrace();
		}
	}

	private DCResource getExistingOrNew(String modelType, String name) throws WebApplicationException {
		DCResource resource;
		try {
			resource = ldc.getData(modelType, this.name); // getting DCResource (especially version)
		} catch (NotFoundException e) {
			// preparing new :
			resource = DCResource.create(ldContainerUrl, "dcmp:Project_0", this.name);
		}
		return resource;
	}

	private void createOrUpdate(DCResource resource) throws WebApplicationException {
		if (resource.getVersion() == null || resource.getVersion() < 0) {
			resource = ldc.postDataInType(resource); // create
		} else {
			resource = ldc.putDataInType(resource); // NOT POST else list values are merged, rather replace
		}
	}

	private void updateAttributes(DCResource resource) {
		resource.set("dcmpv:name", this.getName()); // (actually only if creation)			
		///resource.set("dcmp:frozenModelNames", ); // NO ONLY ACTIONS ELSE VOIDS VALUE
		resource.set("dcmpvdb:robust", this.robust);
		///resource.set("dcmpvdb:uri", this.dburi); // rather using links :
		List<Link> lddLinks = this.links.stream().filter(l -> l instanceof Lddatabaselink
				&& l.getTarget() instanceof Compute).collect(Collectors.toList());
		if (!lddLinks.isEmpty()) {
			Lddatabaselink lddLink = (Lddatabaselink) lddLinks.iterator().next();
			Compute customSecondaryCompute = (Compute) lddLink.getTarget();
			if (customSecondaryCompute.getHostname() == null
					|| customSecondaryCompute.getHostname().trim().length() == 0) {
				throw new RuntimeException("Lddatabaselink's target Compute has no hostname");
			}
			String ldDbUri = "mongodb://" + customSecondaryCompute.getHostname()
				+ ":" + lddLink.getPort() + "/" + lddLink.getDatabase();
			resource.set("dcmpvdb:uri", ldDbUri);
		}

		LinkedHashSet<String> lvp = new LinkedHashSet<String>();
		@SuppressWarnings("unchecked")
		List<String> lvpFound = (List<String>) resource.get("dcmp:localVisibleProjects");
		if (lvpFound == null) {
			lvp = new LinkedHashSet<String>();
			lvp.add(UriHelper.buildUri(ldContainerUrl, "dcmp:Project_0", "oasis.meta")); // all projects must see metamodel
		} else {
			lvp = new LinkedHashSet<String>(lvpFound);
		}
		List<String> ldpLinkTargetProjectUris = this.links.stream()
				.filter(l -> l instanceof Ldprojectlink && l.getTarget() instanceof Ldproject)
				.map(ldpl -> UriHelper.buildUri(ldContainerUrl, "dcmp:Project_0", ((Ldproject) ldpl.getTarget()).getName()))
				.collect(Collectors.toList());
		lvp.addAll(ldpLinkTargetProjectUris);
		resource.set("dcmp:localVisibleProjects", lvp);
	}

	private void authenticate() {
        SimpleRequestContextProvider.setSimpleRequestContext(new ImmutableMap.Builder<String, Object>()
              .put(DatacoreApi.PROJECT_HEADER, "oasis.meta") // else no write
              // NB. auth doesn't work like that
              .build()); // else "There is no context" in CxfRequestContextProvider l63, TODO simpler ex. in client
        
        ///MockClientAuthenticationHelper.loginAs("admin");
        String username = "admin";
        String password = "admin";
        User user = new User(username, password, new ArrayList<GrantedAuthority>(0));
        Authentication adminTestAuth = new TestingAuthenticationToken(user, "Basic "
        		+ java.util.Base64.getEncoder().encodeToString((username + ":" + password).getBytes())); // "Basic YWRtaW46YWRtaW4="
        SecurityContextHolder.getContext().setAuthentication(adminTestAuth);
	}

	public static String readBodyAsString(WebApplicationException waex) {
	      Object entity = waex.getResponse().getEntity();
	      if (entity instanceof String) {
	         return (String) entity;
	      }
	      if (entity instanceof InputStream) {
	         try {
	            return IOUtils.toString((InputStream) entity);
	         } catch (IOException e) {
	            throw new RuntimeException(e);
	         }
	      }
	      throw new IllegalArgumentException(); // when ??
	   }
	   
}	
