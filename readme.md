# iOS Clean Arquitecture implementation

This is a starter template for medium to large sized projects

# Features

- RxSwift
- Realm
- Heavy use of generics
- Carthage
- Alamofire
- Repository Pattern
- VIPER style implementation
- Fakery: Random data generation

# Dependencies

This project uses carthage, for dependency management:

Install: 

```shell
carthage update --platform iOS
```

# Directory Structure

```shell
├── Core
│   ├── Common
│   │   ├── Extensions
│   │   │   ├── PrimitiveExtensions.swift
│   │   │   └── RxSwiftExtensions.swift
│   │   ├── Implementations
│   │   │   ├── FakeableImpls.swift
│   │   │   ├── JSONDecodableImpls.swift
│   │   │   ├── KeyedObjectImpls.swift
│   │   │   ├── RealmPersistableImpls.swift
│   │   │   └── RestfulImpls.swift
│   │   ├── Protocols
│   │   │   ├── Fakeable.swift
│   │   │   ├── KeyedObject.swift
│   │   │   ├── RealmPersistable.swift
│   │   │   └── Restful.swift
│   │   ├── SceneBase
│   │   │   ├── BaseWireframe.swift
│   │   │   ├── PresenterInterface.swift
│   │   │   └── ViewInterface.swift
│   │   └── Constants.swift
│   ├── Managers
│   │   ├── ConfigurationManager.swift
│   │   ├── DataManager.swift
│   │   └── LocationManager.swift
│   ├── Models
│   │   └── MyModel.swift
│   ├── Repository
│   │   ├── Implementations
│   │   │   ├── ApiRepository.swift
│   │   │   ├── MockRepository.swift
│   │   │   └── RealmRepository.swift
│   │   └── Specifications
│   │       ├── AnyRepository.swift
│   │       ├── Repository.swift
│   │       └── RepositoryExtensions.swift
│   └── UseCases
│       ├── Specifications
│       │   └── UseCase.swift
│       ├── GetMyModelsUseCase.swift
│       └── UseCaseFactory.swift
├── Scenes<Paste>
```

