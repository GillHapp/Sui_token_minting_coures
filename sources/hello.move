module hello::sui_fren {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{TxContext, sender};
    use std::string::String;
    use std::vector;
    use sui::event;
    use std::option;
    use sui::coin::{Self, TreasuryCap};

    public struct Sui_frenTresuaryCapHolder has key{
        id: UID,
        treasury_cap: TreasuryCap<SUI_FREN>,
    }

    // public struct SuiFren has key {
    //     id: UID,
    //     generation: u64,
    //     birthdate: u64,
    //     attributes: vector<String>,
    // }

    // public struct CANDY has drop {}

    // ✅ THIS is the required one-time witness struct
    public struct SUI_FREN has drop {}

    // ✅ init must NOT be public
    fun init(otw: SUI_FREN, ctx: &mut TxContext): () {
        let (treasury_cap, metadata) = coin::create_currency(
            otw,
            9,
            b"SUI_FREN",
            b"SuiFren Candy",
            b"Candies to level up SuiFren",
            option::none(),
            ctx
        );
        // transfer::public_freeze_object(metadata);
        transfer::public_transfer(metadata, tx_context::sender(ctx));

        let treasury_cap_holder = Sui_frenTresuaryCapHolder {
            id: object::new(ctx),
            treasury_cap: treasury_cap,
        }; // why we do this cause cause treasuty cap has a store key ability so it can be stored in other structs and objects! So the solution here would be to wrap it in a shared object that anyone can access and provide as an argument to the mint function:
        // another thing here is like we metioned that id should be unique for every new instance of Sui_frenTresuaryCapHolder, cause every new user come here and mint there own token so every time new object is created and every new onject shpould have a unique id. 

        transfer::share_object(treasury_cap_holder)

        // transfer::public_transfer(treasury_cap, sender(ctx));
    }

    fun mint(treasury_cap: &mut Sui_frenTresuaryCapHolder, amount: u64 , ctx: &mut TxContext){

        // coin::mint_and_transfer(treasury_cap, amount,  tx_context::sender(ctx), ctx) // this is for only owner can able to mint and get the natve token 
        let trasuray_cap = &mut treasury_cap.treasury_cap;
        coin::mint_and_transfer(trasuray_cap, amount, tx_context::sender(ctx), ctx)
    }

}
