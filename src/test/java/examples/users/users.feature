@regresion
Feature: Automatizar el backend de Pet Store

  Background:
    * url apiPetStore
    * def crearMascotaJSON = read('classpath:examples/jsonData/CrearMascota.json')
    * def ActualizarMascotaJSON = read('classpath:examples/jsonData/ActualizarMascota.json')

  @TEST-1 @happypath @crearMascota
  Scenario: Verificar la creacion de una nueva mascota en Pet Store - OK
    Given path 'pet'
    And request crearMascotaJSON
    When method post
    Then status 200
    And match response.id == 1
    And match response.name == 'Alu'
    And match response.status == 'available'
    * def idPet = response.id
    And print idPet

  @TEST-2 @happypath
  Scenario: Verificar la actualizacion de una mascota existente - OK
    Given path 'pet'
    And request ActualizarMascotaJSON.id = 19
    And request ActualizarMascotaJSON.name = 'Princesa'
    And request ActualizarMascotaJSON.status = 'sold'
    And request ActualizarMascotaJSON
    When method put
    Then status 200
    And print response

  @TEST-3 @happypath
  Scenario Outline: Verificar la busqueda por estatus de mascota: available, sold y pending - OK
    Given path 'pet', 'findByStatus'
    And param status = '<status>'
    When method get
    Then status 200
    And print response

    Examples:
      | status    |
      | available |
      | pending   |
      | sold      |

  @TEST-4 @happypath
  Scenario Outline: Verificar la busqueda por id de mascota - OK
    Given path 'pet/' + '<idPet>'
    When method get
    Then status 200
    And print response

    Examples:
      | idPet |
      | 1     |
      | 19    |
      | 13    |

  @TEST-5 @happypath
  Scenario: Verificar la actualizacion por id de mascota - OK
    * def id = 1
    Given path 'pet', id
    When method get
    Then status 200
    And print response

  @TEST-6 @happypath
  Scenario: Eliminar por id de mascota - OK
    * def id = 19
    Given path 'pet', id
    When method delete
    Then status 200
    And print response

  @TEST-7 @happypath
  Scenario: Subir imagen para una mascota - OK
    * def id = 19
    Given path 'pet', id, 'uploadImage'
    And multipart file file = { read: 'examples/imagenes/Italiana.png', filename: 'examples/imagenes/Italiana.png', contentType: 'image/jpeg' }
    And multipart field additionalMetadata = 'Foto subida'
    When method post
    Then status 200
    And print response


  @TEST-ID @happypath
  Scenario: Verificar la busqueda por id de mascota - OK
    * def idMascota = call read('classpath:examples/users/users.feature@crearMascota')
    Given path 'pet/' + idMascota.idPet
    When method get
    Then status 200
    And print response