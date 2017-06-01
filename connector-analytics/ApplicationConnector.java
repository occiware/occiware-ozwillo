/**
 * Copyright 2016 Linagora
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Generated at Tue Dec 13 14:38:08 CET 2016 from 
// platform:/plugin/org.occiware.clouddesigner.occi.platform/model/platform.occie by org.occiware.clouddesigner.occi.gen.connector
package net.roboconf.occi.platform.mart;

import java.util.List;

import org.eclipse.emf.common.util.EList;
import org.occiware.clouddesigner.occi.Configuration;
import org.occiware.clouddesigner.occi.Extension;
import org.occiware.clouddesigner.occi.Kind;
import org.occiware.clouddesigner.occi.platform.Component;
import org.occiware.clouddesigner.occi.platform.Status;
import org.occiware.clouddesigner.occi.util.OcciHelper;

import net.roboconf.core.model.beans.Instance;
import net.roboconf.core.model.beans.Instance.InstanceStatus;
import net.roboconf.core.model.helpers.InstanceHelpers;
import net.roboconf.dm.rest.client.WsClient;
import net.roboconf.dm.rest.client.exceptions.ApplicationWsException;

/**
 * Connector implementation for the OCCI kind:
 * - scheme: http://schemas.ogf.org/occi/platform#
 * - term: application
 * - title: Application
 */
public class ApplicationConnector extends org.occiware.clouddesigner.occi.platform.impl.ApplicationImpl {

	WsClient client;
	String applicationName = "apache-bash";

	/**
	 * Constructs a application connector.
	 */
	ApplicationConnector()
	{
		System.out.println("Constructor called on " + this);
		this.client = new WsClient("http://localhost:8181/roboconf-dm");
	}

	//
	// OCCI CRUD callback operations.
	//

	/**
	 * Called when this Application instance is completely created.
	 */
	@Override
	public void occiCreate()
	{
		System.out.println("occiCreate() called on application with name=" + this.getName());
		String name = this.getName();
		if(name != null && name.trim().length() > 0) this.applicationName = name.trim();

		Configuration config = OcciHelper.getConfiguration(this);

		EList<Extension> extensions = config.getUse();
		Extension currentExt = null;
		for (Extension ext : extensions) {
			if (ext.getName().equalsIgnoreCase("platform")) {
				currentExt = ext;
				break;
			}
		}

		if (currentExt != null) {
			System.out.println("Found platform extension !!");

			// Discover instances in Roboconf application...
			// then populate OCCI:platform components
			List<Instance> instances = this.client.getApplicationDelegate().listChildrenInstances(this.applicationName, null, true);
			Kind componentKind = OcciHelper.getKindByTerm(currentExt, "component");

			String prefix = "";
			for(Instance instance : instances) {
				
				String path = InstanceHelpers.computeInstancePath(instance);
				if(path.contains(" on ")) prefix = path;
				else path = prefix + path;
				System.out.println("Roboconf instance found: " + path);
				Component component = (Component)OcciHelper.createEntity(componentKind);
				InstanceStatus stat = instance.getStatus();
				component.setState(stat == InstanceStatus.DEPLOYED_STARTED ? Status.ACTIVE : Status.INACTIVE);
				component.setMessage(path);
				config.getResources().add(component);
				System.out.println("component created: " + component);
			}
		}
		
		this.setState(Status.ACTIVE);
	}

	/**
	 * Called when this Application instance must be retrieved.
	 */
	@Override
	public void occiRetrieve()
	{
		System.out.println("occiRetrieve() called on " + this);

		// TODO: Implement this callback or remove this method.
	}

	/**
	 * Called when this Application instance is completely updated.
	 */
	@Override
	public void occiUpdate()
	{
		System.out.println("occiUpdate() called on " + this);

		// TODO: Implement this callback or remove this method.
	}

	/**
	 * Called when this Application instance will be deleted.
	 */
	@Override
	public void occiDelete()
	{
		System.out.println("occiDelete() called on " + this);

		// TODO: Implement this callback or remove this method.
	}

	//
	// Application actions.
	//

	/**
	 * Implement OCCI action:
     * - scheme: http://schemas.ogf.org/occi/platform/application/action#
     * - term: start
     * - title: Start the application.
	 */
	@Override
	public void start()
	{
		System.out.println("Action start() called on " + this + ", starting ALL instances !");

		try {
			this.client.getApplicationDelegate().deployAndStartAll(this.applicationName, null);
		} catch (ApplicationWsException e) {
			e.printStackTrace(System.err);
		}
	}

	/**
	 * Implement OCCI action:
     * - scheme: http://schemas.ogf.org/occi/platform/application/action#
     * - term: stop
     * - title: Stop the application.
	 */
	@Override
	public void stop()
	{
		System.out.println("Action stop() called on " + this +", stopping ALL instances !" );

		try {
			this.client.getApplicationDelegate().stopAll(this.applicationName, null);
		} catch (ApplicationWsException e) {
			e.printStackTrace(System.err);
		}
	}

}	
