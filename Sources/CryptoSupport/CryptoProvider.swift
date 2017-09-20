/**
 *  JavaScriptKit
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import CTLS

/**
 * An object that loads components from OpenSSL on demand.
 */

public class CryptoProvider {

    public enum Component: Int {

        /// The SSL library.
        case ssl

        /// The OpenSSL digests.
        case digests

        /// The OpenSSL ciphers.
        case ciphers

        /// The error descriptions for the Crypto APIs.
        case cryptoErrorStrings

        /// The error descriptions for the SSL APIs.
        case sslErrorStrings

        /// Loads the component.
        func load() {

            switch self {
            case .ssl: SSL_library_init()
            case .digests: OpenSSL_add_all_digests()
            case .ciphers: OpenSSL_add_all_ciphers()
            case .cryptoErrorStrings: ERR_load_crypto_strings()
            case .sslErrorStrings: ERR_load_SSL_strings()
            }

        }

    }

    private var loadedComponents: Set<Component> = []

    /**
     * Loads the specified OpenSSL components if they are not already loaded.
     *
     * - parameter components: The components to load.
     */

    public func load(_ components: Component...) {

        guard components.count > 0 else {
            return
        }

        for component in components {

            guard !loadedComponents.contains(component) else {
                continue
            }

            component.load()
            loadedComponents.insert(component)

        }

    }

}
